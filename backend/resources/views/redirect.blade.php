<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate, max-age=0">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Email Verified Successfully</title>
    <script type="text/javascript">
        // Log the redirection attempt
        console.log('Attempting to redirect to: {{ $url }}');
        
        // Function to try opening the app
        function tryOpenApp() {
            // Try to open the app using the custom URL scheme
            window.location.href = "{{ $url }}";
            
            // Set a timeout to detect if the app didn't open
            setTimeout(function() {
                document.getElementById('manual-instructions').style.display = 'block';
            }, 3000);
        }
        
        // Try to open the app with a delay to ensure the page loads first
        setTimeout(tryOpenApp, 1000);
    </script>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #1E3A8A;
        }
        p {
            margin: 20px 0;
            line-height: 1.6;
        }
        .button {
            display: inline-block;
            background: #1E3A8A;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 4px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>UDD Merch Hub</h1>
        <h2>Email Verification</h2>
        
        <p>Your email has been verified successfully!</p>
        
        <p>Redirecting to the app...</p>
        
        <div id="manual-instructions" style="display: none; margin-top: 20px; padding: 15px; background-color: #f0f4ff; border-left: 4px solid #1E3A8A;">
            <h3>App didn't open?</h3>
            <p>Follow these steps:</p>
            <ol style="text-align: left;">
                <li>Open the UDD Merch Hub app on your device</li>
                <li>Login using your email and password</li>
                <li>Your email has already been verified</li>
            </ol>
            <a href="{{ $url }}" class="button">Try Again</a>
            
            <div id="debug-info" style="margin-top: 30px; padding: 15px; background: #f8f8f8; border: 1px solid #ddd; text-align: left;">
                <h3>Troubleshooting Information</h3>
                <p>Redirection URL: <code>{{ $url }}</code></p>
                <p>If you're experiencing issues, please try these steps:</p>
                <ol>
                    <li>Make sure you have the app installed on your device</li>
                    <li>Try copying and pasting the URL into your browser: <code>{{ $url }}</code></li>
                    <li>If using Android, check that the app has permission to handle deep links</li>
                </ol>
            </div>
        </div>
        
        <p>If you are not redirected automatically, please click the button below:</p>
        
        <a href="{{ $url }}" class="button">Open App</a>
    </div>
</body>
</html>