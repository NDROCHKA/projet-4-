# Manual Run Instructions

## The Flutter crash you're seeing is a Chrome debugging issue, NOT a code problem!

## Quick Fix - Run Manually

### Option 1: Use Updated Script (Recommended)
```powershell
.\run_project.ps1
```

The script has been updated to remove the problematic Chrome flags.

---

### Option 2: Run Manually in Separate Terminals

#### Terminal 1 - Backend:
```powershell
cd c:\Users\JBZLB\OneDrive\Desktop\csc388backend
node app.js
```
Wait for: "Server is running on port 3500"

#### Terminal 2 - Frontend:
```powershell
cd c:\Users\JBZLB\OneDrive\Desktop\csc388backend\youtube_clone_app
flutter run -d chrome
```

---

### Option 3: Run in Edge Instead of Chrome
```powershell
cd c:\Users\JBZLB\OneDrive\Desktop\csc388backend\youtube_clone_app
flutter run -d edge
```

---

## What Was Wrong?

The Chrome flags `--disable-web-security` and `--user-data-dir` were causing:
```
DartDevelopmentServiceException: Failed to start Dart Development Service
```

This is a known Flutter issue with certain Chrome configurations.

---

## After Running

1. **Backend should show:**
   ```
   Server is running on port 3500
   Data base connected succesfully
   ```

2. **Frontend should show:**
   ```
   Launching lib\main.dart on Chrome in debug mode...
   ```

3. **Chrome will open automatically** with your app

---

## Testing the Fix

Once the app loads:
1. You should see the home page with videos (if any exist in DB)
2. Login/Sign Up buttons in the top right
3. No authentication errors

If you see "No videos found" but NO errors, it means:
- ✅ Backend is working
- ✅ Frontend is working  
- ❌ Database has no videos yet

To add videos, login and click the + button!
