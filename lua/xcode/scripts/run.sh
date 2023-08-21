xcrun simctl terminate booted gelinger.IosPokedexOld
./build_script.sh  &&
xcrun simctl install booted ~/Library/Developer/Xcode/DerivedData/IosPokedexOld-apeihcrsmltruvbquztmxtetvvjt/Build/Products/Debug-iphonesimulator/IosPokedexOld.app
xcrun simctl launch booted gelinger.IosPokedexOld
