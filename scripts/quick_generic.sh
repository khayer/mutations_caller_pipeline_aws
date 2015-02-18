EXPECTED_ARGS=4
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` sample_name window_size quality sample_number"
  exit $E_BADARGS 
fi

sample_name=$1
window_size=$2
quality=$3
sample_number=$4
mkdir scores_$sample_name\_ws$window_size\_q$quality
for i in {1..25}
do 
  echo "Chr $i"
  ~/tools/scripts/homozygosity_score_2_22_13 Chr$i.vcf $sample_number 18,19 chr$i scores_$sample_name\_ws$window_size\_q$quality/chr$i $quality $window_size > scores_$sample_name\_ws$window_size\_q$quality/chr$i\_$sample_name 
done

Rscript quick_generic.r scores_$sample_name\_ws$window_size\_q$quality $sample_name $window_size

