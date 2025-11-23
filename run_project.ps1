# Start Backend in a new window
Write-Host "Starting Backend..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "node app.js"

# Wait a moment for backend to initialize
Start-Sleep -Seconds 2

# Start Frontend in a new window
Write-Host "Starting Frontend..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd youtube_clone_app; flutter run -d chrome --web-browser-flag '--disable-web-security' --web-browser-flag '--user-data-dir=C:\tmp\chrome_dev_session'"

Write-Host "Both processes started in separate windows."
