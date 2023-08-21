#!/bin/bash

# Path to the installed app bundle
APP_PATH="/Users/tgelin01/Library/Developer/Xcode/DerivedData/IosPokedexOld-apeihcrsmltruvbquztmxtetvvjt/Build/Products/Debug-iphonesimulator/IosPokedexOld.app"

# Path to the app container
CONTAINER_PATH="/Users/tgelin01/Library/Developer/CoreSimulator/Devices/753FF14E-FDA0-4849-B588-3B6E9E199F7C/data/Containers/Data/Application/12F1D3AF-59D2-4DA1-84FB-5311EAB4670A/Documents/IosPokedexOld.app"

# Copy the resources from the app bundle to the app container
cp -R "$APP_PATH" "$CONTAINER_PATH"

# Optional: Verify the copied resources
if [ -d "$CONTAINER_PATH" ]; then
    echo "Resources copied to the app container successfully."
else
    echo "Failed to copy resources to the app container."
fi

