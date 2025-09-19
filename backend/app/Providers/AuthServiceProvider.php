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
            // Only send verification emails to regular users (students), not admin or superadmin
            if ($notifiable->role === 'student') {
                // Replace localhost, 127.0.0.1, or 10.0.2.2 with the server's IP address
                $verificationUrl = str_replace(['localhost', '127.0.0.1', '10.0.2.2'], '192.168.100.3', $url);
                
                return (new MailMessage)
                    ->subject('Verify Email Address')
                    ->view(
                        'emails.verify-email', 
                        ['user' => $notifiable, 'verificationUrl' => $verificationUrl]
                    );
            }
            
            // For admin and superadmin, return null (no email will be sent)
            return null;
        });
    }
}