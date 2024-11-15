<?php

namespace App\Http\Controllers\Comment;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Comment;
use App\Models\PostModel;


class CommentController extends Controller
{
    //showComment
    public function showComment($id)
    {
        $post = PostModel::find($id);

        if(!$post)
        {
            return response ([
                'message' => 'Post not found',
            ], 404);
        }
        return response([
            'comments' => $post->comments()->with('user:id,name,image')->get(),
        ], 200);
    }
//createComment
    public function createComment(Request $request, $id)
    {
        $post = PostModel::find($id);

        if(!$post)
        {
            return response([
                'message' => 'Post not found'
            ], 404);
        }

        if($post->user_id != auth()->user()->id)
        {
            return response([
                'message' => 'Permission denied',
            ], 403);
        }

        $attrs = $request->validate([
            'comment' => 'required|string',
        ]);

        $comment = Comment::create([
            'user_id' => auth()->user()->id,
            'post_id' => $id,
            'comment' => $attrs['comment'],
        ]);

        return response ([
            'message' => 'Comment published!',
            'comment' => $attrs['comment'],
        ], 200);
    }

//changeComment
    public function changeComment($id, Request $request)
    {
        $comment = Comment::find($id);

        if(!$comment)
        {
            return response ([
                'message' => 'Comment not found',
            ], 404);
        }

        if($comment->user_id != auth()->user()->id)
        {
            return response ([
                'message' => 'Permission denied',
            ], 403);
        }

        $attrs = $request->validate([
            'comment' => 'required|string',
        ]);

        $comment->update([
            'comment' => $attrs['comment'],
        ]);

        return response ([
        'message' => 'Comment changed',
        'comment' => $attrs['comment'],
        ], 200);
    }

    public function deleteComment($id)
    {
        $comment = Comment::find($id);

        if(!$comment)
        {
            return response ([
                'message' => 'Comment not found'
            ],404);
        }

        if($comment->user_id != auth()->user()->id)
                {
                    return response ([
                        'message' => 'Permission denied',
                    ],403);
                }

        $comment->delete();

        return response ([
            'message' => 'Success deleted a comment',
        ], 200);
    }
}
