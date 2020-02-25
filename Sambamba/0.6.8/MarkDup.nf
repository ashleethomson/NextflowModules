
process MarkDup {
  tag {"SAMBAMBA_markdup ${sample_id}"}
  label 'SAMBAMBA_markdup_0_6_8'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.markdup_mem}" : ""
  container = 'library://sawibo/default/bioinf-tools:sambamba-0.6.8'
  
  input:
    tuple sample_id, rg_ids, file(bams), file(bais)

  output:
    tuple sample_id, file("${sample_id}_dedup.bam"), file("${sample_id}_dedup.bai")

  script:
  """
  sambamba markdup ${params.markdup.toolOptions} --tmpdir=\$PWD/tmp -t ${task.cpus} ${bams} ${sample_id}_dedup.bam
  sambamba index -t ${task.cpus} ${sample_id}_dedup.bam ${sample_id}_dedup.bai
  """
}
