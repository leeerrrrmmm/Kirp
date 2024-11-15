<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function register(Request $request)
     {
     //validate
        $attrs = $request->validate([
        'name' => 'required|string',
        'email' => 'required|email|unique:users,email',
        'password' => 'required|min:6|confirmed',
        ]);
    //create User
    $user = User::create([
        'name' => $attrs['name'],
        'email' => $attrs['email'],
        'password' => bcrypt($attrs['password'])

    ]);

    //show data
    return response ([
        'user' => $user,
        'token' => $user->createToken('secret')->plainTextToken
    ], 200);
  }

public function login (Request $request) {

        $attrs = $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6'
        ]);

         if(!Auth::attempt($attrs))
                {
                    return response([
                        'message' => 'Invalid credentials.'
                    ], 403);
                }

    return response ([
        'user' => auth()->user(),
        'token' => auth()->user()->createToken('secret')->plainTextToken
    ], 200);

    }

    public function logout () {
        auth()->user()->tokens()->delete();
        return response([
             'message' => 'Success logout'
             ],200);


    }


    public function updateUser (Request $request) {

     $user = auth()->user();

        $attrs = $request->validate([
            'name' => 'required|string',
            'about' => 'required|string',
            'image' => 'nullable|string',
        ]);

        $image = $this->saveImage($request->image, 'profiles');


        auth()->user()->update([
            'name' => $attrs['name'],
            'about' => $attrs['about'],
            'image' => $image,
        ]);

        return response ([
            'message' => 'Updated Success',
             'user' => [
                     'id' => $user->id,
                     'name' => $user->name,
                     'email' => $user->email,
                     'image' => $user->image,
                     'about' => $user->about,

                    ]
        ], 200);


    }

   public function userDetail() {
      $user = auth()->user();
             return response([
                 'user' => [
                     'id' => $user->id,
                     'name' => $user->name,
                     'email' => $user->email,
                     'image' => $user->image,
                     'about' => $user->about,
                     'email_verified_at' => $user->email_verified_at,
                     'created_at' => $user->created_at,
                     'updated_at' => $user->updated_at,
                     'followers_count' => $user->followersCount(),
                     'following_count' => $user->subscribedCount(),

                 ]
             ], 200);
   }

    public function getUserById($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response([
                'message' => 'User not found',
            ], 404);
        }

        return response([
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'image' => $user->image,
                'followers_count' => $user->followersCount(), // количество подписчиков
                'following_count' => $user->subscribedCount(), // количество подписок

            ],
        ], 200);
    }

public function deleteUser ($id) {
    $user = User::find($id);

    if(!$user){
        return response ([
            'message' => 'User not found',
        ], 400);
    }

    if($user->id != auth()->user()->id)
    {
        return response ([
            'message' => 'Permission denied',
        ], 403);
    }

        $user->delete();
        return response ([
            'message' => 'User success deleted!',
        ],200);

}






}
