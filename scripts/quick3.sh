for i in {1..25} M
do 
    echo "Chr $i"
    mv chr$i.vcf chr$i.tmp.vcf
    bsub cat header.vcf chr$i.tmp.vcf \> chr$i.vcf
done
