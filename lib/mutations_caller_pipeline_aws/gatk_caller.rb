class GatkCaller
  # Split_N_Cigar
  def self.split_n_cigar(options)
    if options[:lsf]
      cmd = "bsub -n #{options[:threads]} -w \"done(index_#{options[:job_number]})\" -o #{options[:log_file]}_split_n_cigar_o.log -e #{options[:log_file]}_split_n_cigar_e.log -M 30000 -J split_n_cigar_#{options[:job_number]} java -Xmx25g -jar #{options[:gatk]} -I #{options[:bam_file_sorted_duplicates]} -R #{options[:index_fa]} -T SplitNCigarReads -o #{options[:split_bam]} -rf ReassignOneMappingQuality -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS"
    else
      cmd = "qsub -pe DJ #{options[:threads]} -o #{options[:log_file]}_split_n_cigar_o.log -e #{options[:log_file]}_split_n_cigar_e.log -V -cwd -b y -hold_jid index_#{options[:job_number]} -N split_n_cigar_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:gatk]} -I #{options[:bam_file_sorted_duplicates]} -R #{options[:index_fa]} -T SplitNCigarReads -o #{options[:split_bam]} -rf ReassignOneMappingQuality -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS"
    end
    cmd
  end

  # Preparation realignement
  def self.prepare_realigne(options)
    if options[:rna_mode]  
      if options[:lsf]
        cmd = "bsub -n #{options[:threads]} -w \"done(split_n_cigar_#{options[:job_number]})\" -o #{options[:log_file]}_prep_real_o.log -e #{options[:log_file]}_prep_real_e.log -M 30000 -J prep_real_#{options[:job_number]} java -Xmx25g -jar #{options[:gatk]} -nt #{options[:threads]} -I #{options[:split_bam]} -R #{options[:index_fa]} -T RealignerTargetCreator --known #{options[:dbsnp_file]} -o #{options[:target_intervals]}.intervals"
      else
        cmd = "qsub -pe DJ #{options[:threads]} -o #{options[:log_file]}_prep_real_o.log -e #{options[:log_file]}_prep_real_e.log -V -cwd -b y -hold_jid split_n_cigar_#{options[:job_number]} -N prep_real_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:gatk]} -nt #{options[:threads]} -I #{options[:split_bam]} --known #{options[:dbsnp_file]} -R #{options[:index_fa]} -T RealignerTargetCreator -o #{options[:target_intervals]}.intervals"
      end
    else
      if options[:lsf]
        cmd = "bsub -n #{options[:threads]} -w \"done(index_#{options[:job_number]})\" -o #{options[:log_file]}_prep_real_o.log -e #{options[:log_file]}_prep_real_e.log -M 30000 -J prep_real_#{options[:job_number]} java -Xmx25g -jar #{options[:gatk]} -nt #{options[:threads]} -I #{options[:bam_file_sorted_duplicates]} -R #{options[:index_fa]} -T RealignerTargetCreator --known #{options[:dbsnp_file]} -o #{options[:target_intervals]}.intervals"
      else
        cmd = "qsub -pe DJ #{options[:threads]} -o #{options[:log_file]}_prep_real_o.log -e #{options[:log_file]}_prep_real_e.log -V -cwd -b y -hold_jid index_#{options[:job_number]} -N prep_real_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:gatk]} -nt #{options[:threads]} -I #{options[:bam_file_sorted_duplicates]} --known #{options[:dbsnp_file]} -R #{options[:index_fa]} -T RealignerTargetCreator -o #{options[:target_intervals]}.intervals"
      end
    end
    cmd
  end

  # Realignment
  # parallel not possible yet (1.6-13-g91f02df)
  def self.realigne(options)
    if options[:rna_mode] 
      if options[:lsf]
        cmd = "bsub -w \"done(prep_real_#{options[:job_number]})\" -o #{options[:log_file]}_real_o.log -e #{options[:log_file]}_real_e.log -M 30000 -J real_#{options[:job_number]} java -Xmx25g -jar #{options[:gatk]} -I #{options[:split_bam]} -R #{options[:index_fa]} -T IndelRealigner -targetIntervals #{options[:target_intervals]}.intervals -o #{options[:realigned_bam]}"
      else
        cmd = "qsub -o #{options[:log_file]}_real_o.log -e #{options[:log_file]}_real_e.log -V -cwd -b y -hold_jid prep_real_#{options[:job_number]} -N real_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:gatk]} -I #{options[:split_bam]} -R #{options[:index_fa]} -T IndelRealigner -targetIntervals #{options[:target_intervals]}.intervals -o #{options[:realigned_bam]}"
      end
    else
      if options[:lsf]
        cmd = "bsub -w \"done(prep_real_#{options[:job_number]})\" -o #{options[:log_file]}_real_o.log -e #{options[:log_file]}_real_e.log -M 30000 -J real_#{options[:job_number]} java -Xmx25g -jar #{options[:gatk]} -I #{options[:bam_file_sorted_duplicates]} -R #{options[:index_fa]} -T IndelRealigner -targetIntervals #{options[:target_intervals]}.intervals -o #{options[:realigned_bam]}"
      else
        cmd = "qsub -o #{options[:log_file]}_real_o.log -e #{options[:log_file]}_real_e.log -V -cwd -b y -hold_jid prep_real_#{options[:job_number]} -N real_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:gatk]} -I #{options[:bam_file_sorted_duplicates]} -R #{options[:index_fa]} -T IndelRealigner -targetIntervals #{options[:target_intervals]}.intervals -o #{options[:realigned_bam]}"
      end
    end
    cmd
  end

  # Making recalibration table
  def self.recalibrate_bam(options)
    if options[:lsf]
      cmd = "bsub -n #{options[:threads]+3} -w \"done(real_#{options[:job_number]})\" -o #{options[:log_file]}_prep_recal_o.log -e #{options[:log_file]}_prep_recal_e.log -M 30000 -J prep_recal_#{options[:job_number]} java -Xmx25g -jar #{options[:gatk]} -I #{options[:realigned_bam]} -R #{options[:index_fa]} -T BaseRecalibrator -o #{options[:recal_qual]} -knownSites #{options[:dbsnp_file]} -nct #{options[:threads]}"
    else
      cmd = "qsub -o #{options[:log_file]}_prep_recal_o.log -e #{options[:log_file]}_prep_recal_e.log -V -cwd -b y -hold_jid real_#{options[:job_number]} -N prep_recal_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:gatk]} -I #{options[:realigned_bam]} -R #{options[:index_fa]} -T BaseRecalibrator -o #{options[:recal_qual]} -knownSites #{options[:dbsnp_file]}"
    end
    cmd
  end

  # Using recalibration table
  # parallel not possible yet (1.6-13-g91f02df)
  def self.table_calibration(options)
    if options[:lsf]
      cmd = "bsub -n #{options[:threads]+3} -w \"done(prep_recal_#{options[:job_number]})\" -o #{options[:log_file]}_recal_o.log -e #{options[:log_file]}_recal_e.log -M 30000 -J recal_#{options[:job_number]} java -Xmx25g -jar #{options[:gatk]} -I #{options[:realigned_bam]} -R #{options[:index_fa]} -T PrintReads -o #{options[:recal_bam]} -BQSR #{options[:recal_qual]} -nct #{options[:threads]}"
    else
      cmd = "qsub -o #{options[:log_file]}_recal_o.log -e #{options[:log_file]}_recal_e.log -V -cwd -b y -hold_jid prep_recal_#{options[:job_number]} -N recal_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:gatk]} -I #{options[:realigned_bam]} -R #{options[:index_fa]} -T PrintReads -o #{options[:recal_bam]} -BQSR #{options[:recal_qual]}"
    end
    cmd
  end

  # INDEX is normal genom.fa
  # Genotyper
  def self.call(options)
    if options[:lsf]
      cmd = "bsub -n #{options[:threads]} -w \"done(recal_#{options[:job_number]})\" -o #{options[:log_file]}_genotyper_o.log -e #{options[:log_file]}_genotyper_e.log -M 30000 -J genotyper_#{options[:job_number]} java -Xmx25g -jar #{options[:gatk]} -R #{options[:index_fa]} -T UnifiedGenotyper -I #{options[:recal_bam]} --dbsnp #{options[:dbsnp_file]} -o #{options[:vcf]} -nt #{options[:threads]} --max_alternate_alleles 8 --genotype_likelihoods_model BOTH"
    else
      cmd = "qsub -pe DJ #{options[:threads]} -o #{options[:log_file]}_genotyper_o.log -e #{options[:log_file]}_genotyper_e.log -V -cwd -b y -hold_jid recal_#{options[:job_number]} -N genotyper_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:gatk]} -R #{options[:index_fa]} -T UnifiedGenotyper -I #{options[:recal_bam]} --dbsnp #{options[:dbsnp_file]} -o #{options[:vcf]} -nt #{options[:threads]} --max_alternate_alleles 8 --genotype_likelihoods_model BOTH"
    end
    cmd
  end

  # INDEX is normal genom.fa
  # Haplotypecaller
  def self.call_haplo(options)
    if options[:lsf]
      cmd = "bsub -n #{options[:threads]} -w \"done(recal_#{options[:job_number]})\" -o #{options[:log_file]}_genotyper_o.log -e #{options[:log_file]}_genotyper_e.log -M 30000 -J genotyper_#{options[:job_number]} java -Xmx25g -jar #{options[:gatk]} -R #{options[:index_fa]} -T HaplotypeCaller -I #{options[:recal_bam]} -o #{options[:vcf]} --dbsnp #{options[:dbsnp_file]} -nct #{options[:threads]} --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000"
    else
      cmd = "qsub -pe DJ #{options[:threads]} -o #{options[:log_file]}_genotyper_o.log -e #{options[:log_file]}_genotyper_e.log -V -cwd -b y -hold_jid recal_#{options[:job_number]} -N genotyper_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:gatk]} -R #{options[:index_fa]} -T UnifiedGenotyper -I #{options[:recal_bam]} --dbsnp #{options[:dbsnp_file]} -o #{options[:vcf]} -nt #{options[:threads]} --max_alternate_alleles 8 --genotype_likelihoods_model BOTH"
    end
    cmd
  end

  # INDEX is normal genom.fa
  # Coverage Summary
  # parallel not possible yet (1.6-13-g91f02df)
  def self.coverage(options)
    if options[:lsf]
      cmd = "bsub -n #{options[:threads]} -w \"done(recal_#{options[:job_number]})\" -o #{options[:log_file]}_coverage_o.log -e #{options[:log_file]}_coverage_e.log -M 10000 -J coverage_#{options[:job_number]} java -Xmx5g -jar #{options[:gatk]} -R #{options[:index_fa]} -T DepthOfCoverage -I #{options[:recal_bam]} -o #{options[:outfile_prefix]} --omitDepthOutputAtEachBase --omitIntervalStatistics --omitLocusTable -nt #{options[:threads]}"
    else
      cmd = "qsub -o #{options[:log_file]}_coverage_o.log -e #{options[:log_file]}_coverage_e.log -V -cwd -b y -hold_jid recal_#{options[:job_number]} -N coverage_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:gatk]} -R #{options[:index_fa]} -T DepthOfCoverage -I #{options[:recal_bam]} -o #{options[:outfile_prefix]} --omitDepthOutputAtEachBase --omitIntervalStatistics --omitLocusTable"
    end
    cmd
  end
end