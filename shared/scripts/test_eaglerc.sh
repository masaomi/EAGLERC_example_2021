#!/bin/bash
# 20210726 masaomi.hatakeyama@gmail.com
# EAGLE-RC test script

# make simulated sample data
echo "Generating simulated data..."
ruby scripts/art_illumina_sim references/Ahal_v2_2_1_hscaffold_6.fa -r 1 -d data -o hal_s6 > scripts/art_illumina_sim_ahal_s6.sh
ruby scripts/art_illumina_sim references/Alyr_v2_2_1_lscaffold_6.fa -r 1 -d data -o lyr_s6 > scripts/art_illumina_sim_alyr_s6.sh
sh scripts/art_illumina_sim_ahal_s6.sh 
sh scripts/art_illumina_sim_alyr_s6.sh 

zcat data/hal_s6_PE150_10x_0_R1.fastq.gz data/lyr_s6_PE150_10x_0_R1.fastq.gz | gzip > data/kam_s6_PE150_10x_0_R1.fastq.gz
zcat data/hal_s6_PE150_10x_0_R1.fastq.gz data/lyr_s6_PE150_10x_0_R1.fastq.gz | gzip > data/kam_s6_PE150_10x_0_R1.fastq.gz

# bwa mapping
echo "Executing BWA alignment..."
mkdir -p bwa_out
bwa index references/Ahal_v2_2_1_hscaffold_6.fa 
bwa index references/Alyr_v2_2_1_lscaffold_6.fa 
bwa index references/Akam_v2_2_1_scaffold_6.fa 

bwa mem -t 8 references/Ahal_v2_2_1_hscaffold_6.fa data/hal_s6_PE150_10x_0_R1.fastq.gz 2> bwa_out/hal_s6_on_hal.log | samtools view -S -b - > bwa_out/hal_s6_on_hal.bam
bwa mem -t 8 references/Alyr_v2_2_1_lscaffold_6.fa data/lyr_s6_PE150_10x_0_R1.fastq.gz 2> bwa_out/lyr_s6_on_lyr.log | samtools view -S -b - > bwa_out/lyr_s6_on_lyr.bam
bwa mem -t 8 references/Akam_v2_2_1_scaffold_6.fa data/kam_s6_PE150_10x_0_R1.fastq.gz 2> bwa_out/kam_s6_on_kam.log | samtools view -S -b - > bwa_out/kam_s6_on_kam.bam
bwa mem -t 8 references/Ahal_v2_2_1_hscaffold_6.fa data/kam_s6_PE150_10x_0_R1.fastq.gz 2> bwa_out/kam_s6_on_hal.log | samtools view -S -b - > bwa_out/kam_s6_on_hal.bam
bwa mem -t 8 references/Alyr_v2_2_1_lscaffold_6.fa data/kam_s6_PE150_10x_0_R1.fastq.gz 2> bwa_out/kam_s6_on_lyr.log | samtools view -S -b - > bwa_out/kam_s6_on_lyr.bam

samtools sort bwa_out/hal_s6_on_hal.bam -o bwa_out/hal_s6_on_hal.sorted.bam
samtools sort bwa_out/lyr_s6_on_lyr.bam -o bwa_out/lyr_s6_on_lyr.sorted.bam
samtools sort bwa_out/kam_s6_on_kam.bam -o bwa_out/kam_s6_on_kam.sorted.bam
samtools sort bwa_out/kam_s6_on_hal.bam -o bwa_out/kam_s6_on_hal.sorted.bam
samtools sort bwa_out/kam_s6_on_lyr.bam -o bwa_out/kam_s6_on_lyr.sorted.bam

# EAGLE-RC read classification
echo "Executing EAGLE-RC..."
mkdir -p classify_out
eagle-rc --ngi --ref1=references/Ahal_v2_2_1_hscaffold_6.fa --ref2=references/Alyr_v2_2_1_lscaffold_6.fa --bam1=bwa_out/kam_s6_on_hal.sorted.bam --bam2=bwa_out/kam_s6_on_lyr.sorted.bam -o classify_out/kam_s6.eaglerc > classify_out/kam_s6.eaglerc.stdout.log 2> classify_out/kam.eaglerc.errout.log

echo
echo "Done"
echo
echo "Without EAGLE-RC (direct alignment)"
echo "#Ahal reads mapped to Ahal reference: `samtools view -F 260 bwa_out/hal_s6_on_hal.sorted.bam | wc -l`"
# 67111, the number of mapped reads can slightly change depending on ART sample data
echo "#Alyr reads mapped to Alyr reference: `samtools view -F 260 bwa_out/lyr_s6_on_lyr.sorted.bam | wc -l`"
# 99299
echo "#Akam reads mapped to Akam reference: `samtools view -F 260 bwa_out/kam_s6_on_kam.sorted.bam | wc -l`"
# 166410
echo "#Mis-mapped reads of Akam reads to Akam reference: `samtools view -F 260 bwa_out/kam_s6_on_kam.sorted.bam | ruby -ne 'x=$_.split.map{|x| x.split("-").first}; p $_ if x[0]!=x[2]' | wc -l`"
# 1682

echo
echo "By EAGLE-RC (read classification)"
echo "#Akam reads mapped to Ahal reference after EAGLE-RC: `samtools view -F 260 classify_out/kam_s6.eaglerc1.ref.bam | wc -l`"
# 65142
echo "#Akam reads mapped to Alyr reference after EAGLE-RC: `samtools view -F 260 classify_out/kam_s6.eaglerc2.ref.bam | wc -l`"
# 97300
echo "#Mis-mapped reads of Akam reads to Ahal reference after EAGLE-RC: `samtools view -F 260 classify_out/kam_s6.eaglerc1.ref.bam | ruby -ne 'x=$_.split.map{|x| x.split("-").first}; p $_ if x[0]!=x[2]' | wc -l`"
# 194
echo "#Mis-mapped reads of Akam reads to Alyr reference after EAGLE-RC: `samtools view -F 260 classify_out/kam_s6.eaglerc2.ref.bam | ruby -ne 'x=$_.split.map{|x| x.split("-").first}; p $_ if x[0]!=x[2]' | wc -l`"
# 206

