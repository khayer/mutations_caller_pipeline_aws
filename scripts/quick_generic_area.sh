EXPECTED_ARGS=7
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` sample_name window_size quality sample_number lower_bound upper_bound chromosom_number"
  exit $E_BADARGS 
fi

sample_name=$1
window_size=$2
quality=$3
sample_number=$4
lower_bound=$5
upper_bound=$6
chromosome_number=$7
mkdir scores_$sample_name\_ws$window_size\_q$quality
for i in $chromosome_number
do 
  echo "Chr $i"
  ~/Tools/scripts/homozygosity_score_2_22_13 Chr$i.vcf $sample_number 17,18 chr$i scores_$sample_name\_ws$window_size\_q$quality/chr$i $quality $window_size > scores_$sample_name\_ws$window_size\_q$quality/chr$i\_$sample_name 
done

Rscript quick_generic_area.r scores_$sample_name\_ws$window_size\_q$quality $sample_name $lower_bound $upper_bound $chromosome_number
