# Package index

## Google Sheets

Functions to read cohort tables from Google Sheets.

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
- [`read_sheet()`](https://caravagnalab.github.io/SCOUT/reference/read_sheet.md)
  : Read a public Google Sheet and return a tibble

## Zenodo — download

Functions to download and cache per-SPN archives from Zenodo.

- [`get_ground_truth()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth.md)
  : Get ground truth simulation data for a SCOUT SPN
- [`get_sarek_results()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_results.md)
  : Get the local path to Sarek results for a SCOUT SPN
- [`get_tumourevo_results()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_results.md)
  : Get the local path to tumourevo results for a SCOUT SPN
- [`list_zenodo_files()`](https://caravagnalab.github.io/SCOUT/reference/list_zenodo_files.md)
  : List files available in a Zenodo record

## Ground truth getters

Access simulation ground truth data (mutations, CNA, forests).

- [`get_mutations()`](https://caravagnalab.github.io/SCOUT/reference/get_mutations.md)
  : Get mutations from SCOUT ground truth
- [`get_sample_names()`](https://caravagnalab.github.io/SCOUT/reference/get_sample_names.md)
  : Get sample names for a SCOUT SPN
- [`get_gender()`](https://caravagnalab.github.io/SCOUT/reference/get_gender.md)
  : Get subject gender for a SCOUT SPN
- [`get_tumour_type()`](https://caravagnalab.github.io/SCOUT/reference/get_tumour_type.md)
  : Get tumour type for a SCOUT SPN

## Sarek getters

Access Sarek pipeline results (VCF and CNA files).

- [`get_sarek_vcf()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_vcf.md)
  : Get Sarek VCF output files for a SCOUT SPN
- [`get_sarek_cna()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_cna.md)
  : Get Sarek CNA output files for a SCOUT SPN

## tumourevo getters

Access tumourevo pipeline results by tool and analysis type.

- [`get_tumourevo_driver()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_driver.md)
  : Get tumourevo driver annotation paths
- [`get_tumourevo_subclonal()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_subclonal.md)
  : Get tumourevo subclonal deconvolution result paths
- [`get_tumourevo_qc()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_qc.md)
  : Get tumourevo QC result paths
- [`get_tumourevo_signatures()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_signatures.md)
  : Get tumourevo signature deconvolution result paths
