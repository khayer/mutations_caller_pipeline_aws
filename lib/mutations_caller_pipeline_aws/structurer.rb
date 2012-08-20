=begin
  * Name: Structurer, part of Mutations Caller Pipeline (AWS)
  * Brings structure into the ouput folder
  * Author: Katharina Hayer
  * Date: 8/13/2012
  * License: GNU General Public License (GPL-2.0)
=end
require 'csv'
require "yaml"

class Structurer

  def structure_paths()
    # Create Dir to not overcluster output folder
    Dir.mkdir("GATK_files") unless File.exists?("GATK_files")
    Dir.mkdir("log") unless File.exists?("log")
    Dir.mkdir(".tmp") unless File.exists?(".tmp")
  end

  def organize_options(options)
    # returns modified options
    raise "Output folder(s) are missing" unless File.exists?(".tmp") &&
      File.exists?("log") && File.exists?("GATK_files")
    options = read_sample_sheet(options)
    options[:job_prefix] || (rand*1000000).floor.to_s
    # log file
    options[:log_file] = "log/#{options[:sample_name]}.log"

    # TMP files
    options[:sai_fwd] = ".tmp/fwd.sai"
    options[:sai_rev] = ".tmp/rev.sai"
    options[:sam_file] = ".tmp/#{options[:sample_name]}.sam"
    options[:bam_file] = ".tmp/raw.bam"
    options[:bam_file_sorted] = ".tmp/sorted.bam"
    options[:bam_file_sorted_dublicates] = ".tmp/sorted_dublicates.bam"
    options[:realigned_bam] = ".tmp/realigned.bam"

    # GATK output
    options[:recal_grp] = "GATK_files/recal_data.grp"
    options[:target_intervals] = "GATK_files/target.intervals"
    options[:dublicate_metrics] = "GATK_files/dublicate.metrics"

    # Final output files
    options[:coverage_prefix] = "#{options[:sample_name]}_coverage"
    options[:final_bam] = "#{options[:sample_name]}.bam"
    options[:vcf] = "#{options[:sample_name]}.vcf"
  end

  def save_options(options)
    options_file = File.open(".options.yml",'w')
    options_file.puts options.to_yaml
    options_file.close
  end

  def load_options(options)
    raise "No options to load!" unless File.exists?(".options.yml")
    path = ".options"
    options = YAML.load_file("/Users/hayer/github/mutations_caller_pipeline_aws/.options.yml")
  end

  private
  def read_sample_sheet(options)
    # get information from sample sheet
    CSV.foreach(options[:samplesheet],{:headers => :first_row}) do |row|
      if sample_name = row["SampleID"]
        options[:index] = row["Index"]
        lane = row["Lane"]
        sample_project = row["SampleProject"]
        options[:sample_id] = "#{sample_project}_#{lane}_#{sample_name}"
        options[:library] = row["FCID"]
      end
    end
    options
  end

end