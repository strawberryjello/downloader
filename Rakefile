begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  puts "no RSpec available"
end
