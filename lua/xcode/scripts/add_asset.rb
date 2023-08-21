require 'xcodeproj'
require 'pathname'

# Path to your Xcode workspace file
workspace_path = './IosPokedexOld.xcworkspace'

# Path to your SVG file
svg_file_path = ARGV[0]

# Open the Xcode workspace
workspace = Xcodeproj::Workspace.new_from_xcworkspace(workspace_path)

# Get the main project from the workspace
project_file_references = workspace.file_references.select { |ref| ref.path.end_with?('.xcodeproj') }
if project_file_references.empty?
  puts "No project found in the workspace."
  exit
end

project_path = project_file_references.first.path
project = Xcodeproj::Project.open(project_path)

# Get the main target
target = project.targets.first
if target.nil?
  puts "No target found in the project."
  exit
end

# Get the parent directory of the SVG file
parent_dir = Pathname.new(svg_file_path).dirname

# Create the groups for the file's directory structure
group = project.main_group
parent_dir.each_filename do |dir_name|
  group = group.find_subpath(dir_name, true)
end

# Add the SVG file to the project
file_ref = group.new_file(svg_file_path)

# Set the file's path relative to the group
file_ref.path = File.basename(svg_file_path)

# Save the project file
project.save

puts "SVG file added successfully to the Xcode workspace."

