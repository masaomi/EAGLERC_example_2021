#!/bin/bash

bwa
# Version: 0.7.17-r1188

samtools --version
# samtools 1.11

eagle-rc --version
# EAGLE-RC 1.1.1

mkdir -p bwa_out
bwa index references/Ahal_v2_2_1_hscaffold_6.fa 
bwa index references/Alyr_v2_2_1_lscaffold_6.fa 
bwa index references/Akam_v2_2_1_scaffold_6.fa 

bwa mem -t 8 references/Ahal_v2_2_1_hscaffold_6.fa data/hal_s6_PE150_10x_0_R1.fastq.gz 2> bwa_out/hal_s6_on_hal.log | samtools view -S -b - > bwa_out/hal_s6_on_hal.bam
bwa mem -t 8 references/Alyr_v2_2_1_lscaffold_6.fa data/lyr_s6_PE150_10x_0_R1.fastq.gz 2> bwa_out/lyr_s6_on_lyr.log | samtools view -S -b - > bwa_out/lyr_s6_on_lyr.bam
bwa mem -t 8 references/Akam_v2_2_1_scaffold_6.fa data/kam_s6_PE150_10x_0_R1.fastq.gz 2> bwa_out/kam_s6_on_kam.log | samtools view -S -b - > bwa_out/kam_s6_on_kam.bam

samtools sort bwa_out/hal_s6_on_hal.bam -o bwa_out/hal_s6_on_hal.sorted.bam
samtools sort bwa_out/lyr_s6_on_lyr.bam -o bwa_out/lyr_s6_on_lyr.sorted.bam
samtools sort bwa_out/kam_s6_on_kam.bam -o bwa_out/kam_s6_on_kam.sorted.bam

mkdir -p classify_out
eagle-rc --ngi --ref1=references/Ahal_v2_2_1_hscaffold_6.fa --ref2=references/Alyr_v2_2_1_lscaffold_6.fa --bam1=bwa_out/kam_s6_on_hal.sorted.bam --bam2=bwa_out/kam_s6_on_lyr.sorted.bam -o classify_out/kam_s6.eaglerc > classify_out/kam_s6.eaglerc.stdout.log 2> classify_out/kam.eaglerc.errout.log

samtools view -F 260 bwa_out/hal_s6_on_hal.sorted.bam | wc -l
# 67084
samtools view -F 260 bwa_out/lyr_s6_on_lyr.sorted.bam | wc -l
# 99170
samtools view -F 260 bwa_out/kam_s6_on_kam.sorted.bam | wc -l
# 166254
samtools view -F 260 bwa_out/lyr_s6_on_lyr.sorted.bam | ruby -ne 'x=$_.split.map{|x| x.split("-").first}; p $_ if x[0]!=x[2]' | wc -l
# 0

samtools view -F 260 bwa_out/hal_s6_on_hal.sorted.bam | ruby -ne 'x=$_.split.map{|x| x.split("-").first}; p $_ if x[0]!=x[2]' | wc -l
# 0
samtools view -F 260 bwa_out/kam_s6_on_kam.sorted.bam | ruby -ne 'x=$_.split.map{|x| x.split("-").first}; p $_ if x[0]!=x[2]' | wc -l
# 1657

samtools view -F 260 classify_out/kam_s6.eaglerc2.ref.bam | wc -l
# 97197
samtools view -F 260 classify_out/kam_s6.eaglerc2.alt.bam | wc -l
# 47419
samtools view -F 260 classify_out/kam_s6.eaglerc2.unk.bam | wc -l
# 4499

samtools view -F 260 classify_out/kam_s6.eaglerc1.ref.bam | wc -l
# 65168
samtools view -F 260 classify_out/kam_s6.eaglerc1.alt.bam | wc -l
# 48019
samtools view -F 260 classify_out/kam_s6.eaglerc1.unk.bam | wc -l
# 4496

samtools view -F 260 classify_out/kam_s6.eaglerc1.ref.bam | ruby -ne 'x=$_.split.map{|x| x.split("-").first}; p $_ if x[0]!=x[2]' | wc -l
# 226
samtools view -F 260 classify_out/kam_s6.eaglerc2.ref.bam | ruby -ne 'x=$_.split.map{|x| x.split("-").first}; p $_ if x[0]!=x[2]' | wc -l
# 241


