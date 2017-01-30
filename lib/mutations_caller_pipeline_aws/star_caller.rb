class StarCaller

  def self.call_alignment(options)
    if options[:lsf]
      cmd = "bsub -M 30000 -n #{options[:threads]} -o #{options[:log_file]}_star_o.log -e #{options[:log_file]}_star_e.log -J star_#{options[:job_number]} #{options[:star]} --runThreadN #{options[:threads]} --genomeDir #{options[:star_index]} --readFilesIn #{options[:mutant_r1]} #{options[:mutant_r2]} --outFileNamePrefix #{options[:star_prefix]} --outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonical"
    else
      cmd = "qsub -pe DJ #{options[:threads]} -o #{options[:log_file]}_star_o.log -e #{options[:log_file]}_star_e.log -V -cwd -b y -N star_#{options[:job_number]} -l h_vmem=6G #{options[:star]} --runThreadN #{options[:threads]} --genomeDir #{options[:star_index]} --readFilesIn #{options[:mutant_r1]} #{options[:mutant_r2]} --outFileNamePrefix #{options[:star_prefix]} --outSAMstrandField intronMotif --outFilterIntronMotifs RemoveNoncanonical"
    end
    cmd
  end
end
