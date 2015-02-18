mkdir xls_sheets_HSMutant
for i in {1..25}
do 
  #qsub -cwd -b y -V -N Chr$i\_score_01GBFB 
  ~/tools/scripts/create_spreadsheet_Jan snpEff_chr$i.Zv9.74.vcf xls_sheets_HSMutant/HSMutant_Chr$i\_HIGH.xls 15 1,2,3,4,5,6,8,10,11,12,13 18 19 ~/index/phastConsElements8way.txt  scores_HSMutant_ws100_q5/chr$i\_HSMutant 
done