reads=~/Desktop/practice/
multiqc_output=~/Desktop/practice/qc
trimming=~/Desktop/practice/fastp_output/
index=~/Desktop/practice/ref_genome
align=~/Desktop/practice/align

if false
then
fastqc -t 2 $reads/*.gz -o ${reads}

multiqc -p $reads/*.html . -o ${multiqc_output}



# Loop over input FASTQ files and run fastp on each pair
for read_file in $reads/*.gz
do
	# Extract sample name
	sample=$(basename $read_file | cut -d '_' -f1)
    
	# Run fastp
 	fastp -w 5 -a AGATCGGAAGAGC -i "${reads}/${sample}_1_subset.fastq.gz" -I "${reads}/${sample}_2_subset.fastq.gz" \
 	-o "${trimming}/${sample}_trimmed_r1.fastq.gz" -O "${trimming}/${sample}_trimmed_r2.fastq.gz" \
 	--html "${trimming}/${sample}_fastp.html" --json "${trimming}/${sample}_fastp.json"     
done

bwa index $index/*.fna ${index}



# Run BWA alignment for trimmed FASTQ files
for trimmed_file in $trimming/*.gz
do

	sample=$(basename $trimmed_file | cut -d '_' -f1)
        
        # Run BWA alignment
        bwa mem -t 4 -R "@RG\tID:${sample}\tSM:${sample}" ${index}/*.fna ${trimmed_file} > "${align}/${sample}_aligned.sam"
done

# Convert SAM files to sorted BAM files and mark duplicates
for sam_file in ${align}/*.sam
do
	.	
       	# Extract sample name from the SAM file name
        sample=$(basename $sam_file | cut -d '_' -f1)

        # Convert SAM file to sorted BAM
        samtools view -@ 1 -b $sam_file | samtools sort -@ 1 -o "${align}/${sample}_sorted.bam"

        # Mark duplicates using sambamba
        sambamba markdup -r -t 5 "${align}/${sample}_sorted.bam" "${align}/${sample}_rmdup.bam"
done

# Call variants using freebayes
for rmdup_bam_file in ${align}/*_rmdup.bam
do
	# Extract sample name from the BAM file name
        sample=$(basename $rmdup_bam_file | cut -d '_' -f1)

        # Call variants using freebayes
        freebayes -f ${index}/*.fna -p 1 $rmdup_bam_file > "${align}/${sample}_variants.vcf"
done

fi















