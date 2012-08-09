=begin
  * Name: BwaCaller, part of Mutations Caller Pipeline (AWS)
  * Pipeline combining bwa with GATK2
  * Author: Katharina Hayer
  * Date: 8/9/2012
  * License: GNU General Public License (GPL-2.0)
=end

class Caller

  def initialize(options)
    @log_file = options[:log_file]
    @job_prefix = options[:job_prefix]
    @account = options[:account]
    @debug = options[:debug]
  end

end