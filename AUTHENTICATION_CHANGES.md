# Authentication Flow Changes

## Summary
The YouTube Clone app has been updated to show the home page before login/signup, while restricting posting features to authenticated users only.

## Key Changes

### 1. Created AuthProvider (`lib/providers/auth_provider.dart`)
- Manages authentication state across the app
- Tracks: `isAuthenticated`, `userId`, `userEmail`, `token`
- Provides `login()` and `logout()` methods

### 2. Updated Main App (`lib/main.dart`)
- Added `MultiProvider` to include both `ThemeProvider` and `AuthProvider`
- Changed initial route from `LoginScreen` to `HomeScreen`
- Added `/login` route for navigation

### 3. Updated HomeScreen (`lib/screens/home_screen.dart`)
- **AppBar Actions**: Shows Login/Sign Up buttons for unauthenticated users, profile icon for authenticated users
- **Floating Action Button**: Added upload button that:
  - Shows login prompt dialog for unauthenticated users
  - Allows upload for authenticated users (placeholder for now)
- **Drawer**: Added logout option for authenticated users

### 4. Updated LoginScreen (`lib/screens/login_screen.dart`)
- Uses `AuthProvider` to update authentication state on successful login
- Navigates back to home screen instead of replacing route
- Preserves browsing context

## User Experience Flow

### Unauthenticated Users Can:
- ✅ Browse videos on home page
- ✅ Search for videos
- ✅ Watch videos
- ✅ Navigate between tabs (Home, Explore, Subscriptions)
- ✅ Access settings

### Unauthenticated Users Cannot:
- ❌ Upload videos (shows login prompt)
- ❌ Access profile features (must login first)

### Authenticated Users Can:
- ✅ All unauthenticated features PLUS:
- ✅ Upload videos
- ✅ Access profile
- ✅ Logout from drawer

## Testing
Run the app with: `.\run_project.ps1`

1. App opens to home page (no login required)
2. Click "Login" or "Sign Up" buttons in AppBar
3. After login, buttons change to profile icon
4. Click FAB (+) button to test upload restriction
5. Open drawer to see logout option (only when logged in)
