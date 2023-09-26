#!/bin/bash
#PBS -P ob80
#PBS -l walltime=00:30:00
#PBS -l ncpus=2
#PBS -l mem=50GB
#PBS -N single_ppi
#PBS -l storage=scratch/ob80+gdata/ob80+gdata/if89
#PBS -q normal

hhblits -i $1 -d $2 -E 0.001 -all -oa3m $3/$4'.a3m'
