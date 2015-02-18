mkdir xls_sheets_16FQGK_all
for i in {1..25} M
do 
  #qsub -cwd -b y -V -N Chr$i\_score_01GBFB 
    echo Chr$i
    bsub create_spreadsheet_105FEGG chr$i.vcf xls_sheets_16FQGK_all/16FQGK_Chr$i\_HIGH.xls 5 1,2,3,4,6,7,8,10,11,13,14,15,16,18 21 22 ~/index/phastConsElements8way.txt  scores_16FQGK_ws100_q5_slider/chr$i\_16FQGK 
done