<?php

namespace App\Http\Controllers\Post;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\PostModel;


class PostController extends Controller
{
        //get all posts
        public function index(Request $request)
           {
               $query = PostModel::orderBy('created_at', 'desc')
                            ->with('user:id,name,image')
                            ->withCount('comments', 'likes')
                            ->with('likes', function($like) {
                                return $like->where('user_id', auth()->user()->id)
                                    ->select('id', 'user_id', 'post_id')->get();
                            });

               if ($request->has('user_id')) {
                   $query->where('user_id', $request->user_id);
               }

               return response([
                   'posts' => $query->get()
               ], 200);
           }
       // get profile posts
       public function getUserProfilePosts($userId) {
           // Получаем публикации указанного пользователя
           $posts = PostModel::where('user_id', $userId)
               ->orderBy('created_at', 'desc')
               ->with('user:id,name,image')
               ->withCount('comments', 'likes')
               ->get();

           return response([
               'posts' => $posts
           ], 200);
       }

   // get correct post
          public function getPofilePostsById($postId) {
              // Получаем конкретную публикацию
              $posts = PostModel::where('id', $postId)
                  ->orderBy('created_at', 'desc')
                  ->with('user:id,name,image')
                  ->withCount('comments', 'likes')
                  ->get();

              return response([
                  'posts' => $posts
              ], 200);
          }


//getPostId
   public function getPostId($postId) {
   //получаем ид конкретной публикации
    $post = PostModel::find($postId);

    return response ([
        'posts' => $post
    ], 200);
   }

   public function createPost(Request $request) {
        $attrs = $request->validate([
        'body' => 'required|string',
        ]);

        $image = $this->saveImage($request->image, 'posts');

        $post = PostModel::create([
            'body' => $attrs['body'],
            'image' => $image,
            'user_id' => auth()->user()->id,
        ]);

        return response([
            'message' => 'Post created',
            'post' => $post
        ], 200);
   }

   public function updatePost(Request $request, $id) {
    $post = PostModel::find($id);

    if(!$post)
    {
        return response([
            'message' => 'Post not found',
        ], 404);
    }

    if($post->user_id != auth()->user()->id)
    {
        return response ([
            'message' => 'Permission denied',
        ], 403);
    }

    $attrs = $request->validate([
        'body' => 'required|string',
    ]);

    $post->update([
        'body' => $attrs['body'],
    ]);

    return response([
        'message' => 'Post updated.',
        'post' => $post
    ], 200);

   }

   public function deletePost ($id) {
    $post = PostModel::find($id);

    if(!$post)
    {
        return response ([
            'message' => 'Post not found',
        ], 404);
    }

    if($post->user_id != auth()->user()->id)
    {
        return response ([
            'message' => 'Permission denied',
        ], 403);
    }

    $post->likes()->delete();
    $post->comments()->delete();
    $post->delete();

    return response ([
        'message' => 'Post deleted!',
    ], 200);
   }
}
