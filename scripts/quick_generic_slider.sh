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
mkdir scores_$sample_name\_ws$window_size\_q$quality\_slider
for i in {1..25}
do 
  echo "Chr $i"
  ~/tools/scripts/homozygosity_score_3_7_13_sliding_window chr$i.vcf $sample_number 21,22 chr$i scores_$sample_name\_ws$window_size\_q$quality\_slider/chr$i $quality $window_size > scores_$sample_name\_ws$window_size\_q$quality\_slider/chr$i\_$sample_name 
done

Rscript quick_generic.r scores_$sample_name\_ws$window_size\_q$quality\_slider $sample_name $window_size
