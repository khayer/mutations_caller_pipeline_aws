=begin
  * Name: Structurer, part of Mutations Caller Pipeline (AWS)
  * Brings structure into the ouput folder
  * Author: Katharina Hayer
  * Date: 8/13/2012
  * License: GNU General Public License (GPL-2.0)
=end
require 'csv'

class Structurer

  def structure_paths()
    # Create Dir to not overcluster output folder
    Dir.mkdir("GATK_files") unless File.exists?("GATK_files")
    Dir.mkdir("logs") unless File.exists?("logs")
    Dir.mkdir(".tmp") unless File.exists?(".tmp")
  end

  def organize_options(options)
    # returns modified options
    raise "Output folder(s) are missing" unless File.exists?(".tmp") &&
      File.exists?("logs") && File.exists?("GATK_files")
    options = read_sample_sheet(options)
    options[:job_prefix] = (rand*1000000).floor.to_s
    options[:sai_fwd] = ".tmp/fwd.sai"
    options[:sai_fwd] = ".tmp/rev.sai"

    options[:sam_file] = ".tmp/#{options[:sample_name]}.sam"
    options[:vcf] = "#{options[:sample_name]}.vcf"
    options
  end

  private
  def read_sample_sheet(options)
    # get information from sample sheet
    CSV.foreach(options[:samplesheet],{:headers => :first_row}) do |row|
      if sample_name = row["SampleID"]
        options[:index] = row["Index"]
        lane = row["Lane"]
        sample_project = row["SampleProject"]
        options[:id] = "#{sample_project}_#{lane}_#{sample_name}"
        options[:library] = row["FCID"]
      end
    end
    options
  end

end