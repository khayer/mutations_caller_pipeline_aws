

# bsub -o transcript_prediction_%J_o.log -e transcript_prediction_%J_e.log -N ~/itmat/bp2/tools/MiTie/src/transcript_prediction fn_graph ../tophat_out_new_test/accepted_hits.bam --fn-quant quant.txt --fn-out result.gtf --order 1

usage = "
Usage:
#{$0} fn_graph num_graphs bam_file final.gtf final_count

"

unless ARGV.length == 5
  puts usage
  exit
end

fn_graph = ARGV[0]
num_graphs = ARGV[1].to_i
bam_file = ARGV[2]
final_gtf = ARGV[3]
final_count = ARGV[4]
id = rand(100000)
running_jobs = {}
i = 1
cut_off = 200
not_finished = true


while not_finished
  while running_jobs.length < cut_off && i < num_graphs
    l = `bsub -q max_mem30 -n 3 -J #{id}_#{i} -o tp_%J_#{id}_#{i}_o.log -e tp_%J_#{id}_#{i}_e.log ~/itmat/bp2/tools/MiTie/src/transcript_prediction #{fn_graph} #{bam_file} --fn-quant quant_#{i}.txt --fn-out result_#{i}.gtf --order 1 --graph-id #{i}`
    l =~ /\<(\d*)\>/
    running_jobs[$1] = [i,"tp_#{$1}_#{id}_#{i}_o.log","tp_#{$1}_#{id}_#{i}_e.log","result_#{i}.gtf","quant_#{i}.txt"]
    i += 1
  end
  break if running_jobs.length == 0
  sleep 50
  running_jobs.each_pair do |key,files|
    l = `bjobs -l #{key}`.gsub(/\s/,"")
    case 
    when l =~ /(Status<RUN>|Status<PEND>)/
      next
    when l =~ /Status<EXIT>/
      puts "#{key} died on graph id #{files.join(":")}"
      running_jobs.delete(key)
    when l =~ /Status<DONE>/
      # merge
      #puts "Graph id #{files[0]} done succesfully"
      `cat #{files[3]} >> #{final_gtf}`
      k = $?.to_i
      `cat #{files[4]} >> #{final_count}`
      l = $?.to_i
      #puts "got here k: #{k} l: #{l}"
      if k + l == 0
        `rm #{files[1..-1].join(" ")}`
        raise "rm #{files[1..-1].join(" ")} was not succesful!" unless $?.to_i
      else
        raise "cat was unsuccesful"
      end
      running_jobs.delete(key)
    end
  end
end
