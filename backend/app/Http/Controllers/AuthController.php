<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|unique:users',
            'password' => 'required|string|min:6|confirmed',
            'department_id' => 'required|exists:departments,id',
            'role' => 'required|in:student,admin,superadmin',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'department_id' => $validated['department_id'],
            'role' => $validated['role'],
        ]);

        // Create user profile with registration information
        $user->profile()->create([
            'full_name' => $validated['name'],
            'email' => $validated['email'],
        ]);

        // Load department relationship for session data
        $user->load(['department', 'profile']);

        // Send email verification notification
        $user->sendEmailVerificationNotification();

        // Generate token using Sanctum
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user->getSessionData(),
            'token' => $token,
            'message' => 'Registration successful. Please check your email to verify your account.',
        ], 201);
    }


    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if (!Auth::attempt($credentials)) {
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        $user = Auth::user();
        
        // Check if email is verified
        if (!$user->hasVerifiedEmail()) {
            // Resend verification email
            $user->sendEmailVerificationNotification();
            
            return response()->json([
                'message' => 'Email not verified. A new verification link has been sent to your email address.',
                'email_verified' => false
            ], 403);
        }
        
        // Load department and profile relationships for session data
        $user->load(['department', 'profile']);

        // Create profile if it doesn't exist
        if (!$user->profile) {
            $user->profile()->create([
                'full_name' => $user->name,
                'email' => $user->email,
            ]);
            $user->load('profile');
        }
        
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user->getSessionData(),
            'token' => $token,
            'email_verified' => true
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();
        return response()->json(['message' => 'Logged out']);
    }
}