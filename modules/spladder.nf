#!/usr/env nextflow

nextflow.enable.dsl=2

process build_mode {
    publishDir "results/spladder", mode: 'copy'

	input:
	path gene_annot
	path all_bams
	path all_bai

	output:
	path ("*")

	"""
	spladder build -o spladder_out -a ${gene_annot} -b ${all_bams.join(",")}
	"""
}
process test_mode {
	tag "${condA}-vs-${condB}"
    publishDir "results/spladder/${condA}-vs-${condB}", mode: 'copy'

    input:
	tuple val(condA), path(condA_rep1), path(condA_rep2), path(condA_rep3)
	tuple val(condB), path(condB_rep1), path(condB_rep2), path(condB_rep3)
	path build_output
	path all_bai

	output:
	path ("*")

	"""
	spladder test --conditionA ${condA_rep1},${condA_rep2},${condA_rep3} --conditionB ${condB_rep1},${condB_rep2},${condB_rep3} --labelA ${condA} --labelB ${condB} --outdir spladder_out --parallel 4
	mv spladder_out/testing_"${condA}"_vs_"${condB}"/* .
	"""
}
