local M = {}

M.build = [[
!xcodebuild -workspace IosPokedexOld.xcworkspace -scheme IosPokedexOld CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -destination 'platform=iOS Simulator,name=iPhone 14 Pro Max' build
]]


M.run = string.format([[
!xcrun simctl terminate booted gelinger.IosPokedexOld &&
%s
!xcrun simctl install booted ~/Library/Developer/Xcode/DerivedData/IosPokedexOld-apeihcrsmltruvbquztmxtetvvjt/Build/Products/Debug-iphonesimulator/IosPokedexOld.app
!xcrun simctl launch booted gelinger.IosPokedexOld
]], M.build)

M.dev = string.format("!find . -name '*.m' | !entr %s", M.run)

M.addFile = [[
require 'xcodeproj'

project_path = 'IosPokedexOld.xcodeproj' # Replace with your project file path
file_path = %s # Replace with the path to the file you want to add
target_name = 'IosPokedexOld' # Replace with your target name

project = Xcodeproj::Project.open(project_path)
target = project.targets.find { |t| t.name == target_name }

file_ref = project.new_file(file_path)
compile_phase = target.source_build_phase
compile_phase.add_file_reference(file_ref)

project.save

]]

return M
