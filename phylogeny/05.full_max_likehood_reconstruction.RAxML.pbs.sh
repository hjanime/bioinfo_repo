#!/bin/bash
# ----------------QSUB Parameters----------------- #
#PBS -q MASTER
#PBS -M fihorvat@gmail.com
#PBS -m n
#PBS -N pbs.05.full_max_likehood_reconstruction.RAxML
#PBS -l select=ncpus=6:mem=1g
#PBS -J 0-7
#PBS -j oe
cd $PBS_O_WORKDIR

# ----------------Loading variables------------------- #
# input 
INPUT_DIR=.
IN_SEQ=($(find $INPUT_DIR -maxdepth 1 \( -name "*.fasta" -or -name "*.fasta-gb" \)))
FILE=${IN_SEQ[$PBS_ARRAY_INDEX]}
FILE_TREE=${FILE}.tree
FILE_MODEL=${FILE}.AIC.best_fit.txt

BASE=${FILE#${INPUT_DIR}/}
BASE=${BASE}

# script to run
SCRIPT=/common/WORK/fhorvat/programi/RAxML/standard-RAxML/raxmlHPC-PTHREADS-SSE3

# ----------------Commands------------------- #
### get best-fit models of protein evolution from prottest3
# result: 
# "^[A-Z]+(?=\\+)" is amino acid replacement matrix (one of the JTT, LG, DCMut, MtREV, MtMam, MtArt, Dayhoff, WAG, RtREV, CpREV, Blosum62, VT, HIVb, HIVw, FLU)
# +I models with a proportion of invariable sites
# +G models with rate variation among sites and number of categories
# +F models with empirical frequency estimation
MODEL=$(grep "Best model according to AIC:" ${FILE_MODEL} | sed 's/^Best model according to AIC: //')

### get final model of protein substitution parameter for RAxML
# Available AA substitution models: 
# DAYHOFF, DCMUT, JTT, MTREV, WAG, RTREV, CPREV, VT, BLOSUM62, MTMAM, LG,  
# MTART, MTZOA, PMB, HIVB, HIVW, JTTDCMUT, FLU, STMTREV, DUMMY, DUMMY2, AUTO, 
# LG4M, LG4X, PROT_FILE, GTR_UNLINKED, GTR 
# With the optional "F" appendix you can specify if you want to use empirical base frequencies.

# get AA matrix - get uppercase model and remove everything after first "+"
AA_MATRIX=$(echo ${MODEL^^} | sed 's/+.*//')

# paste together
AA_SUB=$(echo "PROTGAMMA""I"${AA_MATRIX})

# initial RAxML tree search
# start from the FastTree ML tree
${SCRIPT} -T 6 -f T -p 12467 -m ${AA_SUB} -t ${FILE}.tree -s ${FILE} -n ${BASE}.raxml

# calculate SH-like support under RAxML; #
# this will optimize the tree by NNI     #
${SCRIPT} -T 6 -f J -p 12467 -m ${AA_SUB} -t RAxML_bestTree.${BASE}.raxml -s ${FILE} -n ${BASE}.shsupport

### arguments
# -T = Run on N threads
# -f = Select algorithm
	# The -f option is a very powerful option because, in many cases, it allows you to select what 
	# kind of algorithm RAxML shall execute
	# T option = allows to do a more thorough tree search that uses less lazy, i.e., more  
		# exhaustive SPR moves, in stand-alone mode. This algorithm is typically executed in the  
		# very end  of a search done via ­f a.
	# J option = compute SH­like support values on a given tree passed via ­t. 
		# This option will compute sh-like support values as described here  
		# http://www.ncbi.nlm.nih.gov/pubmed/20525638 on a given tree. The input tree is typically 
		# the best-known ML tree found by a RAxML analysis. Keep in mind that for applying the SH-
		# like test the tree needs to be NNI (Nearest Neighbor Interchange) optimal. Thus, RAxML will 
		# initially try to apply NNI moves to further improve the tree and then compute the SH test 
		# for each inner branch of the tree.
# -p = Random number seed 
	# This allows you to reproduce your results and will help me debug the program. 
	# For all options/algorithms  in RAxML  that require some  sort of randomization,  this option  
	# must be specified.
# -m = Model of Binary (Morphological), Nucleotide, Multi­State, or Amino Acid Substitution
	# input from prottest3
# -t = Specify a user starting tree file name in Newick format
# -s = Specify the name of the alignment data file in PHYLIP or FASTA format
# -n = Specifies the name of the output file
