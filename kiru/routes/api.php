<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\Post\PostController;
use App\Http\Controllers\Like\LikeController;
use App\Http\Controllers\Comment\CommentController;
use App\Http\Controllers\Sub\SubController;

    //log&reg
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
//group middleware
Route::group(['middleware' => ['auth:sanctum']], function() {


//user things
    Route::get('/getUser', [AuthController::class, 'userDetail']);
    Route::get('/getUserById/{id}', [AuthController::class, 'getUserById']);
    Route::put('/updateUser', [AuthController::class, 'updateUser']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::delete('/deleteUser/{id}', [AuthController::class, 'deleteUser']);
//post things
    Route::get('/getPosts', [PostController::class, 'index']);
    Route::get('/getPofilePostsById/{id}', [PostController::class, 'getPofilePostsById']);
    Route::get('/getPostId/{id}', [PostController::class, 'getPostId']);
    Route::post('/createPost', [PostController::class, 'createPost']);
    Route::put('/updatePost/{id}', [PostController::class, 'updatePost']);
    Route::delete('/deletePost/{id}', [PostController::class, 'deletePost']);
//like things
    Route::post('/likeOrUnlike/{id}', [LikeController::class, 'likeOrUnlike']);
    Route::get('/getLikedPost', [LikeController::class, 'showLikesPosts']);
//comment things
    Route::get('/getCom/{id}', [CommentController::class, 'showComment']);
    Route::post('/createComment/{id}', [CommentController::class, 'createComment']);
    Route::put('/changeCom/{id}', [CommentController::class, 'changeComment']);
    Route::delete('/deleteCom/{id}', [CommentController::class, 'deleteComment']);

//comment things
    Route::post('/subOrUnsub/{id}', [SubController::class, 'subOrUnsub']);
    Route::get('/showSubscribedPosts', [SubController::class, 'showSubscribedPosts']);
    Route::get('/checkSubscriptionStatus/{id}', [SubController::class, 'checkSubscriptionStatus']);
});

