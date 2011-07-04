require 'nokogiri'
require 'ostruct'

module SolutionGenerator

  def self.generate(solution_name, projects)
    all_projects = projects.map do |project|
      get_referenced_projects(project)
    end
    all_projects.flatten!
    all_projects.uniq! { |p| p.name }
    write_solution_file(solution_name, all_projects)
  end

  def self.get_referenced_projects(project, projects=nil)
    projects = [] if projects == nil

    project = project.gsub('\\', '/')
    contents = File.read(project).gsub(' xmlns="http://schemas.microsoft.com/developer/msbuild/2003"', "")
    xml = Nokogiri::XML(contents)
    projects << create_project(project, File.basename(project), xml.xpath('//Project/PropertyGroup/ProjectGuid').first.text)
    project = projects.last
    xml.xpath('//Project/ItemGroup/ProjectReference').each do |project_reference|
      referenced_project = File.expand_path(project_reference['Include'], File.dirname(project.path))
      projects = get_referenced_projects(referenced_project, projects)
    end
    projects
  end

  def self.create_project(path, name, guid)
    project = OpenStruct.new
    project.name = name
    project.path = path
    project.guid = guid
    project
  end

  def self.write_solution_file(path, projects)
    solution_guid = '{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}'
    configurations = ['Debug|Any CPU', 'Release|Any CPU']
    File.open(path, 'w') do |file|
      file.puts 'Microsoft Visual Studio Solution File, Format Version 10.00'
      file.puts '# Visual Studio 2008'
      projects.each do |project|
        file.puts "Project(\"#{solution_guid}\") = \"#{project.name}\", \"#{project.path}\", \"#{project.guid}\""
        file.puts "EndProject"
      end
      file.puts 'Global'
      file.puts '	GlobalSection(SolutionConfigurationPlatforms) = preSolution'
      configurations.each do |configuration|
        file.puts "    #{configuration} = #{configuration}"
      end
      file.puts '	EndGlobalSection'
      file.puts '	GlobalSection(ProjectConfigurationPlatforms) = postSolution'
      projects.each do |project|
        configurations.each do |configuration|
          file.puts "    #{project.guid}.#{configuration}.ActiveCfg = #{configuration}"
          file.puts "    #{project.guid}.#{configuration}.Build.0 = #{configuration}"
        end
      end
      file.puts '	EndGlobalSection'
      file.puts '	GlobalSection(SolutionProperties) = preSolution'
      file.puts '		HideSolutionNode = FALSE'
      file.puts '	EndGlobalSection'
      file.puts 'EndGlobal'
    end
  end

end
