#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 01GBFB 100 15 1
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 105FEGG 100 15 2
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 125FBGB 100 15 3
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 17FBGA_mut 100 12 4
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 20FYGD_mut 100 15 5
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 25FUGK_mut 100 7 6
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 25FUGK_sib 100 9 7
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 46FWGA_mut 100 4 8
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 46FWGA_sib 100 6 9
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 66FEGG 100 15 10
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 71FAGA 100 15 11
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 72FAGA 100 10 12
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 84FBGB_mut 100 15 13
#qsub -b y -V -l h_vmem=1G -cwd bash quick_generic.sh 84FBGB_sib 100 15 14
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic.sh 06JRKS 100 10 2
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic_slider.sh 06JRKS 50 10 2
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic_slider.sh 06JRKS 20 10 2
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic_slider.sh 06JRKS 10 10 2
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic_slider.sh 06JRKS 5 10 2
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic_slider.sh 06JRKS 100 10 2
#bsub -o generic_125FBGB.o.log -e generic_125FBGB.e.log  bash quick_generic.sh 125FBGB 100 10 4
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic_slider.sh 06JRKS 50 5 2
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic_slider.sh 06JRKS 20 5 2
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic_slider.sh 06JRKS 10 5 2
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic_slider.sh 06JRKS 5 5 2
#bsub -o generic_06JRKS.o.log -e generic_06JRKS.e.log  bash quick_generic_slider.sh 06JRKS 100 5 2
bsub -o generic_16FQGK.o.log -e generic_16FQGK.e.log  bash quick_generic_slider.sh 16FQGK 100 5 5
bsub -o generic_26FQGB.o.log -e generic_26FQGB.e.log  bash quick_generic_slider.sh 26FQGB 100 5 10
bsub -o generic_84FUGK.o.log -e generic_84FUGK.e.log  bash quick_generic_slider.sh 84FUGK 100 5 18

