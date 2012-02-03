class BwaCaller
  def self.call_single_end(r1,out_file,index, log_file, bwa, samtools)
    cmd = "#{bwa} samse -r '@RG\tID:foo\tSM:bar\tPL:Illumina' #{index} \
        <(#{bwa} aln #{index} #{r1} 2>>#{log_file})  \
        #{r1} 2>>#{log_file} | #{samtools} view -Su - 2>>#{log_file} | #{samtools} sort - #{out_file} 2>>#{log_file}"
    puts cmd
    system('bash','-c',cmd )
  end

  def self.call_paired_end(r1, r2, out_file, index, log_file, bwa, samtools, job_prefix,account, debug)
    cmd = "echo 'starting BWA at ' `date` >> #{log_dir}
      qsub -cwd -b y -N #{job_prefix}_bwa -l h_vmem=3G -hold_jid #{job_prefix}_recalibration {#account}\
      #{bwa} sampe -r '@RG\tID:foo\tSM:bar\tPL:Illumina' #{index} \
        <(#{bwa} aln #{index} #{r1} 2>>#{log_file} || exit 1) <(#{bwa} aln #{index} #{r2} 2>>#{log_file} ) \
        #{r1} #{r2} 2>>#{log_file} | #{samtools} view -Su - 2>>#{log_file} | #{samtools} sort - #{out_file} 2>>#{log_file}"
    puts cmd
    system('bash','-c', cmd) if debug == 1
  end
end