require 'rake/testtask'
require 'rubocop/rake_task'

task default: %i[rubocop test]

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['tests/test.rb']
end

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--no-color', '-S', '-a']
end
