=begin
  * Name: Caller, part of Mutations Caller Pipeline (AWS)
  * Superclass of Callers
  * Author: Katharina Hayer
  * Date: 8/9/2012
  * License: GNU General Public License (GPL-2.0)
=end

class Caller

  def initialize(options)
    @log_file = options[:log_file]
    @job_prefix = options[:job_prefix]
    @account = options[:account]
  end

end