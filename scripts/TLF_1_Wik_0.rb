#!/usr/bin/env ruby

usage =<<EOF

      #{$0} comb target control chrom snps [num] [window]

      ------------------------------------------------------
      * comb     :: combined_vcf
      * target   :: position in vcf file
      * control  :: position in vcf file (seperated by ,)
      * chrom    :: current chromosome
      * snps     :: outfile
      * num      :: min_number_of_reads
      * window   :: snp_window
      ------------------------------------------------------

      - VERSION 2/10/2016 -----------------------------------

      ------------------------------------------------------
      Homozygosity Score is definied as:
      total # of bases examined / total # bases on chromosome
      in a 1MB window

      control for Wik and TLF (background strains) only!

      format out:

      position tlf_base wik_base Zv9_base tlf_reads wik_reads score
      ...
      500000  T  A  A 5032  5996 .5
      500001  T  C  T 0  5996 0
      500002  T  A  A 5032  0 1
      ...

                                                       by khayer

EOF

# Functions:
def snp_exist?(info)
  !(info =~ /\.\/\./) #&& !(info =~ /0\/0/)
end

def snp_homo?(info)
  (info =~ /0\/0/) || (info =~ /1\/1/) || (info =~ /2\/2/) || (info =~ /3\/3/)
end

def getScore(target_read_dis,tlf_read_dis,wik_read_dis)
  score = 0.0

  if tlf_read_dis[0].to_f > tlf_read_dis[1].to_f
    score = target_read_dis[0].to_f / (target_read_dis[0].to_f + target_read_dis[1].to_f)
  else
    score = target_read_dis[1].to_f / (target_read_dis[0].to_f + target_read_dis[1].to_f)
  end
  score = 0.5 if score.nan?()
  #STDIN.gets
  score
end

# _ Main _:
unless ARGV.length >= 5
  puts usage
  exit
end

combined_vcf = ARGV[0]
target_pos = ARGV[1].to_i + 8
control_positions = ARGV[2].split(",").map {|ele| ele.to_i + 8}
current_chromosome = ARGV[3]
snps_file = ARGV[4]
min_number_of_reads = ARGV[5].to_f if ARGV[5]
snp_window = ARGV[6].to_i if ARGV[6]

window_length = 250000
window_first = 0
window_second = -window_length/2


all_snps_first_window = 0
all_snps_second_window = 0
homozygous_snps_first_window = 0
homozygous_snps_second_window = 50
score_first_window = 0.0
score_second_window = 0.0
dummy = false
positions = Array.new
homozygous = Array.new
total_bases_examined = 0
min_number_of_reads = 15.0 unless min_number_of_reads
snp_window = 100 unless snp_window
sliding_window = []
chr_lengths = Hash.new()
scores = []

counter = 0
snps = []
chromosome = ''
puts "position\tTLF\tWik\tZv9_base\talt_base\ttarget_tlf_reads\ttarget_wik_reads\tscore"
File.open(combined_vcf).each do |line|
  if line =~ /ID=chr/
    leng = line.split("=")[-1].split(">")[0].to_i
    chr = line.split("=")[-2].split(",")[0]
    chr_lengths[chr] = leng
  end
  next if line =~ /^#/  # getting rid of header lines
  line.chomp!

  line = line.split("\t")
  zv9_base = line[3]
  alt_base = line[4]
  next if alt_base.split(",").length != 1
  target_info = line[target_pos]
  next unless snp_exist?(target_info)

  tlf_info = line[control_positions[0]]
  wik_info = line[control_positions[1]]

  next unless snp_homo?(tlf_info) && snp_homo?(wik_info)
  next unless tlf_info.split(":")[3].to_i >= 25 && wik_info.split(":")[3].to_i >= 25
  next if tlf_info.split(":")[0] == wik_info.split(":")[0]


  tlf_info = tlf_info.split(":")
  wik_info = wik_info.split(":")
  next unless tlf_info[2].to_f >= 15.0 && wik_info[2].to_f >= 15.0
  next unless tlf_info[1].split(",")[0] == "0" || tlf_info[1].split(",")[1] == "0"
  next unless wik_info[1].split(",")[0] == "0" || wik_info[1].split(",")[1] == "0"
  #puts tlf_info
  #puts wik_info
  #STDIN.gets
  target_info = target_info.split(":")

  next unless target_info[2].to_f >= min_number_of_reads
  #puts line
  #puts target_info
  #STDIN.gets
  # TLF is closer to 1 / Wik closer to 0
  target_read_dis = target_info[1].split(",")

  tlf_read_dis = tlf_info[1].split(",")
  wik_read_dis = wik_info[1].split(",")
  current_score = getScore(target_read_dis,tlf_read_dis,wik_read_dis)
  #if target_read_dis[0] == "0" || target_read_dis[1] == "0"
  #  puts current_score
  #  puts target_info
  #  puts "TLF"
  #  puts tlf_info
  #  puts "Wik"
  #  puts wik_info
  #  STDIN.gets
  #end
  score_first_window += current_score #getScore(target_read_dis,tlf_read_dis,wik_read_dis)
  score_second_window += current_score #getScore(target_read_dis,tlf_read_dis,wik_read_dis)
  homozygous_snps_first_window += 1
  homozygous_snps_second_window += 1
  sliding_window << current_score

  position = line[1].to_i

  counter += 1
  snps[position/window_length] = 0 unless snps[position/window_length]
  snps[position/window_length] += 1
  #puts position
  #puts position/window_length
  #puts snps
  #STDIN.gets
  #if position > 20000000
  #  puts target_info.join(":")
  #  puts tlf_info.join(":")
  #  puts wik_info.join(":")
  #  puts current_score
  #  STDIN.gets
  #end
  if sliding_window.length == snp_window
    average = sliding_window.inject{ |sum, el| sum + el }.to_f / sliding_window.size
    sliding_window.delete_at(0)
    #puts "#{position}\t#{average}"
    puts "#{position}\t#{tlf_read_dis.join(",")}\t#{wik_read_dis.join(",")}\t#{zv9_base}\t#{alt_base}\t#{target_read_dis[0]}\t#{target_read_dis[1]}\t#{average}"
  end

end

#total_number_of_bases_in_chromosome = chr_lengths[current_chromosome]

#scores.each_with_index do |score,i|
#  pos = positions[i]
#  #ratio = homozygous[i].to_f * total_bases_examined.to_f/total_number_of_bases_in_chromosome.to_f
#  puts "#{pos}\t#{score}"
#end

#out = File.open("#{snps_file}_poly.txt","w")
#
#snps.each_with_index do |snp,i|
#  k = i
#  if snp
#    #out.puts("#{i*window_length}\t#{snp/counter.to_f}")
#    #out.puts("#{i*window_length+window_length-1}\t#{snp/counter.to_f}")
#    #puts snp
#    out.puts("#{k*window_length}\t#{snp}")
#    out.puts("#{k*window_length+window_length-1}\t#{snp}")
#  else
#    out.puts("#{k*window_length}\t0")
#    out.puts("#{k*window_length+window_length-1}\t0")
#  end
#end

