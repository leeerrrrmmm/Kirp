<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'about',
        'image',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    // Оригинальный метод для получения подписок
    public function SubModel()
    {
        return $this->belongsToMany(User::class, 'sub_models', 'user_id', 'subscribed_user_id');
    }

    // Метод для получения подписчиков
    public function followers()
    {
        return $this->belongsToMany(User::class, 'sub_models', 'subscribed_user_id', 'user_id');
    }

    // Метод для подсчета количества подписок
    public function subscribedCount()
    {
        return $this->SubModel()->count();
    }

    // Метод для подсчета количества подписчиков
    public function followersCount()
    {
        return $this->followers()->count();
    }

    public function isSubscribedTo($userId)
    {
        return $this->SubModel()
                    ->where('subscribed_user_id', $userId)
                    ->where('isSubscribe', true)
                    ->exists();
    }

}
