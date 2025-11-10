<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\CategoryController;
use App\Http\Controllers\API\MessageController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
    Route::get('/categories', [CategoryController::class, 'index']);
    Route::get('/categories/{id}', [CategoryController::class, 'show']);
    Route::post('/categories/create', [CategoryController::class, 'store']);
    Route::get('/messages/{category_id}', [MessageController::class, 'index']);
    //Route::get('/messages/{category_id}/{id}', [MessageController::class, 'store']);
    Route::post('/messages', [MessageController::class, 'store']);
    //Route::put('/messages/{id}', [MessageController::class, 'update']);
    //Route::delete('/messages/{id}', [MessageController::class, 'destroy']);
});