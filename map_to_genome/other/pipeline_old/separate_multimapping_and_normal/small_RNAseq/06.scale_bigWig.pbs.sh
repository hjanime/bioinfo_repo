#!/bin/bash
# ----------------QSUB Parameters----------------- #
#PBS -q MASTER
#PBS -M fihorvat@gmail.com
#PBS -m n
#PBS -N pbs.06.scale_bigWig
#PBS -l select=ncpus=1:mem=10g
#PBS -j oe
#PBS -J 0-%N_TOTAL
cd $PBS_O_WORKDIR

# ----------------Loading variables------------------- #
# source
source ./000.load_variables.sh

# override number of threads
THREADS=1

# input 
INPUT_DIR=.
IN_SEQ=($(find $INPUT_DIR -maxdepth 1 \( -name "*.bam" -not -name "*genome*" -not -name "*rDNA_45S*" -not -name "*sortedByName*" \)))
FILE=${IN_SEQ[$PBS_ARRAY_INDEX]}
BASE=${FILE#${INPUT_DIR}/}
BASE=${BASE%.bam}

# log file
LOG=$(find . -maxdepth 1 -name "log.read_stats.txt")

# ----------------Commands------------------- #
# get number of mapped reads in millions
if [ ${SCALING} == "19to32nt" ]
then
   SAMPLE=${BASE%%.*}
   SAMPLE=${SAMPLE}.SE.19to32nt
   SCALE_FACTOR=$(awk -v PAT="${SAMPLE}\t" -F '\t' '$0 ~ PAT {print 1000000 / $3}' ${LOG})
   BASE=${BASE}.scaled_19to32
else
   SAMPLE=${BASE}
   SCALE_FACTOR=$(awk -v PAT="${SAMPLE}\t" -F '\t' '$0 ~ PAT {print 1000000 / $3}' ${LOG})
   BASE=${BASE}.scaled
fi

# bam to scaled bedGraph, bedGraph to bigWig
genomeCoverageBed -ibam ${FILE} -bg -scale ${SCALE_FACTOR} -split > ${BASE}.bedGraph
wigToBigWig ${BASE}.bedGraph ${CHR_LENGTH} ${BASE}.bw
[ -f "${BASE}.bw" ] && rm ${BASE}.bedGraph
