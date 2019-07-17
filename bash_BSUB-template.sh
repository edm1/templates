#!/bin/sh
#BSUB -J <jobname>[1-23] # Run array job. Remove [X-Y] for no array.
#BSUB -q <queue> # small=batches of 10; normal=12h max; long=48h max; basement=300 job limit; hugemem=512GB mem
#BSUB -n <cores>
#BSUB -W <walltime in mins>
#BSUB -R "select[mem>8000] rusage[mem=8000] span[hosts=1]" -M8000
#BSUB -o output.%J.%I # %J=jobid; %I=array index
#BSUB -e errorfile.%J.%I
#BSUB -E <script> # Execute this script on host before main script

# Run interactive:   bsub -q normal -J interactive -n 1 -R "select[mem>8000] rusage[mem=8000] span[hosts=1]" -M8000 -Is bash
# Stop job:          bstop <jobid>
# Resume job:        bresume <jobid>
# Kill job:          bkill <jobid>
# Job history:       bhist
# Job info (wide):   bjobs -w (jobid)
# Depend on job:     bsub -w "done(&lt;<jobid>&gt)" -o <outfile> <script>
# Queue info:        bqueues
# Check user quota:  lfs quota -hu em21 /lustre/scratch115
# Check group quota: lfs quota -hg otcoregen /lustre/scratch115
# Check user quota home: quota -vs
# User priority:     bqueues -l -r long | awk -v project="otcoregen"  '$1 ~ /SHARE_INFO/ {h=""} ; {if ( match ($2,project) ) {h=$0 }} ; {if ( h ) {print $0}}'
# Group priority:    bqueues -l -r long | awk -v project="humgenp"  '$1 ~ /SHARE_INFO/ {h=""} ; {if ( match ($2,project) ) {h=$0 }} ; {if ( h ) {print $0}}'

# Load required modules
# module avail                 # List modules
# module load hgi/plink/1.90b4 # Load module
# module load hgi/gsutil/4.28

# Get chromosome names from array index
chrom=$LSB_JOBINDEX
chrom_X=`echo $chrom | sed 's/23/X/'` # Convert 23 to X
# Pad chromosome number with zeros
chrom_padd=$(printf "%0*d\n" 2 $chrom)
chrom_paddX=`echo $chrom_padd | sed 's/23/X/'` # Convert 23 to X

# Run commands using GNU parallel
for i in {1..6}; do
  cmd="command $i"
  echo $cmd
done | parallel -j 16 #--sshloginfile $LSB_DJOB_HOSTFILE --sshdelay 1
