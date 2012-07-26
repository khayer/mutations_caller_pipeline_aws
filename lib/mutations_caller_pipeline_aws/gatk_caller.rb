class GatkCaller
  # INDEX is normal genom.fa
  # Genotyper
  def self.call(log_dir, gatk, index_fa, read_bam, read_vcf, job_prefix, account,dbsnp_file debug)
    cmd = "echo 'starting GATK for mutant at ' `date` >> #{log_dir}
      qsub -o #{log_dir} -V -cwd -b y -N genotyper_#{job_prefix} -l h_vmem=4.5G -hold_jid recalibration_#{job_prefix} #{account}\
      #{gatk} -l INFO -R #{index_fa} -T UnifiedGenotyper \
      -I #{read_bam} --dbsnp #{dbsnp_file} \
      -o #{read_vcf} \
      --genotype_likelihoods_model BOTH"
    puts cmd
    system(cmd) if debug == 1
  end

  # INDEX is normal genom.fa
  # Coverage Summary
  def self.coverage(log_dir, gatk, index_fa, read_bam, outfile_prefix, job_prefix, account, debug)
    cmd = "echo 'starting coverage GATK for mutant at ' `date` >> #{log_dir}
      qsub -o #{log_dir} -V -cwd -b y -N genotyper_#{job_prefix} -l h_vmem=4.5G -hold_jid recalibration_#{job_prefix} #{account}\
      #{gatk} -R #{index_fa} -T DepthOfCoverage \
      -I #{read_bam} \
      -o #{outfile_prefix} "
    puts cmd
    system(cmd) if debug == 1
  end

  # Making recalibration table
  def self.recalibrate_bam(log_dir ,gatk, index_vcf, read_bam, recal_file, job_prefix, account, dbsnp_file, debug )
    cmd = "echo 'starting recalibration table ' `date` >> #{log_dir}
      qsub -o #{log_dir} -V -cwd -b y -N recalibration_table_#{job_prefix} -l h_vmem=4.5G  -hold_jid realignment_#{job_prefix} #{account} \
      #{gatk} -knownSites #{dbsnp_file} -I #{read_bam} \
      -R #{index_fa} -T CountCovariates \
      -cov ReadGroupCovariate -cov QualityScoreCovariate -cov DinucCovariate \
      -cov CycleCovariate \
      -recalFile #{recal_file}"
    puts cmd
    system(cmd) if debug == 1
  end

  # Using recalibration table
  def self.table_calibration(log_dir, gatk, index_fa, read_bam, recal_bam, recal_file, job_prefix, account, debug)
    cmd = "echo 'recalibrating bam_file at ' `date` >> #{log_dir}
      qsub -V -o #{log_dir} -cwd -b y -N recalibration_#{job_prefix} -l h_vmem=4.5G -hold_jid recalibration_table_#{job_prefix} #{account} \
      #{gatk} \
      -R #{index_fa} \
      -I #{read_bam} \
      -T TableRecalibration \
      -o #{recal_bam} \
      -recalFile #{recal_file}"
    puts cmd
    system(cmd) if debug == 1
  end

  # Preparation realignement
  def self.prepare_realigne(log_dir, gatk, read_bam, index_fa, target_intervals, job_prefix, account, dbsnp_file, debug)
    cmd = "echo 'preparing realignement at ' `date` >> #{log_dir}
      qsub -o #{log_dir} -V -cwd -b y -N prep_realignment_#{job_prefix} -l h_vmem=4.5G -hold_jid indexing_#{job_prefix} #{account}\
      #{gatk} \
      -I #{read_bam} --known #{dbsnp_file} \
      -R #{index_fa} \
      -T RealignerTargetCreator \
      -o #{target_intervals}"
    puts cmd
    system(cmd) if debug == 1
  end

  # Realignment
  def self.realigne(log_dir, gatk, read_bam, index_fa, target_intervals, realigned_bam, job_prefix, account, debug)
    cmd = "echo 'preparing realignement at ' `date` >> #{log_dir}
      qsub -o #{log_dir} -V -cwd -b y -N realignment_#{job_prefix} -l h_vmem=4.5G -hold_jid prep_realignment_#{job_prefix} #{account} \
      #{gatk} \
      -I #{read_bam} \
      -R #{index_fa} \
      -T IndelRealigner \
      -targetIntervals #{target_intervals} \
      -o #{realigned_bam}"
    puts cmd
    system(cmd) if debug == 1
  end

end