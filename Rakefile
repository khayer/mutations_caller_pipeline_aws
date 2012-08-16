require 'rake/testtask'
`rm mutations_caller_pipeline_aws-*.gem`
`gem build mutations_caller_pipeline_aws.gemspec`
`gem install mutations_caller_pipeline_aws-*.gem`

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
