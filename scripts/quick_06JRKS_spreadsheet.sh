mkdir xls_sheets_06JRKS
for i in {1..25}
do 
  #qsub -cwd -b y -V -N Chr$i\_score_01GBFB 
  ~/tools/scripts/create_spreadsheet_Jan snpEff_chr$i.Zv9.74.vcf xls_sheets_06JRKS/06JRKS_Chr$i\_HIGH.xls 2 1,3,4,5,6,7,9,11,12,13,14 18 19 ~/index/phastConsElements8way.txt  scores_06JRKS_ws100_q10/chr$i\_06JRKS 
done