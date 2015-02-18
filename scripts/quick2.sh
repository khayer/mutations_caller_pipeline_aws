for i in {1..25} M Y X
do
  bsub -q max_mem64 -J snpEff_chr$i -o snpEff_chr$i.o.log -e snpEff_chr$i.e.log java -jar ~/snpEff/snpEff.jar eff -t -no-intergenic -i vcf -o vcf Zv9.74 Chr$i.vcf -c ~/snpEff/snpEff.config \> snpEff_chr$i.Zv9.74.vcf
done