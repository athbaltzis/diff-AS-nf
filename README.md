# diff-AS-nf
Nextflow DSL2 pipeline for differential Alternative Splicing analysis using rMATS or SplAdder

## Quick start

Make sure you have docker/singularity installed.

Install the Nextflow runtime by running the following command:

`curl -fsSL get.nextflow.io | bash`

You can launch the pipeline execution by entering the command shown below specifying the required parameters:

`nextflow run athbaltzis/diff-AS-nf`

## Pipeline parameters

#### `--tool`

 - Specifies the tool you want to use in your analysis [rmats or spladder]

#### `--input_csv`

 - Specifies the input csv file that contains the information about the conditions of the samples and the paths of the bam files (see data/bams.csv)

#### `--groupA`

 - Specifies the name of the first group of samples you want to inlude in the analysis

#### `--groupB`

 - Specifies the name of the second group of samples you want to inlude in the analysis

#### `--gtf`

 - Specifies the path to the GTF file required for the analysis

#### `--bai`

 - Specifies the path to the indexed bam files (.bai) required for the analysis
