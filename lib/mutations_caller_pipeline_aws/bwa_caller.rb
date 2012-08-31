class BwaCaller

  def self.call_paired_end(r1, r2, sai1, sai2,  sam_file, index, log_file, bwa, samtools, job_prefix,account, debug)
    dummy = "\\\\\\"
    cmd = "qsub -o #{log_file} -e #{log_file}_bwa_sampe_errors -hold_jid bwa_aln_#{job_prefix} -V -cwd -b y -N bwa_#{job_prefix} -l h_vmem=6G  #{account}\
           #{bwa} sampe  #{index}   \
          #{sai1} #{sai2}  #{r1} #{r2} -f #{sam_file}"
    puts cmd
    system('bash','-c', cmd) if debug == 1
  end

  def self.call_aln(read, index, out_file, log_file, bwa, job_prefix, account,debug,direction)
    cmd = "qsub -pe DJ 8 -o #{log_file} -e #{log_file}_bwa_aln_errors_#{direction} -V -cwd -b y -N bwa_aln_#{job_prefix} -l h_vmem=4G #{account} \
           #{bwa} aln -t 8 -f #{out_file} #{index} #{read} "
    puts cmd
    system(cmd) if debug == 1
  end
end