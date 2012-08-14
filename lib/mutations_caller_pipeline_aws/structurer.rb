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
    options[:job_prefix] = (rand*1000000).floor.to_s
    options[:sam_file] = ".tmp/#{options[:sample_name]}.sam"
    options
  end

end