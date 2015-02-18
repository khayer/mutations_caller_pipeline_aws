mkdir xls_sheets_125FBGB
for i in 21
do 
  #qsub -cwd -b y -V -N Chr$i\_score_01GBFB 
  ~/tools/scripts/create_spreadsheet_125FBGB snpEff_chr$i.Zv9.74.vcf xls_sheets_125FBGB/125FBGB_Chr$i\_HIGH.xls 4 1,2,3,5,6,7,9,11,12,13,14 18 19 ~/index/phastConsElements8way.txt scores_125FBGB_ws100_q10/chr$i\_125FBGB 
done