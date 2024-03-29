#!/bin/bash
# ----------------QSUB Parameters----------------- #
#PBS -q MASTER
#PBS -M fihorvat@gmail.com
#PBS -m n
#PBS -N pbs.02.scale_bigWig
#PBS -l select=ncpus=1:mem=10g
#PBS -J 0-%N_JOBS
#PBS -j oe
cd $PBS_O_WORKDIR

# ----------------Loading variables------------------- #
# source
source ./000.load_variables.sh

# override number of threads
THREADS=1

# input
INPUT_DIR=.
IN_SEQ=($(find $INPUT_DIR -maxdepth 1 \( -name "*.bam" \)))
FILE=${IN_SEQ[$PBS_ARRAY_INDEX]}
BASE=${FILE#${INPUT_DIR}/}
BASE=${BASE%.bam}

# ----------------Commands------------------- #
### get number of mapped reads in millions
# scale to number of 19-32nt reads in million
if [ ${SCALING} == "19to32nt" ]
then
        REPLICATE=${BASE%.*}
        READ_LENGTH="19to32nt"
        awk -v PAT="${REPLICATE%.${LAYOUT}}.*${READ_LENGTH}\t" -F '\t' '$0 ~ PAT {print $0}' ${LOG}
        SCALE_FACTOR=$(awk -v PAT="${REPLICATE%.${LAYOUT}}.*${READ_LENGTH}\t" -F '\t' '$0 ~ PAT {sum += $3} END {print 1000000 / sum}' ${LOG})
        BASE=${BASE}.scaled_19to32

# scale each read length to total number of reads of the respective length
else
        REPLICATE=${BASE%.*}
        READ_LENGTH=${BASE#*.${LAYOUT}.}

        # special case when reads of all lengths are used as scaling factor
        if [ $READ_LENGTH == ${BASE} ]
        then
                awk -v PAT="${REPLICATE}.*${LAYOUT}\t" -F '\t' '$0 ~ PAT {print $0}' ${LOG}
                SCALE_FACTOR=$(awk -v PAT="${REPLICATE}.*${LAYOUT}\t" -F '\t' '$0 ~ PAT {sum += $3} END {print 1000000 / sum}' ${LOG})
                BASE=${BASE}.scaled
        
	# otherwise use respective read lengths as scaling factor
        else
                awk -v PAT="${REPLICATE%.${LAYOUT}}.*${READ_LENGTH}\t" -F '\t' '$0 ~ PAT {print $0}' ${LOG}
                SCALE_FACTOR=$(awk -v PAT="${REPLICATE%.${LAYOUT}}.*${READ_LENGTH}\t" -F '\t' '$0 ~ PAT {sum += $3} END {print 1000000 / sum}' ${LOG})
                BASE=${BASE}.scaled
        fi

fi

# bam to scaled bedGraph, bedGraph to bigWig
genomeCoverageBed -ibam ${FILE} -bg -scale ${SCALE_FACTOR} -split > ${BASE}.bedGraph
wigToBigWig ${BASE}.bedGraph ${CHR_LENGTH} ${BASE}.bw
[ -f "${BASE}.bw" ] && rm ${BASE}.bedGraph
