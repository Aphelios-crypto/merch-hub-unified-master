<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Gate;
use Illuminate\Auth\Notifications\VerifyEmail;
use Illuminate\Notifications\Messages\MailMessage;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The policy mappings for the application.
     *
     * @var array<class-string, class-string>
     */
    protected $policies = [
        // 'App\Models\Model' => 'App\Policies\ModelPolicy',
    ];

    /**
     * Register any authentication / authorization services.
     */
    public function boot(): void
    {
        $this->registerPolicies();

        // Customize the email verification notification
        VerifyEmail::toMailUsing(function ($notifiable, $url) {
            $verificationUrl = $url;
            
            return (new MailMessage)
                ->subject('Verify Email Address')
                ->view(
                    'emails.verify-email', 
                    ['user' => $notifiable, 'verificationUrl' => $verificationUrl]
                );
        });
    }
}