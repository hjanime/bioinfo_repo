#!/bin/bash
# ----------------QSUB Parameters----------------- #
#PBS -q MASTER
#PBS -M fihorvat@gmail.com
#PBS -m n
#PBS -N pbs.01.merge_bams
#PBS -l select=ncpus=6:mem=30g
#PBS -J 0-2
#PBS -j oe
cd $PBS_O_WORKDIR

# ----------------MAP MERGED------------------- #
# variables
THREADS=6
INPUT_DIR=..

# list files
FILES_LIST=($(find ${INPUT_DIR} -maxdepth 1 \( -name "*bam" -not -name "*bai" -and -name "*19to32nt*" \)))

# get unique sample names
SAMPLE_NAMES=(${FILES_LIST[@]%_r[1-9]*.[S,P]E.*bam})
SAMPLE_NAMES=(${SAMPLE_NAMES[@]#${INPUT_DIR}/})

# get samples
SAMPLES=($(printf "%s\n" ${SAMPLE_NAMES[@]} | sort -u))
SAMPLE=${SAMPLES[$PBS_ARRAY_INDEX]}

# get read names, loop through
READ_LENGTHS=(19to32nt)

# ----------------Commands------------------- #
# loop through different read lengths and merge
for READ_LENGTH in ${READ_LENGTHS[@]}
do
        # list files
	FILES_LIST=($(find ${INPUT_DIR} -maxdepth 1 \( -name "${SAMPLE}*.${READ_LENGTH}.bam" -not -name "*bai" \)))
        FILES_LIST=$(printf "%s " ${FILES_LIST[@]})

        # just in case
        echo ${READ_LENGTH}
        printf "%s\n" ${FILES_LIST}

        # set file name
        FILE_NAME=${SAMPLE}.${READ_LENGTH}
	
	# merge
	sambamba merge ${FILE_NAME}.bam ${FILES_LIST} -t ${THREADS}

done
