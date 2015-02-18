mkdir xls_sheets_105FEGG
for i in {1..25} 
do 
  #qsub -cwd -b y -V -N Chr$i\_score_01GBFB 
  bsub -q plus create_spreadsheet_105FEGG snpEff_chr$i.Zv9.74.vcf xls_sheets_105FEGG/105FEGG_Chr$i\_HIGH.xls 3 1,2,4,5,6,7,9,11,12,13,14 18 19 ~/index/phastConsElements8way.txt scores_105FEGG_ws100_q5_slider/chr$i\_105FEGG 
done