process SplitIntervals {
    tag {"GATK_splitintervals"}
    label 'GATK_4_1_3_0'
    label 'GATK_splitintervals_4_1_3_0'
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    
    input:
      val mode
      file(scatter_interval_list)

    output:
      file("temp_*/scattered.interval_list")

    script:

    break_bands_at_multiples_of = mode == 'break' ? 1000000 : 0

    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    IntervalListTools \
  		-I ${scatter_interval_list} \
  		-M BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW \
  		--SCATTER_COUNT $params.scatter_count \
      --UNIQUE true \
      --BREAK_BANDS_AT_MULTIPLES_OF $break_bands_at_multiples_of \
  		-O .

    """
}