# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = %w[lib test]
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
  t.warning = true
end
