require 'test/unit'
require 'mutations_caller_pipeline_aws'

class MutationsCallerPipelineAwsTest < Test::Unit::TestCase
  def setup
    @options = {
      :mutant_r1 => "r1.fq",
      :mutant_r2 => "r2.fq",
      :bwa_index => "bwa_index",
      :index_fa => nil,
      :index_vcf => nil,
      :annotation_file => nil,
      :samtools => nil,
      :gatk => nil,
      :bwa => "/path/to/bwa",
      :vcf => nil,
      :account => "",
      :project => "",
      :debug => 1,
      :cluster => false,
      :coverage => false,
      :samplesheet => nil,
      :lsf => true,
      :job_number => 12345,
      :log_file => "log_prefix",
      :threads => 5,
      :sam_file => "sam_file"
    }
  end

  def test_hi
    assert_equal  "Hello World!", MutationsCallerPipelineAws.hi
    #File.delete("haas")
  end

  def test_bwa_caller
    k = BwaCaller.call_mem(@options)
    assert_equal(k, "bsub -M 30000 -n 5 -o log_prefix_bwa_mem_o.log -e log_prefix_bwa_mem_e.log -J bwa_12345 /path/to/bwa mem -t 5 bwa_index r1.fq r2.fq \\> sam_file")
  end

  def test_samtools_indexing

  end

  def test_gatk_caller
    #k = GatkCaller.call("haas", "~/Documents/GATK/dist/GenomeAnalysisTK.jar", "jsjs", "baba", "saa")
    #assert(!k)
  end

  def test_create_location_file

  end
end
