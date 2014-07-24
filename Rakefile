require 'bundler/setup'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec/core/rake_task'

desc "run specs expected to pass; use ROPTS=\"-l 15\" for line 15" 
RSpec::Core::RakeTask.new(:passing) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb", "-t ~wip", "#{ENV['ROPTS']}"]
end

desc "run all wip specs; use ROPTS=\"-l 15\" for line 15" 
RSpec::Core::RakeTask.new(:wip) do |spec|
  spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb", "-t wip", "#{ENV['ROPTS']}"]
end

task :spec => :passing
task :rspec => :passing
task :default => :passing
