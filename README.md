Variant Calling Pipeline README

This repository contains a variant calling pipeline script designed to process sequencing data and identify genetic variants. The pipeline consists of several steps, each aimed at preparing, aligning, and analyzing the sequencing reads.
Pipeline Overview

The pipeline includes the following steps:

    Quality Control (QC) with FastQC and MultiQC:
        Reads are assessed for quality using FastQC.
        MultiQC is used to aggregate FastQC reports for easier analysis.

    Trimming with Fastp:
        Input FASTQ files are trimmed using Fastp to remove adapter sequences and low-quality bases.
        Trimmed reads are outputted for downstream analysis.

    Alignment with BWA:
        The BWA aligner is used to map trimmed FASTQ files to a reference genome.
        Aligned reads are outputted in SAM format.

    BAM Processing with Samtools:
        SAM files are converted to sorted BAM files.
        Duplicates are marked and removed from the sorted BAM files using Samtools and Sambamba, respectively.

    Variant Calling with FreeBayes:
        Variants are called from the cleaned BAM files using the FreeBayes variant caller.
        Variant calls are outputted in VCF format.

File Structure

    pipeline.sh: The main script containing the variant calling pipeline.
    README.md: This file, providing an overview of the pipeline and instructions for use.

Dependencies
Ensure that the following dependencies are installed and available in your system:

    FastQC
    MultiQC
    Fastp
    BWA
    Samtools
    Sambamba
    FreeBayes

Additionally, a Conda environment file named ngs.yml is provided within this repository. This YAML file specifies the required dependencies and their versions for executing the variant calling pipeline. To ensure compatibility and reproducibility, it's recommended to create a Conda environment based on this file before executing the pipeline.
