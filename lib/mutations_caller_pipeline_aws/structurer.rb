=begin
  * Name: Structurer, part of Mutations Caller Pipeline (AWS)
  * Brings structure into the ouput folder
  * Author: Katharina Hayer
  * Date: 8/13/2012
  * License: GNU General Public License (GPL-2.0)
=end
require 'csv'

class Structurer

  def organize_options(options)
    # returns modified options
    options
  end

  def structure_paths()
    # Create Dir to not overcluster output folder
    Dir.mkdir("GATK_files") unless File.exists?("GATK_files")
    Dir.mkdir("log") unless File.exists?("log")
    # should make paths for
    # - logs
    # - gatk output files
    # - tmp files
  end

end