<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubModel extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'subscribed_user_id',
        'isSubscribe',
    ];
}
