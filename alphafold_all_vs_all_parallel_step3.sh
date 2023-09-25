#!/bin/bash
#SBATCH --job-name=alphafold
#SBATCH -t 08:00:00 #Set at 10 minutes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH -o slurm-%j.out
#SBATCH -e slurm-%j.err
#SBATCH --array=1-5 #N is the number of total protein
#SBATCH --partition=gpu
#SBATCH --mem-per-cpu=50G #Memory in Mb per CPU
#SBATCH --gpus=1


#Load the necessary modules (e.g. python)
module load cuda11.2/toolkit


# command to run is
# sbatch alphafold_all_vs_all_parallel_step3.sh  IDS OUTDIR FASTADIR DATADIR(Alphafold weights) OFFSET

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
#Fasta with sequences to use for the PPI network
OUTDIR=$2 #"path to output"
MSADIR=$OUTDIR/msas/
mkdir $MSADIR
FASTADIR=$3 #"path to individual fasta seqs created in step 1"

# Predict the structure using a modified version of AlphaFold2 (FoldDock)
# The predictions continue where they left off if the run is timed out
PR_CSV=$FASTADIR/id_seqs.csv
DATADIR=$4 #"Path to where the AlphaFold2 parameteres are stored, default ../../data/"
RECYCLES=10
PDOCKQ_T=0.5
NUM_CPUS=2

mkdir $OUTDIR'/pred'$LN'/'
echo Running pred $c out of $NUM_PREDS
echo 
python3 /home/grig0076/GitHubs/SpeedPPI/src/run_alphafold_all_vs_all.py --protein_csv $PR_CSV \
--target_row $LN \
--msa_dir $MSADIR \
--data_dir $DATADIR \
--max_recycles $RECYCLES \
--pdockq_t $PDOCKQ_T \
--num_cpus $NUM_CPUS \
--output_dir $OUTDIR'/pred'$LN'/'

