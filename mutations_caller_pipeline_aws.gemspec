Gem::Specification.new do |s|
  s.name        = "mutations_caller_pipeline_aws"
  s.version     = "0.0.25"
  s.date        = "2012-10-08"
  s.authors     = ["Kaharina Hayer"]
  s.email       = ["katharinaehayer@gmail.com"]
  s.homepage    = "https://github.com/khayer/mutations_caller_pipeline_aws"
  s.summary     = %q{Call Mutations for files.fq}
  s.description = %q{Using BWA to align and GATK to call the bases}
  s.licenses    = ['MIT', 'GPL-2']

  s.rubyforge_project = "mutations_caller_pipeline_aws"

  s.files         = `git ls-files -- {lib,bin}/*`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   << 'mutations_caller_pipeline_aws'
  s.executables   << 'gatk_pipe_only_aws'
  #s.require_paths =  ["lib"]
end
