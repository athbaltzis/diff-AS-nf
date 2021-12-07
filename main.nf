#!/usr/env nextflow

/*
 * Copyright (c) 2021-2022,the author.
 *
 *   This file is part of 'XXXXXX'.
 *
 *   XXXXXX is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   XXXXXX is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with XXXXXX.  If not, see <http://www.gnu.org/licenses/>.
 */


/*
 *
 * @author
 * Athanasios Baltzis <baltzis.athanasios@gmail.com>
 *
 *
*/



nextflow.enable.dsl=2

include {run_rmats} from './modules/rmats.nf'
include {build_mode;test_mode} from './modules/spladder.nf'

params.tool = "rmats" // [rmats, spladder]
params.input_csv = "bams.csv"
Channel.fromPath(params.input_csv).splitCsv(header:true).map{row-> tuple(file(row.rep1), file(row.rep2), file(row.rep3))}.collect().set{bams_collected}
Channel.fromPath(params.input_csv).splitCsv(header:true).map{row-> tuple(row.condition, file(row.rep1), file(row.rep2), file(row.rep3))}.set{input}
params.groupA = "6_days_mock"
Channel.from(params.groupA).set{condA}
params.groupB = "6_days_inf"
Channel.from(params.groupB).set{condB}
condA.join(input).set{bamsA}
condB.join(input).set{bamsB}
params.gtf = "GCF_000188115.4_SL3.0_genomic.mod.gtf"
Channel.fromPath(params.gtf).set{gtf_file}
params.bai = "results_SL_3.0/hisat2/*.bai"
Channel.fromPath(params.bai).collect().set{bai_files}

log.info """\
Differential Alternative Splicing Analysis - version 0.1
=====================================
Tool:			${params.tool}
Input files:		${params.input_csv}
Group A:		${params.groupA}
Group B:		${params.groupB}
GTF file:		${params.gtf}
"""
.stripIndent()


workflow rmats {
	run_rmats(bamsA,bamsB,bai_files,gtf_file)
}

workflow spladder {
	build_mode(gtf_file,bams_collected,bai_files)
	test_mode(bamsA,bamsB,build_mode.out,bai_files)
}

workflow {
	if (params.tool == 'rmats')
    	rmats()
    else
        spladder()
}

workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}
