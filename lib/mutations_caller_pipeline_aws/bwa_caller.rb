class BwaCaller

  def self.call_paired_end(r1, r2, sai1, sai2,  out_file, index, log_file, bwa, samtools, job_prefix,account, debug)
    dummy = "\\\\\\"
    cmd = "qsub -o #{log_file} -hold_jid bwa_aln_#{job_prefix} -V -cwd -b y -N bwa_#{job_prefix} -l h_vmem=6G -pe make 3  #{account}\
           #{bwa} sampe -r '@RG#{dummy}tID:foo#{dummy}tSM:bar#{dummy}tPL:Illumina' #{index} \
          #{sai1} #{sai2}  #{r1} #{r2} \
          \\| #{samtools} view -Su - \\| #{samtools} sort - #{out_file}"
    puts cmd
    system('bash','-c', cmd) if debug == 1
  end

  def self.call_aln(read, index, out_file, log_file, bwa, job_prefix, account,debug)
    cmd = "qsub -o #{log_file} -V -cwd -b y -N bwa_aln_#{job_prefix} -l h_vmem=4G #{account} \
           #{bwa} aln -f #{out_file} #{index} #{read} "
    puts cmd
    system(cmd) if debug == 1
  end
end