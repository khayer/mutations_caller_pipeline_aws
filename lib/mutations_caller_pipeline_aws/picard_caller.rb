class PicardCaller
  #converter = "java -jar ~/Downloads/picard-tools-1.56/picard-tools-1.56/SamFormatConverter.jar I=WT_aligned_sorted_rg.bam O=tmp.sam VALIDATION_STRINGENCY=LENIENT"
  def self.convert(options)
    if options[:rna]
      if options[:lsf]
        cmd = "bsub -w \"done(star_#{options[:job_number]})\" -o #{options[:log_file]}_convert_o.log -e #{options[:log_file]}_convert_e.log -M 10000 -J convert_#{options[:job_number]} java -Xmx5g -jar #{options[:picard_tools]}/SamFormatConverter.jar I=#{options[:sam_file]} O=#{options[:bam_file]} VALIDATION_STRINGENCY=LENIENT"
      else
        cmd = "qsub -o #{options[:log_file]}_convert_o.log -e #{options[:log_file]}_convert_e.log -V -cwd -b y -hold_jid star_#{options[:job_number]} -N convert_#{options[:job_number]} -l h_vmem=14G java -jar #{options[:picard_tools]}/SamFormatConverter.jar I=#{options[:sam_file]} O=#{options[:bam_file]} VALIDATION_STRINGENCY=LENIENT"
      end
    else
      if options[:lsf]
        cmd = "bsub -w \"done(bwa_#{options[:job_number]})\" -o #{options[:log_file]}_convert_o.log -e #{options[:log_file]}_convert_e.log -M 10000 -J convert_#{options[:job_number]} java -Xmx5g -jar #{options[:picard_tools]}/SamFormatConverter.jar I=#{options[:sam_file]} O=#{options[:bam_file]} VALIDATION_STRINGENCY=LENIENT"
      else
        cmd = "qsub -o #{options[:log_file]}_convert_o.log -e #{options[:log_file]}_convert_e.log -V -cwd -b y -hold_jid bwa_#{options[:job_number]} -N convert_#{options[:job_number]} -l h_vmem=14G java -jar #{options[:picard_tools]}/SamFormatConverter.jar I=#{options[:sam_file]} O=#{options[:bam_file]} VALIDATION_STRINGENCY=LENIENT"
      end
    end
    cmd
  end

  #rg_and_sorting = "java -jar -Xmx3g ~/Downloads/picard-tools-1.56/picard-tools-1.56/AddOrReplaceReadGroups.jar I=WT_aligned.bam O=WT_aligned_sorted_rg.bam SO=coordinate ID=15 LB=nina_library PL=Illumina PU=ATCATC SM=My_test VALIDATION_STRINGENCY=LENIENT"
  def self.rg_and_sorting(options)
    if options[:lsf]
      cmd = "bsub -w \"done(convert_#{options[:job_number]})\" -o #{options[:log_file]}_sorting_o.log -e #{options[:log_file]}_sorting_e.log -M 10000 -J sorting_#{options[:job_number]} java -Xmx5g -jar #{options[:picard_tools]}/AddOrReplaceReadGroups.jar I=#{options[:bam_file]} O=#{options[:bam_file_sorted]} VALIDATION_STRINGENCY=LENIENT SO=coordinate ID=#{options[:id]} LB=#{options[:library]} PL=Illumina PU=#{options[:index]} SM=#{options[:sample_name]} MAX_RECORDS_IN_RAM=1500000"
    else
      cmd = "qsub -o #{options[:log_file]}_sorting_o.log -e #{options[:log_file]}_sorting_e.log -V -cwd -b y -hold_jid convert_#{options[:job_number]} -N sorting_#{options[:job_number]} -l h_vmem=14G java -jar #{options[:picard_tools]}/AddOrReplaceReadGroups.jar I=#{options[:bam_file]} O=#{options[:bam_file_sorted]} VALIDATION_STRINGENCY=LENIENT SO=coordinate ID=#{options[:id]} LB=#{options[:library]} PL=Illumina PU=#{options[:index]} SM=#{options[:sample_name]} MAX_RECORDS_IN_RAM=1500000"
    end
    cmd
  end


  #mark_duplicates = "java -jar ~/Downloads/picard-tools-1.56/picard-tools-1.56/MarkDuplicates.jar I=WT_aligned_sorted_rg.bam O=marked_dublicates.bam M=dublicate.metrcis AS=true VALIDATION_STRINGENCY=LENIENT"
  def self.mark_duplicates(options)
    if options[:lsf]
      cmd = "bsub -w \"done(sorting_#{options[:job_number]})\" -o #{options[:log_file]}_duplicates_o.log -e #{options[:log_file]}_duplicates_e.log -M 10000 -J duplicates_#{options[:job_number]} java -Xmx5g -jar #{options[:picard_tools]}/MarkDuplicates.jar I=#{options[:bam_file_sorted]} O=#{options[:bam_file_sorted_duplicates]} VALIDATION_STRINGENCY=LENIENT M=#{options[:duplicate_metrcis]} AS=true"
    else
      cmd = "qsub -o #{options[:log_file]}_duplicates_o.log -e #{options[:log_file]}_duplicates_e.log -V -cwd -b y -hold_jid sorting_#{options[:job_number]} -N duplicates_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:picard_tools]}/MarkDuplicates.jar I=#{options[:bam_file_sorted]} O=#{options[:bam_file_sorted_duplicates]} VALIDATION_STRINGENCY=LENIENT M=#{options[:duplicate_metrcis]} AS=true"
    end
    cmd
  end

  #build_index = "java -jar ~/Downloads/picard-tools-1.56/picard-tools-1.56/BuildBamIndex.jar I=marked_dublicates.bam  VALIDATION_STRINGENCY=LENIENT"
  def self.build_index(options)
    if options[:lsf]
      cmd = "bsub -w \"done(duplicates_#{options[:job_number]})\" -o #{options[:log_file]}_index_o.log -e #{options[:log_file]}_index_e.log -M 10000 -J index_#{options[:job_number]} java -Xmx5g -jar #{options[:picard_tools]}/BuildBamIndex.jar I=#{options[:bam_file_sorted_duplicates]} VALIDATION_STRINGENCY=LENIENT"
    else
      cmd = "qsub -o #{options[:log_file]}_index_o.log -e #{options[:log_file]}_index_e.log -V -cwd -b y -hold_jid duplicates_#{options[:job_number]} -N index_#{options[:job_number]} -l h_vmem=14G java -Xmx5g -jar #{options[:picard_tools]}/BuildBamIndex.jar I=#{options[:bam_file_sorted_duplicates]} VALIDATION_STRINGENCY=LENIENT"
    end
    cmd
  end
end
