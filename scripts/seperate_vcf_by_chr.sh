for i in {1..25} M
do 
    echo "Chr $i"
    bsub grep -w chr$i output2.ann.gatk.FLI.vcf \> vcf_by_chr/chr$i.vcf   
done
