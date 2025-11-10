<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Message;
use App\Models\Category;
use App\Models\User;

class MessageController extends Controller
{
    public function index($category_id)
    {
        $messages = Message::where('category_id', $category_id)->with('user')-> orderBy('created_at', 'asc')->get();
        
        return response()->json(['messages' => $messages]);
    }

    public function store(Request $request)
    
    {
         $validator = $request->validate([
            'content' => 'required|string|max:255',
            'category_id' => 'required|exists:categories,id',
            'user_id' => 'required|exists:users,id',
        ]);
        $message = Message::create($validator);   
        return response()->json(['message' => $message]);
    }

    public function show($id)
    
    {
        $message = Message::find($id);
        return response()->json(['message' => $message]);
    }

    public function update(Request $request, $id)
    
    
    {
        $message = Message::find($id);
        $message->update($request->all());
        return response()->json(['message' => $message]);
    }

    public function destroy($id)
    
    
    {
        $message = Message::find($id);
        $message->delete();
        return response()->json(['message' => 'Message deleted successfully']);
    }
}
