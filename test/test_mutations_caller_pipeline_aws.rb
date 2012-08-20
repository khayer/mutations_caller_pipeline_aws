require 'test/unit'
require 'mutations_caller_pipeline_aws'
#require 'rubygems'
require 'redgreen'

class MutationsCallerPipelineAwsTest < Test::Unit::TestCase
  def setup
    @data_path = "test/fixtures/"
    @options = {:index_fa => "HG19.fa", :bwa => "BWA",
    :coverage => "false", :log_file => "log_file",
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
    :account => "-A kyle", :project => "nina", :debug => 1,
    :gatk => "GATK", :samplesheet => "#{@data_path}/SampleSheet_12345.csv"
  }
  end

  def test_hi
    assert_equal  "Hello World!", MutationsCallerPipelineAws.hi
  end

  def test_bwa_caller
    l = BwaCaller.new(@options)
    k = l.call_sampe()
    assert_equal("qsub -o log_file -e log_file_bwa_sampe_errors -hold_jid      bwa_aln_12345 -V -cwd -b y -N bwa_12345 -l h_vmem=6G      -A kyle BWA sampe -f sam HG19 sai_fwd      sai_rev fastq_fwd fastq_rev",k)
    k = l.call_aln(@options[:fastq_fwd],@options[:sai_fwd])
    assert_equal("qsub -pe DJ 8 -o log_file -e log_file_bwa_aln_errors      -V -cwd -b y -N bwa_aln_12345 -l h_vmem=4G -A kyle      BWA aln -t 8 -f sai_fwd HG19 fastq_fwd",k)
  end

  def test_picard_caller
    l = PicardCaller.new(@options)
    k = l.sam_to_bam()
    assert_equal("qsub -o log_file -e log_file_sam_to_bam_errors -V -cwd -b y      -hold_jid bwa_12345 -N sam_to_bam_12345 -l h_vmem=7G      -A kyle java -jar  PICARD/SamFormatConverter.jar      I=sam O=XY.bam VALIDATION_STRINGENCY=LENIENT",k)
    k = l.rg_and_sorting()
    assert_equal("qsub -o log_file -e log_file_rg_sorting_errors -V -cwd -b y      -hold_jid sam_to_bam_12345 -N sort_12345 -l h_vmem=7G      -A kyle java -jar  PICARD/AddOrReplaceReadGroups.jar      I=XY.bam O=XY_sorted.bam SO=coordinate ID=1234      LB=Nugen PL=Illumina PU=ATGATC SM=XY      VALIDATION_STRINGENCY=LENIENT MAX_RECORDS_IN_RAM=1500000",k)
    k = l.mark_dublicates()
    assert_equal("qsub -o log_file -e log_file_duplicates_errors -V -cwd -b y      -hold_jid sort_12345 -N dublicates_12345 -l h_vmem=7G      -A kyle java -jar PICARD/MarkDuplicates.jar      I=XY_sorted.bam O=XY_dubli.bam      M=dublicate.metrics AS=true VALIDATION_STRINGENCY=LENIENT",k)
    k = l.build_index()
    assert_equal("qsub -o log_file -e log_file_index_errors -V -cwd -b y      -hold_jid dublicates_12345 -N index_12345 -l h_vmem=7G      -A kyle java -jar PICARD/BuildBamIndex.jar      I=XY_dubli.bam VALIDATION_STRINGENCY=LENIENT",k)
  end

  def test_gatk_caller
    l = GatkCaller.new(@options)
    k = l.prepare_realign()
    assert_equal("qsub -pe DJ 6 -o log_file -e log_file_prep_realign_errors      -V -cwd -b y -N prep_realignment_12345 -l h_vmem=6G -hold_jid      index_12345 -A kyle java -jar GATK -nt 6      -I XY_dubli.bam --known dbsnp.vcf -R HG19.fa      -T RealignerTargetCreator -o target.intervals",k)
    k = l.realign()
    assert_equal("qsub -o log_file -e log_file_realign_errors -V -cwd -b y      -N realignment_12345 -l h_vmem=7G -hold_jid      prep_realignment_12345 -A kyle java -jar GATK      -I XY_dubli.bam -R HG19.fa -T IndelRealigner      -targetIntervals target.intervals -o realigned.bam",k)
    k = l.prep_recalibration()
    assert_equal("qsub -pe DJ 6 -o log_file -e log_file_prep_recal_errors -V      -cwd -b y -N prep_recal_12345 -l h_vmem=6G -hold_jid      realignment_12345 -A kyle java -jar GATK      -knownSites dbsnp.vcf -I realigned.bam -R HG19.fa -T      BaseRecalibrator -nt 6 -o recal_data.grp",k)
    k = l.recalibration()
    assert_equal("qsub -V -o log_file -e log_file_recal_errors -cwd -b y      -N recal_12345 -l h_vmem=7G -hold_jid prep_recal_12345      -A kyle java -jar GATK -R HG19.fa -I realigned.bam      -T PrintReads -o final.bam -BQSR recal_data.grp",k)
    k = l.genotyper()
    assert_equal("qsub -pe DJ 6 -o log_file -e log_file_genotyper_errors -V      -cwd -b y -N genotyper_12345 -l h_vmem=2G      -hold_jid recal_12345 -A kyle java -jar      GATK -l INFO -R HG19.fa -T UnifiedGenotyper -I final.bam      --dbsnp dbsnp.vcf -o file.vcf -nt 6 --max_alternate_alleles 8      --genotype_likelihoods_model BOTH",k)
    k = l.coverage()
    assert_equal("qsub -o log_file -e log_file_coverage_errors -V -cwd -b y      -N coverage_12345 -l h_vmem=7G -hold_jid recal_12345      -A kyle java -jar GATK -R HG19.fa -T DepthOfCoverage      -I final.bam -o coverage      --omitIntervalStatistics --omitLocusTable --omitDepthOutputAtEachBase",k)
  end

  def test_structurer
    l = Structurer.new()
    assert_raise( RuntimeError ) {l.organize_options(@options)}
    l.structure_paths()
    assert(File.exist?("log"))
    assert(File.exist?("GATK_files"))
    l.organize_options(@options)
    assert_equal(".tmp/XY.sam",@options[:sam_file])
    assert_raise( RuntimeError ) {l.load_options(@options)}
    l.save_options(@options)
    @options = Hash.new()
    @options = l.load_options(@options)
    assert_equal(".tmp/XY.sam",@options[:sam_file])
  end

  def test_structurer_and_caller
    s = Structurer.new()
    s.structure_paths()
    s.organize_options(@options)
    l = BwaCaller.new(@options)
    k = l.call_sampe()
    assert_equal("qsub -o log/XY.log -e log/XY.log_bwa_sampe_errors -hold_jid      bwa_aln_12345 -V -cwd -b y -N bwa_12345 -l h_vmem=6G      -A kyle BWA sampe -f .tmp/XY.sam HG19 .tmp/fwd.sai      .tmp/rev.sai fastq_fwd fastq_rev",k)
    k = l.call_aln(@options[:fastq_fwd],@options[:sai_fwd])
    assert_equal("qsub -pe DJ 8 -o log/XY.log -e log/XY.log_bwa_aln_errors      -V -cwd -b y -N bwa_aln_12345 -l h_vmem=4G -A kyle      BWA aln -t 8 -f .tmp/fwd.sai HG19 fastq_fwd",k)
    l = PicardCaller.new(@options)
    k = l.sam_to_bam()
    assert_equal("qsub -o log/XY.log -e log/XY.log_sam_to_bam_errors -V -cwd -b y      -hold_jid bwa_12345 -N sam_to_bam_12345 -l h_vmem=7G      -A kyle java -jar  PICARD/SamFormatConverter.jar      I=.tmp/XY.sam O=.tmp/raw.bam VALIDATION_STRINGENCY=LENIENT",k)
    k = l.rg_and_sorting()
    assert_equal("qsub -o log/XY.log -e log/XY.log_rg_sorting_errors -V -cwd -b y      -hold_jid sam_to_bam_12345 -N sort_12345 -l h_vmem=7G      -A kyle java -jar  PICARD/AddOrReplaceReadGroups.jar      I=.tmp/raw.bam O=.tmp/sorted.bam SO=coordinate ID=50593_8_N30      LB=C0ME4ACXX PL=Illumina PU=CTTGTA SM=XY      VALIDATION_STRINGENCY=LENIENT MAX_RECORDS_IN_RAM=1500000",k)
    k = l.mark_dublicates()
    assert_equal("qsub -o log/XY.log -e log/XY.log_duplicates_errors -V -cwd -b y      -hold_jid sort_12345 -N dublicates_12345 -l h_vmem=7G      -A kyle java -jar PICARD/MarkDuplicates.jar      I=.tmp/sorted.bam O=.tmp/sorted_dublicates.bam      M=GATK_files/dublicate.metrics AS=true VALIDATION_STRINGENCY=LENIENT",k)
    k = l.build_index()
    assert_equal("qsub -o log/XY.log -e log/XY.log_index_errors -V -cwd -b y      -hold_jid dublicates_12345 -N index_12345 -l h_vmem=7G      -A kyle java -jar PICARD/BuildBamIndex.jar      I=.tmp/sorted_dublicates.bam VALIDATION_STRINGENCY=LENIENT",k)
    l = GatkCaller.new(@options)
    k = l.prepare_realign()
    assert_equal("qsub -pe DJ 6 -o log/XY.log -e log/XY.log_prep_realign_errors      -V -cwd -b y -N prep_realignment_12345 -l h_vmem=6G -hold_jid      index_12345 -A kyle java -jar GATK -nt 6      -I .tmp/sorted_dublicates.bam --known dbsnp.vcf -R HG19.fa      -T RealignerTargetCreator -o GATK_files/target.intervals",k)
    k = l.realign()
    assert_equal("qsub -o log/XY.log -e log/XY.log_realign_errors -V -cwd -b y      -N realignment_12345 -l h_vmem=7G -hold_jid      prep_realignment_12345 -A kyle java -jar GATK      -I .tmp/sorted_dublicates.bam -R HG19.fa -T IndelRealigner      -targetIntervals GATK_files/target.intervals -o .tmp/realigned.bam",k)
    k = l.prep_recalibration()
    assert_equal("qsub -pe DJ 6 -o log/XY.log -e log/XY.log_prep_recal_errors -V      -cwd -b y -N prep_recal_12345 -l h_vmem=6G -hold_jid      realignment_12345 -A kyle java -jar GATK      -knownSites dbsnp.vcf -I .tmp/realigned.bam -R HG19.fa -T      BaseRecalibrator -nt 6 -o GATK_files/recal_data.grp",k)
    k = l.recalibration()
    assert_equal("qsub -V -o log/XY.log -e log/XY.log_recal_errors -cwd -b y      -N recal_12345 -l h_vmem=7G -hold_jid prep_recal_12345      -A kyle java -jar GATK -R HG19.fa -I .tmp/realigned.bam      -T PrintReads -o XY.bam -BQSR GATK_files/recal_data.grp",k)
    k = l.genotyper()
    assert_equal("qsub -pe DJ 6 -o log/XY.log -e log/XY.log_genotyper_errors -V      -cwd -b y -N genotyper_12345 -l h_vmem=2G      -hold_jid recal_12345 -A kyle java -jar      GATK -l INFO -R HG19.fa -T UnifiedGenotyper -I XY.bam      --dbsnp dbsnp.vcf -o XY.vcf -nt 6 --max_alternate_alleles 8      --genotype_likelihoods_model BOTH",k)
    k = l.coverage()
    assert_equal("qsub -o log/XY.log -e log/XY.log_coverage_errors -V -cwd -b y      -N coverage_12345 -l h_vmem=7G -hold_jid recal_12345      -A kyle java -jar GATK -R HG19.fa -T DepthOfCoverage      -I XY.bam -o XY_coverage      --omitIntervalStatistics --omitLocusTable --omitDepthOutputAtEachBase",k)
  end

  def test_sge
    contents = IO.read("#{@data_path}/qstat_output.txt")
    l = SGE.new()
    l.add_job_number("817225")
    k = l.to_s
    assert_equal("Current job_numbers are 817225",k)
    l.add_job_number("12345","54321","816665")
    k = l.parse_qstat(contents)
    assert_equal(["12345","54321","816665"],k)
    contents = IO.read("#{@data_path}/qacct_output.txt")
    k = l.parse_qacct(contents)
    assert !k
    contents = IO.read("#{@data_path}/qacct_output_failed.txt")
    k = l.parse_qacct(contents)
    assert k
    l.delete_job_number("12345")
    k = l.to_s
    assert_equal("Current job_numbers are 817225,54321,816665",k)
  end

  def teardown
    Dir.delete("GATK_files") if File.exists?("GATK_files")
    Dir.delete("log") if File.exists?("log")
    Dir.delete(".tmp") if File.exists?(".tmp")
    File.delete(".options.yml") if File.exists?(".options.yml")
  end

end
