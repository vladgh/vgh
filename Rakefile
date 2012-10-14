require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yard'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'tasks')
Dir['tasks/**/*.rake'].each { |task| load task }

RSpec::Core::RakeTask.new

task :default do
  `rake -T`
end

task :test => :spec

desc 'Look for the @todo tag'
task :todo do |task|
  Rake::Task['yard:doc_info'].execute
  YARD::Registry.load!.all.each do |o|
    todo = o.tag(:todo)
    puts "#{todo.object} - #{todo.text}" if todo
  end
end


