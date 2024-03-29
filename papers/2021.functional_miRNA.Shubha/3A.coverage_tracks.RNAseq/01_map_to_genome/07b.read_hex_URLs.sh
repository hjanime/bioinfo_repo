#/bin/bash
# ----------------Loading variables------------------- #
HEX_PATH=/home/students/fhorvat/public_html/Svoboda/bw_tracks/accessory_data_sets/Graf_2014_ProcNatlAcadSciUSA_GSE52415.bosTau9
TABLE_PATH=http://hex.bioinfo.hr/~fhorvat/${HEX_PATH#~/public_html}/log.tracks_URL.txt

# ----------------Commands------------------- #
# get table from hex
wget $TABLE_PATH

# change permissions
find . -name "*.bw" -exec chmod 744 {} \;
find . -name "*.bam*" -not -name "*genome*" -not -name "*rDNA_45S*" -not -name "*sortedByName*" -exec chmod 744 {} \;
