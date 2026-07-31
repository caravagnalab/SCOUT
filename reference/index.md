# Package index

## Tables

Functions to read cohort annotation tables.

- [`get_metadata()`](https://caravagnalab.github.io/SCOUT/reference/get_metadata.md)
  : Get SCOUT sample metadata
- [`get_ground_truth_cna()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_cna.md)
  : Get SCOUT ground truth CNA data
- [`get_ground_truth_drivers()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_drivers.md)
  : Get SCOUT ground truth driver events
- [`get_ground_truth_exposures()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_exposures.md)
  : Get SCOUT ground truth mutational signature exposures
- [`get_sampling_information()`](https://caravagnalab.github.io/SCOUT/reference/get_sampling_information.md)
  : Get SCOUT sampling information
- [`get_sample_names()`](https://caravagnalab.github.io/SCOUT/reference/get_sample_names.md)
  : Get sample names for a SCOUT SPN
- [`get_tumour_type()`](https://caravagnalab.github.io/SCOUT/reference/get_tumour_type.md)
  : Get tumour type for a SCOUT SPN
- [`get_gender()`](https://caravagnalab.github.io/SCOUT/reference/get_gender.md)
  : Get subject gender for a SCOUT SPN
- [`read_sheet()`](https://caravagnalab.github.io/SCOUT/reference/read_sheet.md)
  : Read a public Google Sheet and return a tibble

## Zenodo — download

Functions to download and cache per-SPN archives from Zenodo.

- [`get_sequencing_data()`](https://caravagnalab.github.io/SCOUT/reference/get_sequencing_data.md)
  : Download SCOUT sequencing ground truth for a SPN
- [`get_normal_data()`](https://caravagnalab.github.io/SCOUT/reference/get_normal_data.md)
  : Download SCOUT normal sarek results for a SPN
- [`get_sarek_results()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_results.md)
  : Get the local path to Sarek results for a SCOUT SPN
- [`get_tumourevo_results()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_results.md)
  : Get the local path to tumourevo results for a SCOUT SPN
- [`list_zenodo_files()`](https://caravagnalab.github.io/SCOUT/reference/list_zenodo_files.md)
  : List files available in a Zenodo record

## ENA — raw FASTQ

Functions to list and download raw FASTQ files from ENA (PRJEB97253).

- [`list_ena_files()`](https://caravagnalab.github.io/SCOUT/reference/list_ena_files.md)
  : List FASTQ files available for a SCOUT SPN on ENA
- [`get_fastq()`](https://caravagnalab.github.io/SCOUT/reference/get_fastq.md)
  : Download raw FASTQ files for a SCOUT SPN from ENA

## Ground truth getters

Access sequencing ground truth mutation data.

- [`get_mutations()`](https://caravagnalab.github.io/SCOUT/reference/get_mutations.md)
  : Get mutations from SCOUT ground truth

## Sarek getters

Access Sarek pipeline results. VCF callers: mutect2, strelka, freebayes,
haplotypecaller. CNA callers: ascat, battenberg, sequenza, cnvkit.

- [`get_sarek_vcf()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_vcf.md)
  : Get Sarek VCF output files for a SCOUT SPN
- [`get_sarek_cna()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_cna.md)
  : Get Sarek CNA output files for a SCOUT SPN

## tumourevo getters

Access tumourevo pipeline results by tool and analysis type.

- [`get_tumourevo_snv()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_snv.md)
  : Get tumourevo formatted SNV (vcf2cnaqc) file paths
- [`get_tumourevo_cna()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_cna.md)
  : Get tumourevo formatted CNA (cna2cnaqc) file paths
- [`get_tumourevo_joint_table()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_joint_table.md)
  : Get tumourevo joint CNAqc table (cnaqc2tsv)
- [`get_tumourevo_vep()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_vep.md)
  : Get tumourevo VEP annotated VCF file paths
- [`get_tumourevo_driver()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_driver.md)
  : Get tumourevo driver annotation file paths
- [`get_tumourevo_subclonal()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_subclonal.md)
  : Get tumourevo subclonal deconvolution result paths
- [`get_tumourevo_qc()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_qc.md)
  : Get tumourevo QC result paths
- [`get_tumourevo_signatures()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_signatures.md)
  : Get tumourevo signature deconvolution result paths
