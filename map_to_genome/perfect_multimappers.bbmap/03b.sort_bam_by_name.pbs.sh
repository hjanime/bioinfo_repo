#!/bin/bash
# ----------------QSUB Parameters----------------- #
#PBS -q MASTER
#PBS -M fihorvat@gmail.com
#PBS -m n
#PBS -N pbs.03b.sort_bam_by_name
#PBS -l select=ncpus=12:mem=60g
#PBS -J 0-%N_SAMPLES
#PBS -j oe
cd $PBS_O_WORKDIR

# ----------------Loading variables------------------- #
MEMORY=60GB
THREADS=12

INPUT_DIR=.
IN_SEQ=($(find $INPUT_DIR -name "*.bam" -not -name "*genome*" -not -name "*sortedByName*"))
FILE=${IN_SEQ[$PBS_ARRAY_INDEX]}
BASE=${FILE#${INPUT_DIR}/}
BASE=${BASE%.bam}

# ----------------Commands------------------- #
# sort by name
samtools sort -o ${BASE}.sortedByName.bam -n -@ $THREADS $FILE
