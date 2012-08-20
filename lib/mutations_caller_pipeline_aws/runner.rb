=begin
  * Name: Runner, part of Mutations Caller Pipeline (AWS)
  * Runner combines all the elements to one strong pipeline
  * Author: Katharina Hayer
  * Date: 8/17/2012
  * License: GNU General Public License (GPL-2.0)
=end

class Runner

  def initialize(options)
    @options = options
  end

  def run
    l = BwaCaller.new(@options)
    k = l.call_sampe()
    puts k
  end

  def restart
    #restarts a run
  end

  def stop

  end

  def status

  end


  private

  def execute(cmd)
    ## TODO: needs to keep track of job_numbers
    puts cmd
    status = system(cmd)
    raise cmd unless status
    execute
  end

  def safe_run()

  end

  def load_run()

  end

end