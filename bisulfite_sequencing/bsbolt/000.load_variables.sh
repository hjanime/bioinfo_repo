#/bin/bash
# ----------------Loading variables------------------- #
#### experiment
EXPERIMENT=${PWD%/Data*}
EXPERIMENT=${EXPERIMENT##/*/}
EXPERIMENT_NAME=${EXPERIMENT%_*_*}

#### input
SINGLE_END=FALSE
IN_GENOME=golden_hamster/Siomi_assembly.fixed
INPUT_DIR=../../Raw/Cleaned/sample_fastq
SJDB_OVERHANG=sjdbOverhang_100
HEX_OUT=in_house/hamster_KO/Siomi/${EXPERIMENT}/bsbolt_Siomi

# input fastq files
IN_SEQ=($(find $INPUT_DIR -maxdepth 1 \( -name "*.txt.gz" -not -name "*all*" -not -name "*converted*" \)))

### load
# scripts to change
SCRIPTS=($(find . -maxdepth 1 \( -name "0*.sh" -not -name "00b.change_scripts.sh" \)))

# input genome files
GENOME_BASE=/common/DB/genome_reference
GENOME_PATH=${GENOME_BASE}/${IN_GENOME}
BSBOLT_INDEX=${GENOME_PATH}/bsbolt_index
STAR_INDEX=${GENOME_PATH}/STAR_index.2.7/${SJDB_OVERHANG}
CHR_LENGTH=${STAR_INDEX}/chrNameLength.txt

# paths for tracks
HEX_PATH=~/public_html/Svoboda/bw_tracks/${HEX_OUT}
LOBSANG_PATH=${PWD/common/common-lobsang}
