class BwaCaller

  def self.call_mem(options)
    if options[:lsf]
      cmd = "bsub -n #{options[:threads]} -o #{options[:log_file]}_bwa_mem_o.log -e #{options[:log_file]}_bwa_mem_e.log -q plus -J bwa_#{options[:job_number]} #{options[:bwa]} mem -t #{options[:threads]} #{options[:bwa_index]} #{options[:mutant_r1]} #{options[:mutant_r2]} \> #{options[:sam_file]}"
    else
      cmd = "qsub -pe DJ #{options[:threads]} -o #{options[:log_file]}_bwa_mem_o.log -e #{options[:log_file]}_bwa_mem_e.log -V -cwd -b y -N bwa_#{options[:job_number]} -l h_vmem=6G #{options[:bwa]} mem -t #{options[:threads]} #{options[:bwa_index]} #{options[:mutant_r1]} #{options[:mutant_r2]} \> #{options[:sam_file]}"
    end
    cmd
  end
end