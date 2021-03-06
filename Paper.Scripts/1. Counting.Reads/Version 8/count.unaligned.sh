#!/bin/bash -l

#SBATCH --job-name=unalign.count
#SBATCH --time=30:0:0
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH --mem=10GB
#SBATCH --ntasks-per-node=8
#SBATCH --out=counts.unalign.out

declare INROOT=/work-zfs/darking1/resources/GTEx/ncbi/version8.wgs/
declare SRR_LIST=$INROOT/full.cramlist.lst

readarray -t myArray <$SRR_LIST

i=1
increment=1
# lim=50
# while [ $i -lt 10 ];
while [ $i -lt ${#myArray[@]} ];
# while [ $i -lt $lim ];
do
ml samtools
declare "cramfile"="${myArray[${i}]}"
declare sampid=$(echo $cramfile | cut --delimiter "/" --fields 5)
declare sampid_only=$(echo $sampid | cut --delimiter "." --fields 1)

count=$(samtools view -c /work-zfs/darking1/resources/GTEx/ncbi/version8.wgs/complete.crams/unaligned/${sampid_only}.unaligned.cram)
echo "${count},${sampid_only}" >> read.info/unaligned_reads.csv
i=$[$i+$increment]
done

# sbatch --array=1-452%20 count.mito.sh

