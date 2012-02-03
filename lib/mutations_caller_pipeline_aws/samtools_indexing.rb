class SamtoolsIndexing
  def self.call(bam_file, job_prefix, account, debug)
    cmd = "qsub -cwd -b y -N #{job_prefix}_indexing -l h_vmem=3G -hold_jid #{job_prefix}_bwa {#account} \
      samtools index #{bam_file}"
    puts cmd
    system(cmd) if debug == 1
  end
end