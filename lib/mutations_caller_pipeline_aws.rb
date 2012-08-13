=begin
  * Name: Mutations Caller Pipeline (AWS)
  * Pipeline combining bwa with GATK2
  * Author: Katharina Hayer
  * Date: 8/9/2012
  * License: GNU General Public License (GPL-2.0)
=end
require 'mutations_caller_pipeline_aws/structurer'
require 'mutations_caller_pipeline_aws/caller'
require 'mutations_caller_pipeline_aws/bwa_caller'
require 'mutations_caller_pipeline_aws/gatk_caller'
require 'mutations_caller_pipeline_aws/picard_caller'

class MutationsCallerPipelineAws
  def self.hi
    "Hello World!"
  end
end


