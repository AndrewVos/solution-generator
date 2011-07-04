# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "solution-generator/version"

Gem::Specification.new do |s|
  s.name        = "solution-generator"
  s.version     = Solution::Generator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew Vos"]
  s.email       = ["andrew.vos@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Generates smaller solution files for large enterprisey .NET solutions}
  s.description = %q{Generates smaller solution files for large enterprisey .NET solutions}

  s.rubyforge_project = "solution-generator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.bindir        = 'bin'
  s.add_dependency 'nokogiri'
end
