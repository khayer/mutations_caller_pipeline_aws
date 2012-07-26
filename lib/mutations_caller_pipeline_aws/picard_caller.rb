class PicardCaller
  #converter = "java -jar ~/Downloads/picard-tools-1.56/picard-tools-1.56/SamFormatConverter.jar I=WT_aligned_sorted_rg.bam O=tmp.sam VALIDATION_STRINGENCY=LENIENT"
  def self.convert(sam_file, bam_file, picard_tools, log_file, job_prefix, account)
    cmd = "qsub -o #{log_file} -V -cwd -b y -hold_jid bwa_#{job_prefix} -N convert_#{job_prefix} -l h_vmem=2G #{account} \
      java -jar #{picard_tools}/SamFormatConverter.jar I=#{sam_file} O=#{bam_file} VALIDATION_STRINGENCY=LENIENT"
  end

  #rg_and_sorting = "java -jar -Xmx3g ~/Downloads/picard-tools-1.56/picard-tools-1.56/AddOrReplaceReadGroups.jar I=WT_aligned.bam O=WT_aligned_sorted_rg.bam SO=coordinate ID=15 LB=nina_library PL=Illumina PU=ATCATC SM=My_test VALIDATION_STRINGENCY=LENIENT"
  def self.rg_and_sorting(bam_file, bam_file_sorted, picard_tools, library, index, sample_name, log_file, job_prefix, account)
    cmd = "qsub -o #{log_file} -V -cwd -b y -hold_jid convert_#{job_prefix} -N sort_#{job_prefix} -l h_vmem=4G #{account} \
      java -jar -Xmx3g #{picard_tools}/AddOrReplaceReadGroups.jar I=#{bam_file} O=#{bam_file_sorted} SO=coordinate ID=#{job_prefix} \
      LB=#{library} PL=Illumina PU=#{index} SM=#{sample_name} VALIDATION_STRINGENCY=LENIENT"
  end


  #mark_dublicates = "java -jar ~/Downloads/picard-tools-1.56/picard-tools-1.56/MarkDuplicates.jar I=WT_aligned_sorted_rg.bam O=marked_dublicates.bam M=dublicate.metrcis AS=true VALIDATION_STRINGENCY=LENIENT"
  def self.mark_dublicates(bam_file_sorted, bam_file_sorted_dublicates, dublicate_metrcis, picard_tools, log_file, job_prefix, account)
    cmd = "qsub -o #{log_file} -V -cwd -b y -hold_jid sort_#{job_prefix} -N dublicates_#{job_prefix} -l h_vmem=2G #{account} \
      java -jar #{picard_tools}/MarkDuplicates.jar I=#{bam_file_sorted} O=#{bam_file_sorted_dublicates} M=#{dublicate_metrcis} \
      AS=true VALIDATION_STRINGENCY=LENIENT"
  end

  #build_index = "java -jar ~/Downloads/picard-tools-1.56/picard-tools-1.56/BuildBamIndex.jar I=marked_dublicates.bam  VALIDATION_STRINGENCY=LENIENT"
  def self.build_index(bam_file_sorted_dublicates, picard_tools, log_file, job_prefix, account)
    cmd = "qsub -o #{log_file} -V -cwd -b y -hold_jid dublicates_#{job_prefix} -N index_#{job_prefix} -l h_vmem=2G #{account} \
      java -jar #{picard_tools}/BuildBamIndex.jar I=#{bam_file_sorted_dublicates}  VALIDATION_STRINGENCY=LENIENT"
  end
end
