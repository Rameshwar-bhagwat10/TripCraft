#!/bin/bash
echo "Running code generation..."
cd mobile && flutter pub run build_runner build --delete-conflicting-outputs
