=begin
  * Name: BwaCaller, part of Mutations Caller Pipeline (AWS)
  * Framework for calling bwa
  * Author: Katharina Hayer
  * Date: 8/9/2012
  * License: GNU General Public License (GPL-2.0)
=end

class BwaCaller < Caller

  def initialize(options)
    super(options)
    @bwa = options[:bwa]
    @index = options[:index]
    @sai1 = options[:sai1]
    @sai2 = options[:sai2]
    @sam_file = options[:sam_file]
    @r1 = options[:r1]
    @r2 = options[:r2]
  end

  def self.call_sampe()
    cmd = "qsub -o #{@log_file} -e #{@log_file}_bwa_sampe_errors -hold_jid \
     bwa_aln_#{@job_prefix} -V -cwd -b y -N bwa_#{@job_prefix} -l h_vmem=6G \
     -pe make 3  #{@account} \
     #{@bwa} sampe #{@index} #{@sai1} #{@sai2} #{@r1} #{@r2} -f #{@sam_file}"
  end

  def self.call_aln(read, index, out_file, log_file, bwa, job_prefix,
    account, debug)
    cmd = "qsub -pe DJ 8 -o #{@log_file} -e #{@log_file}_bwa_aln_errors \
     -V -cwd -b y -N bwa_aln_#{@job_prefix} -l h_vmem=4G #{@account} \
     #{@bwa} aln -t 8 -f #{@out_file} #{@index} #{@read} "
  end

end