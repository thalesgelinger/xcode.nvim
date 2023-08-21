#!/bin/bash
# xcodebuild -project IosPokedexOld.xcodeproj -scheme IosPokedexOld CODE_SIGN_IDENTITY=”” CODE_SIGNING_REQUIRED=NO -destination 'platform=iOS Simulator,name=iPhone 14 Pro Max'
xcodebuild -workspace IosPokedexOld.xcworkspace -scheme IosPokedexOld CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -destination 'platform=iOS Simulator,name=iPhone 14 Pro Max' build



