#Create a PPI network

#ARGS
#INPUT
FASTA_SEQS=$1 #All fasta seqs
HHBLITS=$2 #Path to HHblits
PDOCKQ_T=$3
OUTDIR=$4
#DEFAULT
UNICLUST=./data/uniclust30_2018_08/uniclust30_2018_08 #Assume path according to setup


#The pipeline starts here
#1. Create individual fastas
FASTADIR=$OUTDIR/fasta/
if [ -f "$FASTADIR/id_seqs.csv" ]; then
  echo Fastas exist...
  echo "Remove the directory $FASTADIR if you want to write new fastas."
else
mkdir -p $FASTADIR
python3 ./src/preprocess_fasta.py --fasta_file $FASTA_SEQS \
--outdir $FASTADIR
echo "Writing fastas of each sequence to $FASTADIR"
fi
wait

echo "FINISHED"
