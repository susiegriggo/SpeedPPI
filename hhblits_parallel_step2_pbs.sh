#!/bin/bash
#PBS -l walltime=00:10:00
#PBS -P ob80
#PBS -l other=hyperthread
#PBS -l ncpus=1
#PBS -l mem=8GB
#PBS -N speed_ppi
#PBS -l storage=scratch/ob80+gdata/ob80+gdata/if89
#PBS -q normal

# to run
# qsub -v IDS=IDS,OUTDIR=OUTDIR,FASTADIR=FASTADIR,UNICLUST=UNICLUST hhblits_parallel.sh

# make directory for MSAs 
MSADIR=$OUTDIR/msas/
        mkdir -p $MSADIR

# see if can access the ids file at atll 
cat $IDS 
# loop through the sequences 
for ID in `cat $IDS`; do
	
	echo $ID

	#Fasta with sequences to use for the PPI network
	FASTA=$FASTADIR/$ID'.fasta'

	# Run HHblits to create MSA
	if [ -f "$MSADIR/$ID.a3m" ]; then
		    echo $MSADIR/$ID.a3m exists
	    else
		        echo Creating MSA for $ID
			    echo hhblits -i $FASTA -d $UNICLUST -E 0.001 -all -oa3m $MSADIR/$ID'.a3m'
			        #hhblits -i $FASTA -d $UNICLUST -E 0.001 -all -oa3m $MSADIR/$ID'.a3m'
				qsub -v FASTA=$FASTA,UNICLUST=$UNICLUST,MSA=$MSADIR,ID=$ID /home/584/sg5247/GitHubs/SpeedPPI/hhblits_single_step2_pbs.sh 
			fi
done 
