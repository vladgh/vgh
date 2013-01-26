require 'bundler/gem_helper'
require 'rspec/core/rake_task'
require 'yard'
require 'reek/rake/task'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'tasks')
Dir['tasks/**/*.rake'].each { |task| load task }

RSpec::Core::RakeTask.new
Bundler::GemHelper.install_tasks

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
  t.verbose = false
  t.reek_opts = "--quiet"
end

task :default do
  puts `rake -T`
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


