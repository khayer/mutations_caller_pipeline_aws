=begin
  * Name: GATKCaller, part of Mutations Caller Pipeline (AWS)
  * Template to call GATK
  * Author: Katharina Hayer
  * Date: 8/13/2012
  * License: GNU General Public License (GPL-2.0)
=end

class GatkCaller < Caller

  def initialize(options)
    super(options)
    @gatk = options[:gatk]
    # INDEX is normal genom.fa
    @index_fa = options[:index_fa]
    @bam_file_sorted_dublicates = options[:bam_file_sorted_dublicates]
    @dbsnp_file = options[:dbsnp_file]
    @target_intervals = options[:target_intervals]
    @realigned_bam = options[:realigned_bam]
    @recal_grp = options[:recal_grp]
    @final_bam = options[:final_bam]
    @vcf = options[:vcf]
    @coverage_prefix = options[:coverage_prefix]
  end

  # Preparation realignement
  def prepare_realign()
    cmd = "qsub -pe DJ 6 -o #{@log_file} -e #{@log_file}_prep_realign_errors \
     -V -cwd -b y -N prep_realignment_#{@job_prefix} -l h_vmem=6G -hold_jid \
     index_#{@job_prefix} #{@account} java -Xmx6g -jar #{@gatk} -nt 6 \
     -I #{@bam_file_sorted_dublicates} --known #{@dbsnp_file} -R #{@index_fa} \
     -T RealignerTargetCreator -o #{@target_intervals}"
  end

  # Realignment
  # parallel not possible yet (1.6-13-g91f02df)
  def realign()
    cmd = "qsub -o #{@log_file} -e #{@log_file}_realign_errors -V -cwd -b y \
     -N realignment_#{@job_prefix} -l h_vmem=7G -hold_jid \
     prep_realignment_#{@job_prefix} #{@account} java -Xmx6g -jar #{@gatk} \
     -I #{@bam_file_sorted_dublicates} -R #{@index_fa} -T IndelRealigner \
     -targetIntervals #{@target_intervals} -o #{@realigned_bam}"
  end

  # Preparing of recalibration; outfile: -o recal_data.grp
  def prep_recalibration()
    cmd = "qsub -pe DJ 6 -o #{@log_file} -e #{@log_file}_prep_recal_errors -V \
     -cwd -b y -N prep_recal_#{@job_prefix} -l h_vmem=6G -hold_jid \
     realignment_#{@job_prefix} #{@account} java -Xmx6g -jar #{@gatk} \
     -knownSites #{@dbsnp_file} -I #{@realigned_bam} -R #{@index_fa} -T \
     BaseRecalibrator -nt 6 -o #{@recal_grp}"
  end

  # Actual recalibration
  # parallel not possible yet (1.6-13-g91f02df)
  def recalibration()
    cmd = "qsub -V -o #{@log_file} -e #{@log_file}_recal_errors -cwd -b y \
     -N recal_#{@job_prefix} -l h_vmem=7G -hold_jid prep_recal_#{@job_prefix} \
     #{@account} java -Xmx6g -jar #{@gatk} -R #{@index_fa} -I #{@realigned_bam} \
     -T PrintReads -o #{@final_bam} -BQSR #{@recal_grp}"
  end

  # Genotyper
  def genotyper()
    cmd = "qsub -pe DJ 6 -o #{@log_file} -e #{@log_file}_genotyper_errors -V \
     -cwd -b y -N genotyper_#{@job_prefix} -l h_vmem=2G \
     -hold_jid recal_#{@job_prefix} #{@account} java -Xmx6g -jar \
     #{@gatk} -l INFO -R #{@index_fa} -T UnifiedGenotyper -I #{@final_bam} \
     --dbsnp #{@dbsnp_file} -o #{@vcf} -nt 6 --max_alternate_alleles 8 \
     --genotype_likelihoods_model BOTH"
  end

  # INDEX is normal genom.fa
  # Coverage Summary
  # parallel not possible yet (1.6-13-g91f02df)
  def coverage()
    cmd = "qsub -o #{@log_file} -e #{@log_file}_coverage_errors -V -cwd -b y \
     -N coverage_#{@job_prefix} -l h_vmem=7G -hold_jid recal_#{@job_prefix} \
     #{@account} java -Xmx6g -jar #{@gatk} -R #{@index_fa} -T DepthOfCoverage \
     -I #{@final_bam} --omitDepthOutputAtEachBase -o #{@coverage_prefix} \
     --omitIntervalStatistics --omitLocusTable"
  end

end