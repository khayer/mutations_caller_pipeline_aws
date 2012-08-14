require 'test/unit'
require 'mutations_caller_pipeline_aws'
require 'rubygems'
require 'redgreen'

class MutationsCallerPipelineAwsTest < Test::Unit::TestCase
  def setup
    @options = {:index_fa => "HG19.fa", :index_vcf => nil, :samtools => nil,
    :bwa => "BWA", :vcf => nil, :account => "", :project => "", :debug => 1,
    :coverage => false, :samplesheet => nil, :log_file => "log_file",
    :job_prefix => "12345", :debug => 1, :sai_fwd => "sai_fwd",
    :sai_rev => "sai_rev", :fastq_fwd => "fastq_fwd", :sample_id => "1234",
    :fastq_rev => "fastq_rev", :sam_file => "sam", :bam_file => "XY.bam",
    :bam_file_sorted => "XY_sorted.bam", :index => "ATGATC",
    :bam_file_sorted_dublicates => "XY_dubli.bam", :library => "Nugen",
    :picard_tools => "PICARD", :sample_name => "XY", :vcf => "file.vcf",
    :dublicate_metrics => "dublicate.metrics", :bwa_prefix => "HG19",
    :dbsnp_file => "dbsnp.vcf", :realigned_bam => "realigned.bam",
    :recal_grp => "recal_data.grp", :final_bam => "final.bam",
    :coverage_prefix => "coverage", :target_intervals => "target.intervals",
    :gatk => "GATK"
  }
  end

  def test_hi
    assert_equal  "Hello World!", MutationsCallerPipelineAws.hi
  end

  def test_bwa_caller
    l = BwaCaller.new(@options)
    k = l.call_sampe()
    assert_equal("qsub -o log_file -e log_file_bwa_sampe_errors -hold_jid      bwa_aln_12345 -V -cwd -b y -N bwa_12345 -l h_vmem=6G      -pe make 3        BWA sampe HG19 sai_fwd sai_rev fastq_fwd fastq_rev      -f sam",k)
    k = l.call_aln(@options[:fastq_fwd],@options[:fastq_rev])
    assert_equal("qsub -pe DJ 8 -o log_file -e log_file_bwa_aln_errors      -V -cwd -b y -N bwa_aln_12345 -l h_vmem=4G       BWA aln -t 8 -f fastq_rev HG19 fastq_fwd",k)
  end

  def test_picard_caller
    l = PicardCaller.new(@options)
    k = l.sam_to_bam()
    assert_equal("qsub -o log_file -e log_file_sam_to_bam_errors -V -cwd -b y      -hold_jid bwa_12345 -N sam_to_bam_12345 -l h_vmem=7G       java -Xmx3g -jar  PICARD/SamFormatConverter.jar      I=sam O=XY.bam VALIDATION_STRINGENCY=LENIENT",k)
    k = l.rg_and_sorting()
    assert_equal("qsub -o log_file -e log_file_rg_sorting_errors -V -cwd -b y      -hold_jid sam_to_bam_12345 -N sort_12345 -l h_vmem=7G       java -Xmx6g -jar  PICARD/AddOrReplaceReadGroups.jar      I=XY.bam O=XY_sorted.bam SO=coordinate ID=1234      LB=Nugen PL=Illumina PU=ATGATC SM=XY      VALIDATION_STRINGENCY=LENIENT",k)
    k = l.mark_dublicates()
    assert_equal("qsub -o log_file -e log_file_duplicates_errors -V -cwd -b y      -hold_jid sort_12345 -N dublicates_12345 -l h_vmem=7G       java -Xmx3g -jar PICARD/MarkDuplicates.jar      I=XY_sorted.bam O=XY_dubli.bam      M=dublicate.metrics AS=true VALIDATION_STRINGENCY=LENIENT",k)
    k = l.build_index()
    assert_equal("qsub -o log_file -e log_file_index_errors -V -cwd -b y      -hold_jid dublicates_12345 -N index_12345 -l h_vmem=7G       java -Xmx3g -jar PICARD/BuildBamIndex.jar      I=XY_dubli.bam VALIDATION_STRINGENCY=LENIENT",k)
  end

  def test_gatk_caller
    l = GatkCaller.new(@options)
    k = l.prepare_realign()
    assert_equal("qsub -pe DJ 6 -o log_file -e log_file_prep_realign_errors      -V -cwd -b y -N prep_realignment_12345 -l h_vmem=6G -hold_jid      index_12345  java -Xmx6g -jar GATK -nt 6      -I XY_dubli.bam --known dbsnp.vcf -R HG19.fa      -T RealignerTargetCreator -o target.intervals",k)
    k = l.realign()
    assert_equal("qsub -o log_file -e log_file_realign_errors -V -cwd -b y      -N realignment_12345 -l h_vmem=7G -hold_jid      prep_realignment_12345  java -Xmx6g -jar GATK      -I XY_dubli.bam -R HG19.fa -T IndelRealigner      -targetIntervals target.intervals -o realigned.bam",k)
    k = l.prep_recalibration()
    assert_equal("qsub -pe DJ 6 -o log_file -e log_file_prep_recal_errors -V      -cwd -b y -N prep_recal_12345 -l h_vmem=6G -hold_jid      realignment_12345  java -Xmx6g -jar GATK      -knownSites dbsnp.vcf -I realigned.bam -R HG19.fa -T      BaseRecalibrator -nt 6 -o recal_data.grp",k)
    k = l.recalibration()
    assert_equal("qsub -V -o log_file -e log_file_recal_errors -cwd -b y      -N recal_12345 -l h_vmem=7G -hold_jid prep_recal_12345       java -Xmx6g -jar GATK -R HG19.fa -I realigned.bam      -T PrintReads -o final.bam -BQSR recal_data.grp",k)
    k = l.genotyper()
    assert_equal("qsub -pe DJ 6 -o log_file -e log_file_genotyper_errors -V      -cwd -b y -N genotyper_12345 -l h_vmem=2G      -hold_jid recal_12345  java -Xmx6g -jar      GATK -l INFO -R HG19.fa -T UnifiedGenotyper -I final.bam      --dbsnp dbsnp.vcf -o file.vcf -nt 6 --max_alternate_alleles 8      --genotype_likelihoods_model BOTH",k)
    k = l.coverage()
    assert_equal("qsub -o log_file -e log_file_coverage_errors -V -cwd -b y      -N coverage_12345 -l h_vmem=7G -hold_jid recal_12345       java -Xmx6g -jar GATK -R HG19.fa -T DepthOfCoverage      -I final.bam --omitDepthOutputAtEachBase -o coverage      --omitIntervalStatistics --omitLocusTable",k)
  end

  def test_structurer
    l = Structurer.new()
    assert_raise( RuntimeError) {l.organize_options(@options)}
    l.structure_paths()
    assert(File.exist?("logs"))
    assert(File.exist?("GATK_files"))
    options = l.organize_options(@options)
    assert_equal(".tmp/XY.sam",options[:sam_file])
  end

  def teardown
    Dir.delete("GATK_files") if File.exists?("GATK_files")
    Dir.delete("logs") if File.exists?("logs")
    Dir.delete(".tmp") if File.exists?(".tmp")
  end

end
