<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('user_profiles', function (Blueprint $table) {
            $table->string('birth_date')->nullable();
            $table->string('gender')->nullable();
            $table->string('occupation')->nullable();
            $table->json('interests')->nullable();
            $table->json('social_links')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('user_profiles', function (Blueprint $table) {
            $table->dropColumn([
                'birth_date',
                'gender',
                'occupation',
                'interests',
                'social_links'
            ]);
        });
    }
};
