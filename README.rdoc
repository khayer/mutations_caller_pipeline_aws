= Mutations Caller Pipeline (AWS)

This pipeline was created to automate several steps in the first part of a sequence analysis. The steps are basically the mapping of reads in fastq files, the preparing of the resulting raw bam files and the varation calling in the end. The pipeline will make it easy to get from fastq to vcf file, without running all the single steps in between. It is designed for to run on a cluster like AWS.

Unfortunately this is only a first edition, which is fully functional but poorly tested and the pipeline can not restart itself if there happens to be any errors.

= License

This source code is licensed under the GNU General Public License (GPL-2.0) (http://opensource.org/licenses/gpl-2.0.php).