#!/bin/bash
#SBATCH --job-name=speed_ppi
#SBATCH -t 00:10:00 #Set at 10 minutes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH -o slurm-%j.out
#SBATCH -e slurm-%j.err
#SBATCH --array=1-5 #N is the number of total protein
#SBATCH --partition=general
#SBATCH --mem-per-cpu=50G #Memory in Mb per CPU

# to run
#sbatch hhblits_parallel.sh IDS OUTDIR FASTADIR HHBLITS UNICLUST


#This checks if an offset is provided - useful if more than
#the max amount of allowed jobs is used (0 if not provided)
if [ -z $1 ]
then
        offset=0
else
        offset=$5
fi
LN=$(($SLURM_ARRAY_TASK_ID+$offset))
IDS=$1 #"path to ids"
#Get ID
ID=$(sed -n $LN'p' $IDS)
echo $ID
echo $LN
echo $(sed -n $LN'p' $IDS)
#Fasta with sequences to use for the PPI network
OUTDIR=$2 #"path to output"
MSADIR=$OUTDIR/msas/
mkdir $MSADIR
FASTADIR=$3 #"path to individual fasta seqs created in step 1"
FASTA=$FASTADIR/$ID'.fasta'
UNICLUST=$4 #"path to Uniclust30, ../../data/uniclust30/uniclust30_2018_08 according to setup"


# Run HHblits to create MSA
echo $ID
if [ -f "$MSADIR/$ID.a3m" ]; then
  echo $MSADIR/$ID.a3m exists
else
  echo Creating MSA for $ID
  echo hhblits -i $FASTA -d $UNICLUST -E 0.001 -all -oa3m $MSADIR/$ID'.a3m'
  hhblits -i $FASTA -d $UNICLUST -E 0.001 -all -oa3m $MSADIR/$ID'.a3m'
fi
