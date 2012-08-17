=begin
  * Name: SGE, part of Mutations Caller Pipeline (AWS)
  * SGE class parses and evaluates qstat/qacct output
  * Author: Katharina Hayer
  * Date: 8/17/2012
  * License: GNU General Public License (GPL-2.0)
=end

class Runner

  def initialize(options)
    @options = options
  end

  def test
    l = BwaCaller.new(@options)
    k = l.call_sampe()
    puts k
  end

end