#/bin/bash
# ----------------Loading variables------------------- #
#### experiment
EXPERIMENT=${PWD%/Data*}
EXPERIMENT=${EXPERIMENT##/*/}
EXPERIMENT_NAME=${EXPERIMENT%_*_*}

#### input
SINGLE_END=TRUE
IN_GENOME=cow/bosTau9.ARS-UCD1.2.GCA_002263795.2
INPUT_DIR=../../Raw/Cleaned
ENSEMBL_VERSION=99
SJDB_OVERHANG=sjdbOverhang_100
HEX_OUT=accessory_data_sets/${EXPERIMENT}/oocyte
CLASS_ALGORITHM=loop #loop or data.table

# chose .bw track scaling (19to32nt or respective)
SCALING="19to32nt"

# input fastq files
IN_SEQ=($(find $INPUT_DIR -maxdepth 1 \( -name "*.txt.gz" -not -name "*atrim.txt.gz" -and -name "*MI*" -not -name "*cumulus*" \)))

### load
# scripts to change
SCRIPTS=($(find . -maxdepth 1 \( -name "0*.sh" -not -name "00b.change_scripts.sh" \)))

# input genome files
GENOME_BASE=/common/DB/genome_reference
GENOME_PATH=${GENOME_BASE}/${IN_GENOME}
STAR_INDEX=${GENOME_PATH}/STAR_index.2.7/${SJDB_OVERHANG}
CHR_LENGTH=${STAR_INDEX}/chrNameLength.txt

# input features for classifying reads
FEATURES_EXONS=$(find ${GENOME_PATH} -maxdepth 1 -name "ensembl.${ENSEMBL_VERSION}.*.UCSCseqnames.reducedExons.RDS")
FEATURES_RMSK=$(find $GENOME_PATH -maxdepth 1 -name "rmsk*clean.fa.out.gz")
FEATURES_MIRBASE=$(find $GENOME_PATH -maxdepth 1 -name "miRBase.*.gff3")
FEATURES_GENEINFO=${FEATURES_EXONS/reducedExons.RDS/geneInfo.csv}

# paths for tracks
HEX_PATH=~/public_html/Svoboda/bw_tracks/${HEX_OUT}
LOBSANG_PATH=${PWD/common/common-lobsang}
