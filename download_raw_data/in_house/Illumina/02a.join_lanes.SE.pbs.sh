#!/bin/bash
# ----------------QSUB Parameters----------------- #
#PBS -q MASTER
#PBS -M fihorvat@gmail.com
#PBS -m n
#PBS -N pbs.02.join_demultiplexed
#PBS -l select=ncpus=1:mem=5g
#PBS -J 0-27
#PBS -j oe
cd $PBS_O_WORKDIR

# ----------------Loading variables------------------- #
# set input dir and find sample names
INPUT_DIR=./Kulmann_01_2022
IN_SEQ=($(find ${INPUT_DIR} -name "*.fastq.gz"))
IN_SEQ=($(printf "%s\n" "${IN_SEQ[@]##${INPUT_DIR}*/}"))
UNIQ_SEQ=($(printf "%s\n" "${IN_SEQ[@]%_L00[1-4]_R[1-2]_001.fastq.gz}" | sort -u))

# get sample names and list of fastq files for each name
SAMPLE_NAME=${UNIQ_SEQ[$PBS_ARRAY_INDEX]}
SAMPLE_LIST_1=($(find ${INPUT_DIR} -name "${SAMPLE_NAME}*R1*.fastq.gz" | xargs echo))

# ----------------Commands------------------- #
# join each demultiplexed samples to one file per sample per pairing
cat ${SAMPLE_LIST_1[@]} > ${SAMPLE_NAME}.fastq.gz
chmod 444 ${SAMPLE_NAME}.fastq.gz
