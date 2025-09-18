<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('user_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('avatar_url')->nullable();
            $table->string('full_name')->nullable();
            $table->string('email')->nullable();
            $table->string('bio', 500)->nullable();
            $table->string('phone_number')->nullable();
            $table->string('address')->nullable();
            $table->json('preferences')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('user_profiles');
    }
};