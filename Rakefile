require 'rake/testtask'
require 'rubocop/rake_task'
require 'reek/rake/task'
require 'flay'
require 'flay_task'
require 'flog'
require 'flog_task'

Rake::TestTask.new(:spec) do |t|
  t.libs = ["lib", "spec"]
  t.name = "spec"
  # t.warning = true
  # t.verbose = true
  t.test_files = FileList['spec/**/*_spec.rb']
end

Rake::TestTask.new(:feature) do |t|
  t.libs = ["lib", "spec"]
  t.name = "feature"
  t.test_files = FileList['spec/feature/**/*_feature.rb']
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = [
    'lib/**/*.rb',
    'spec/**/*.rb'
  ]
  task.formatters = ['simple', 'd']
  task.fail_on_error = true
  # task.options << '--rails'
  task.options << '--display-cop-names'
end

Reek::Rake::Task.new do |t|
  t.config_file = 'config.reek'
  t.source_files = '{app,lib,spec}/**/*.rb'
  t.reek_opts = '--sort-by smelliness -s'
end

FlayTask.new do |t|
  t.verbose = true
  t.dirs = %w(app lib)
  t.threshold = 300 # default is 200
end

FlogTask.new do |t|
  t.verbose = true
  t.threshold = 600 # default is 200; average flog/method more important(?)
  t.instance_variable_set :@methods_only, true
  t.dirs = %w(app lib) # Look, Ma; no tests! Run the tool manually every so often for those.
end

task(:default).clear
task default: [:spec, :rubocop, :reek, :flay, :flog, :feature]
