require 'test/unit'
require 'mutations_caller_pipeline_aws'

class MutationsCallerPipelineAwsTest < Test::Unit::TestCase

  def test_hi
    assert_equal  "Hello World!", MutationsCallerPipelineAws.hi
  end

  def test_bwa_caller
    options = {:mutant_r1 => nil, :mutant_r2 => nil, :index_prefix => nil,
    :index_fa => nil, :index_vcf => nil, :samtools => nil, :gatk => nil,
    :bwa => "NANA", :vcf => nil, :account => "", :project => "", :debug => 1,
    :coverage => false, :samplesheet => nil, :log_file => "Log"}
    l = BwaCaller.new(options)
    l.to_s
    k = BwaCaller.call_sampe()
    puts k
    assert(k)
    #assert(File.exist?("haas"))
  end

  def test_samtools_indexing

  end

  def test_gatk_caller

  end

  def test_create_location_file

  end

end
