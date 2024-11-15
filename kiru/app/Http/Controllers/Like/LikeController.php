<?php

namespace App\Http\Controllers\Like;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\PostModel;
use App\Models\Like;

class LikeController extends Controller
{
    public function likeOrUnlike($id)
    {
        $post = PostModel::find($id);

        if(!$post)
        {
            return response ([
                'message' => 'Post not found',
            ], 403);
        }

    $like = $post->likes()->where('user_id', auth()->user()->id)->first();

        if(!$like)
        {
            Like::create([
                'post_id' => $id,
                'user_id' => auth()->user()->id,
            ]);

            return response ([
                'message' => 'Liked',
            ], 200);
        }else
            {
                $like->delete();

                return response ([
                'message' => 'Unliked',
                ], 200);
            }
    }

    public function showLikesPosts() {
            $user = auth()->user();

            $likedPosts = PostModel::whereHas('likes', function($query) use ($user) {
                $query->where('user_id', $user->id);
            })
            ->with('user:image,id,name')
            ->get();

            return response ([
            'posts' => $likedPosts,
            ], 200);

    }
}
