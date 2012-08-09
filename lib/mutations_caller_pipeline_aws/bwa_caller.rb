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
    @sai_fwd = options[:sai_fwd]
    @sai_rev = options[:sai_rev]
    @sam_file = options[:sam_file]
    @fastq_fwd = options[:fastq_fwd]
    @fastq_rev = options[:fastq_rev]
  end

  def call_sampe()
    cmd = "qsub -o #{@log_file} -e #{@log_file}_bwa_sampe_errors -hold_jid \
     bwa_aln_#{@job_prefix} -V -cwd -b y -N bwa_#{@job_prefix} -l h_vmem=6G \
     -pe make 3  #{@account} \
     #{@bwa} sampe #{@index} #{@sai_fwd} #{@sai_rev} #{@fastq_fwd} #{@fastq_rev} \
     -f #{@sam_file}"
  end

  def call_aln(fastq_file, sai_file)
    cmd = "qsub -pe DJ 8 -o #{@log_file} -e #{@log_file}_bwa_aln_errors \
     -V -cwd -b y -N bwa_aln_#{@job_prefix} -l h_vmem=4G #{@account} \
     #{@bwa} aln -t 8 -f #{sai_file} #{@index} #{fastq_file} "
  end

end