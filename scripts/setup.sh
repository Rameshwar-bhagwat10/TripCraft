#!/bin/bash
echo "Setting up development workspace for TripCraft..."
cd mobile && flutter pub get
cd ../backend && npm install
echo "Setup complete!"
