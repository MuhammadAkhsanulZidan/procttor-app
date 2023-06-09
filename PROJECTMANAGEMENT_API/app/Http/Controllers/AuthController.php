<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    //Register user
    public function signup(Request $request)
    {
        //validate fields
        $attrs = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required'
        ]);

        //create user
        $user = User::create([

            'name' => $attrs['name'],
            'email' => $attrs['email'],
            'password' => bcrypt(($attrs['password']))
        ]);

        //return user & token in response
        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken
        ], 200);
    }

    public function login(Request $request)
    {
        //validate fields
        $attrs = $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        if (!Auth::attempt($attrs)) {
            return response([
                'message' => 'invalid credentials.',
            ], 403);
        }

        //return user & token in response
        return response([
            'user' => auth()->user(),
            'token' => auth()->user()->createToken('secret')->plainTextToken
        ], 200);
    }

    //logout
    public function logout()
    {
        auth()->user()->tokens()->delete();
        return response([
            'message' => 'logout success'
        ], 200);
    }

    // get user detail
    public function user()
    {
        return response([
            'user' => auth()->user()
        ], 200);
    }
}