mkdir xls_sheets_84FUGK_all
for i in {1..25} M
do 
  #qsub -cwd -b y -V -N Chr$i\_score_01GBFB 
    echo Chr$i
    bsub ~/tools/scripts/create_spreadsheet_105FEGG chr$i.vcf xls_sheets_84FUGK_all/84FUGK_Chr$i\_HIGH.xls 18 1,2,3,4,5,6,7,8,10,11,13,14,15,16 21 22 ~/index/phastConsElements8way.txt  scores_84FUGK_ws100_q5_slider/chr$i\_84FUGK
done