#!/usr/env nextflow

nextflow.enable.dsl=2

process run_rmats {
	tag "${condA}-vs-${condB}"
    publishDir "results/rmats/${condA}-vs-${condB}", mode: 'copy'

    input:
	tuple val(condA), path(condA_rep1), path(condA_rep2), path(condA_rep3)
	tuple val(condB), path(condB_rep1), path(condB_rep2), path(condB_rep3)
	path all_bai
	path gene_annot

	output:
	path ("*")

	"""
	echo ${condA_rep1},${condA_rep2},${condA_rep3} > b1.txt
	echo ${condB_rep1},${condB_rep2},${condB_rep3} > b2.txt
	python /rmats/rmats.py --b1 b1.txt --b2 b2.txt --gtf ${gene_annot} --readLength 100 --libType fr-unstranded -t paired --nthread 4 --od . --tmp tmp_output --variable-read-length
	"""
}
