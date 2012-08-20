# Mutations Caller Pipeline (AWS)

This pipeline was created to automate several steps in the first part of a sequence analysis. The steps are basically the mapping of reads in fastq files, the preparing of the resulting raw bam files and the variation calling in the end. The pipeline will make it easy to get from fastq to vcf file, without running all the single steps in between. It is designed for to run on a cluster like AWS.

Unfortunately this is only a first edition, which is fully functional but poorly tested and the pipeline can not restart itself if there happens to be any errors.

## License

This source code is licensed under the GNU General Public License (GPL-2.0) (http://opensource.org/licenses/gpl-2.0.php).

## Prerequisites

To run the tests with the beautiful redgreen output, you will need the mynyml-redgreen gem. 

  	% gem install mynyml-redgreen --source http://gemcutter.org

If you do not care about this at all, you can just command `require 'redgreen'` out.

## Install

The easiest is probably to install it via RubyGems, where you can just type

 	 % gem install mutataions_caller_pipeline_aws

### An alternative way ...

... would be to clone the master branch in a desired directory:

  	% git clone git://github.com/khayer/mutations_caller_pipeline_aws.git

To install the gem you will now need to type

 	% cd mutations_caller_pipeline_aws
  	% rake

## Config File

This file should be in the ruby .yml format. In this file you will need to include the directories to bwa, GATK2 and Picard.

