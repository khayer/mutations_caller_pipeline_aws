class SamtoolsIndexing
  def self.call(bam_file, job_prefix, account, debug, log_file)
    cmd = "qsub -o #{log_file} -V -cwd -b y -N indexing_#{job_prefix} -l h_vmem=3G -hold_jid bwa_#{job_prefix} #{account} \
      samtools index #{bam_file}"
    puts cmd
    system(cmd) if debug == 1
  end
end