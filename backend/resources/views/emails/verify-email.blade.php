<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Email Verification</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #1E3A8A; color: white; padding: 20px; text-align: center; }
        .content { padding: 20px; background: #f9f9f9; }
        .verification-button { display: inline-block; background: #1E3A8A; color: white; padding: 12px 24px; text-decoration: none; border-radius: 4px; margin: 20px 0; }
        .verification-button:hover { background: #152a61; }
        .footer { padding: 20px; text-align: center; font-size: 12px; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>UDD Merch Hub</h1>
            <h2>Email Verification</h2>
        </div>
        
        <div class="content">
            <p>Hello {{ $user->name }},</p>
            
            <p>Thank you for registering with UDD Merch Hub! To complete your registration and access all features, please verify your email address by clicking the button below:</p>
            
            <p style="text-align: center;">
                <a href="{{ $verificationUrl }}" class="verification-button">Verify Email Address</a>
            </p>
            
            <p>If the button doesn't work, you can also copy and paste the following link into your browser:</p>
            <p style="word-break: break-all;">{{ $verificationUrl }}</p>
            
            <p style="background-color: #f0f4ff; padding: 15px; border-left: 4px solid #1E3A8A; margin: 20px 0;">
                <strong>Mobile App Users:</strong> When using Gmail or other email apps on your mobile device:
                <br><br>
                1. If clicking the button doesn't work, try opening the link in your device's browser first
                <br>
                2. After verification, you'll be redirected to open the UDD Merch Hub app automatically
                <br>
                3. If redirection fails, simply open the app manually - your email will be verified
            </p>
            
            <p>This verification link will expire in 60 minutes.</p>
            
            <p>If you did not create an account, no further action is required.</p>
            
            <p>Thank you,<br>
            UDD Merch Hub Team</p>
        </div>
        
        <div class="footer">
            <p>This is an automated email. Please do not reply to this message.</p>
            <p>&copy; {{ date('Y') }} UDD Merch Hub. All rights reserved.</p>
        </div>
    </div>
</body>
</html>