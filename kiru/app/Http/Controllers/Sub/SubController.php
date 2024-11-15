<?php

namespace App\Http\Controllers\Sub;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\PostModel;
use App\Models\SubModel;

class SubController extends Controller
{
    public function subOrUnsub ($userId)
    {
        // авторизованный пользователь
        $currentUser = auth()->user();

        if($currentUser->id == $userId){
            return response ([
                'message' => 'Can\'t subscribed to yourself'
            ], 400);
        }
        // выбранный для подписки пользователь
        $userToSub = User::find($userId);

        if (!$userToSub) {
            return response([
                'message' => 'User not found',
            ], 404);
        }

        // проверка подписки текущего пользователя на выбранного
        $subscription = SubModel::where('user_id', $currentUser->id)
                                 ->where('subscribed_user_id', $userId)
                                 ->first();

        if ($subscription) {
            // Если подписка существует, удаляем её (отписываемся)
            $subscription->isSubscribe = false;
            $subscription->delete();
            return response([
                'message' => 'Successfully unsubscribed from user.',
            ], 200);
        } else {
            // Если подписки нет, создаем её (подписываемся)
            SubModel::create([
                'user_id' => $currentUser->id,
                'subscribed_user_id' => $userId,
                'isSubscribe' => true,
            ]);
            return response([
                'message' => 'Successfully subscribed to user.',
            ], 200);
        }
    }

    public function showSubscribedPosts()
    {
        $currentUser = auth()->user();

        $posts = PostModel::whereIn('user_id', function ($query) use ($currentUser) {
            $query->select('subscribed_user_id')
                  ->from('sub_models') // Здесь исправлено название таблицы
                  ->where('user_id', $currentUser->id);
        })->with('user:id,name,image')->get();

        return response([
            'posts' => $posts,
        ], 200);
    }


    public function checkSubscriptionStatus($userId)
    {
        // авторизованный пользователь
        $currentUser = auth()->user();

        // проверка, не пытается ли пользователь проверить статус подписки на самого себя
        if ($currentUser->id == $userId) {
            return response([
                'message' => 'Cannot check subscription status for yourself'
            ], 400);
        }

        // выбранный пользователь для проверки статуса подписки
        $userToCheck = User::find($userId);

        if (!$userToCheck) {
            return response([
                'message' => 'User not found',
            ], 404);
        }

        // проверка подписки текущего пользователя на выбранного пользователя
        $isSubscribed = SubModel::where('user_id', $currentUser->id)
                                ->where('subscribed_user_id', $userId)
                                ->exists();

        return response([
            'isSubscribed' => $isSubscribed,
        ], 200);
    }



}
