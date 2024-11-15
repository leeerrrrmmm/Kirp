<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PostModel extends Model
{
     use HasFactory;

    protected $fillable = [
    'body',
    'user_id',
    'image',

    ];

    public function user ()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function comments ()
    {
        return $this->hasMany(Comment::class, 'post_id');
    }

    public function likes ()
    {
        return $this->hasMany(Like::class, 'post_id');
    }
}
