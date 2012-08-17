=begin
  * Name: SGE, part of Mutations Caller Pipeline (AWS)
  * SGE class parses and evaluates qstat/qacct output
  * Author: Katharina Hayer
  * Date: 8/17/2012
  * License: GNU General Public License (GPL-2.0)
=end

class SGE

  def initialize()
    @job_numbers = Array.new()
  end

  def to_s()
    "Current job_numbers are #{@job_numbers.join(",")}"
  end

  def add_job_number(job_number)
    @job_numbers << job_number
  end

  def parse_qstat(qstat_ouput)
    qstat_ouput = qstat_ouput.split("\n")
    qstat_ouput.each do |line|
      next unless line =~ /^\ [0-9]/
      line = line.split(" ")
      next unless @job_numbers.include?(line[0])
      puts line
    end
  end

end