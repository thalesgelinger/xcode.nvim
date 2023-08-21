require 'xcodeproj'

project_path = 'IosPokedexOld.xcodeproj' # Replace with your project file path
file_path = ARGV[0]# Replace with the path to the file you want to add
target_name = 'IosPokedexOld' # Replace with your target name

project = Xcodeproj::Project.open(project_path)
target = project.targets.find { |t| t.name == target_name }

file_ref = project.new_file(file_path)
compile_phase = target.source_build_phase
compile_phase.add_file_reference(file_ref)

project.save

