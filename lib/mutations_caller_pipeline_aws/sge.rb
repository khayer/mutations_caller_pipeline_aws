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

  def add_job_number(*job_number)
    @job_numbers << job_number
    @job_numbers.flatten!
  end

  def parse_qstat(qstat_ouput)
    qstat_ouput = qstat_ouput.split("\n")
    not_found_jobs = @job_numbers.clone
    qstat_ouput.each do |line|
      next unless line =~ /^\ [0-9]/
      line = line.split(" ")
      next unless @job_numbers.include?(line[0])
      not_found_jobs.delete(line[0]) if line[4] == "r" ||
       line[4] == "hqw" || line[4] == "qw"
    end
    not_found_jobs
  end

  def parse_qacct(qacct_output)
    failed = false
    info = qacct_output.split("failed")
    info = info[1].split(" ")
    failed = true unless info[0] == "0"
  end

  def delete_job_number(job_number)
    @job_numbers.delete(job_number)
  end

end