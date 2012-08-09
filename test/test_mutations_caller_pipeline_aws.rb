require 'test/unit'
require 'mutations_caller_pipeline_aws'
require 'rubygems'
#require 'minitest/autorun'
require 'redgreen'

class MutationsCallerPipelineAwsTest < Test::Unit::TestCase
  def setup
    @options = {:mutant_r1 => nil, :mutant_r2 => nil, :index_prefix => nil,
    :index_fa => nil, :index_vcf => nil, :samtools => nil, :gatk => nil,
    :bwa => "BWA", :vcf => nil, :account => "", :project => "", :debug => 1,
    :coverage => false, :samplesheet => nil, :log_file => "log_file",
    :job_prefix => "12345", :debug => 1, :sai_fwd => "sai_fwd",
    :sai_rev => "sai_rev", :fastq_fwd => "fastq_fwd",
    :fastq_rev => "fastq_rev", :sam_file => "sam"}
  end

  def test_hi
    assert_equal  "Hello World!", MutationsCallerPipelineAws.hi
  end

  def test_bwa_caller
    l = BwaCaller.new(@options)
    k = l.call_sampe()
    assert_equal("qsub -o log_file -e log_file_bwa_sampe_errors -hold_jid      bwa_aln_12345 -V -cwd -b y -N bwa_12345 -l h_vmem=6G      -pe make 3        BWA sampe  sai_fwd sai_rev fastq_fwd fastq_rev      -f sam",k)
    k = l.call_aln(@options[:fastq_fwd],@options[:fastq_rev])
    assert_equal("qsub -pe DJ 8 -o log_file -e log_file_bwa_aln_errors      -V -cwd -b y -N bwa_aln_12345 -l h_vmem=4G       BWA aln -t 8 -f fastq_rev  fastq_fwd",k)
  end

  def test_samtools_indexing

  end

  def test_gatk_caller

  end

  def test_create_location_file

  end

end
