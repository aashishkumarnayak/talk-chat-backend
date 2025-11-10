<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
class AuthController extends Controller
{
    public function register(Request $request)
    {
       $validator = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
        ]);
       // $user = User::create($validator);
       $user = User::create([
        'name' => $validator['name'],
        'email' => $validator['email'],
        'password' => Hash::make($validator['password']),
       ]);
       $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'User registered successfully', 
            'token' => $token,
             'user' => $user],
              201);
    }

    public function login(Request $request)
    {
        $validator =$request->validate([
            'email' => 'required|string|email|max:255',
            'password' => 'required|string|min:8',
        ]);
        $user = User::where('email', $request->email)->first();
        if (!$user||!Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'User not found'], 401);
        }
        $token = $user->createToken('auth_token')->plainTextToken;
        return response()->json([
            'message' => 'Logged in successfully '.$user->name,
             'user' => $user,
              'token' => $token],
              200
            );
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out successfully']);
    }

    public function user(Request $request)
    {
        return response()->json(['user' => $request->user()]);
    }
}
