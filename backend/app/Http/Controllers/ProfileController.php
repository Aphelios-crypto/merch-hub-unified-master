<?php

namespace App\Http\Controllers;

use App\Models\UserProfile;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        $profile = $request->user()->profile;
        return response()->json($profile);
    }

    public function update(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'full_name' => 'nullable|string|max:255',
            'email' => 'nullable|email',
            'bio' => 'nullable|string|max:500',
            'phone_number' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:255',
            'preferences' => 'nullable|array'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = $request->user();
        $profile = $user->profile ?? new UserProfile(['user_id' => $user->id]);
        
        $profile->fill($request->only([
            'full_name',
            'email',
            'bio',
            'phone_number',
            'address',
            'preferences'
        ]));

        $profile->save();

        return response()->json($profile);
    }

    public function uploadAvatar(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'avatar' => 'required|image|max:2048'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = $request->user();
        $profile = $user->profile ?? new UserProfile(['user_id' => $user->id]);

        if ($request->hasFile('avatar')) {
            // Delete old avatar if exists
            if ($profile->avatar_url) {
                Storage::disk('public')->delete($profile->avatar_url);
            }

            // Store new avatar
            $path = $request->file('avatar')->store('avatars', 'public');
            $profile->avatar_url = $path;
            $profile->save();
        }

        return response()->json([
            'avatar_url' => Storage::url($profile->avatar_url)
        ]);
    }

    public function updatePreferences(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'preferences' => 'required|array'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = $request->user();
        $profile = $user->profile ?? new UserProfile(['user_id' => $user->id]);

        $profile->preferences = $request->preferences;
        $profile->save();

        return response()->json($profile);
    }
}