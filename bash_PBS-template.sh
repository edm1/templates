#!/bin/sh
#PBS -l nodes=1:ppn=16
#PBS -l walltime=00:00:10:00
#PBS -N n-template
#PBS -t 1-22
#PBS -m abe
#PBS -M edward.mountjoy@bristol.ac.uk
#PBS -q testq

# Start interactive: qsub -l walltime=00:08:00:00,nodes=1:ppn=1 -d $PWD -I
# Start interactive: qsub -l walltime=00:01:00:00,nodes=1:ppn=16 -q testq -d $PWD -I

#qsub -W depend=afteranyarray:arrayid[] <script>

# Change to work dir if set
if [ ! -z ${PBS_O_WORKDIR+x} ]; then
	cd $PBS_O_WORKDIR
fi

# Pad chrom num
chrom=$PBS_ARRAYID
chrom_padd=$(printf "%0*d\n" 2 $chrom)

# Run commands
for i in {1..6}; do

	cmd="command $i"
	echo $cmd

done | parallel -j 16 #--sshloginfile $PBS_NODEFILE --sshdelay 1
