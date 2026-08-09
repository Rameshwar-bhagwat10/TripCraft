Write-Host "Setting up development workspace for TripCraft..."
Set-Location mobile
flutter pub get
Set-Location ../backend
npm install
Set-Location ..
Write-Host "Setup complete!"
