mkdir xls_sheets_26FQGB_all
for i in {1..25} M
do 
  #qsub -cwd -b y -V -N Chr$i\_score_01GBFB 
    echo Chr$i
    bsub ~/tools/scripts/create_spreadsheet_105FEGG chr$i.vcf xls_sheets_26FQGB_all/26FQGB_Chr$i\_HIGH.xls 10 1,2,3,4,5,6,7,8,11,13,14,15,16,18 21 22 ~/index/phastConsElements8way.txt  scores_26FQGB_ws100_q5_slider/chr$i\_26FQGB
done