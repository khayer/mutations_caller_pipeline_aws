class GatkCaller
  # INDEX is normal genom.fa
  # Genotyper
  def self.call(log_dir, gatk, index_fa, read_bam, read_vcf, job_prefix, account, debug)
    cmd = "echo 'starting GATK for mutant at ' `date` >> #{log_dir}
      qsub -cwd -b y -N #{job_prefix}_genotyper -l h_vmem=3G -hold_jid #{job_prefix}_recalibration {#account}\
      java -Xmx4g -jar  #{gatk} -l INFO -R #{index_fa} -T UnifiedGenotyper \
      -I #{read_bam} \
      -o #{read_vcf} \
      --genotype_likelihoods_model BOTH \
      >> #{log_dir} 2>&1 || exit 1"
    puts cmd
    system(cmd) if debug == 1
  end

  # Making recalibration table
  def self.recalibrate_bam(log_dir ,gatk, index_fa, index_vcf, read_bam, recal_file, job_prefix, account, debug )
    cmd = "echo 'starting recalibration table ' `date` >> #{log_dir}
      qsub -cwd -b y -N #{job_prefix}_recalibration_table -l h_vmem=3G  {#account} \
      java -Xmx4g -jar #{gatk} -knownSites #{index_vcf} -I #{read_bam} \
      -R #{index_fa} -T CountCovariates \
      -cov ReadGroupCovariate -cov QualityScoreCovariate -cov DinucCovariate \
      -cov CycleCovariate \
      -recalFile #{recal_file} >> #{log_dir} 2>&1 || exit 1 "
    puts cmd
    system(cmd) if debug == 1
  end

  # Using recalibration table
  def self.table_calibration(log_dir, gatk, index_fa, read_bam, recal_bam, recal_file, job_prefix, account, debug)
    cmd = "echo 'recalibrating bam_file at ' `date` >> #{log_dir}
      qsub -cwd -b y -N #{job_prefix}_recalibration -l h_vmem=3G -hold_jid #{job_prefix}_recalibration_table {#account} \
      java -Xmx4g -jar #{gatk} \
      -R #{index_fa} \
      -I #{read_bam} \
      -T TableRecalibration \
      -o #{recal_bam} \
      -recalFile #{recal_file} >> #{log_dir} 2>&1 || exit 1"
    puts cmd
    system(cmd) if debug == 1
  end

  # Preparation realignement
  def self.prepare_realigne(log_dir, gatk, read_bam, index_fa, target_intervals, job_prefix, account, debug)
    cmd = "echo 'preparing realignement at ' `date` >> #{log_dir}
      qsub -cwd -b y -N #{job_prefix}_prep_realignment -l h_vmem=3G -hold_jid #{job_prefix}_indexing {#account}\
      java -Xmx2g -jar #{gatk} \
      -I #{read_bam} \
      -R #{index_fa} \
      -T RealignerTargetCreator \
      -o #{target_intervals}"
    puts cmd
    system(cmd) if debug == 1
  end

  # Realignment
  def self.realigne(log_dir, gatk, read_bam, index_fa, target_intervals, realigned_bam, job_prefix, account, debug)
    cmd = "echo 'preparing realignement at ' `date` >> #{log_dir}
      qsub -cwd -b y -N #{job_prefix}_realignment -l h_vmem=3G -hold_jid #{job_prefix}_prep_realignment {#account} \
      java -Xmx4g -jar #{gatk} \
      -I #{read_bam} \
      -R #{index_fa} \
      -T IndelRealigner \
      -targetIntervals #{target_intervals} \
      -o #{realigned_bam} >> #{log_dir} 2>&1 || exit 1"
    puts cmd
    system(cmd) if debug == 1
  end

end