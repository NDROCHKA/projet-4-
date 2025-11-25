# Start Backend in a new window
Write-Host "Starting Backend..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "node app.js"

# Wait a moment for backend to initialize
Start-Sleep -Seconds 3

# Start Frontend in a new window (simplified - no web security flags)
Write-Host "Starting Frontend..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd youtube_clone_app; flutter run -d chrome"

Write-Host "Both processes started in separate windows."
