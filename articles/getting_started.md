# Getting started with SCOUT

The `SCOUT` package gives you direct access to the Simulated Cohort of
Universal Tumours from R.

| Source | What is stored there | Key functions |
|----|----|----|
| **Tables** | Cohort metadata, ground truth tables | [`get_metadata()`](https://caravagnalab.github.io/SCOUT/reference/get_metadata.md), [`get_ground_truth_cna()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_cna.md), [`get_ground_truth_drivers()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_drivers.md), [`get_ground_truth_exposures()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_exposures.md), [`get_sampling_information()`](https://caravagnalab.github.io/SCOUT/reference/get_sampling_information.md) |
| **Zenodo** | Sequencing RDS files, normal and tumour sarek results, tumourevo results | [`get_sequencing_data()`](https://caravagnalab.github.io/SCOUT/reference/get_sequencing_data.md), [`get_normal_data()`](https://caravagnalab.github.io/SCOUT/reference/get_normal_data.md), [`get_sarek_results()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_results.md), [`get_tumourevo_results()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_results.md) |
| **ENA** (PRJEB97253) | Raw paired-end FASTQ files — 144 tumour + 14 normal (200× per sample, subsamplable to 50×/100×/150×) | — see **Raw FASTQ data** article |

## Installation

``` r

devtools::install_github("caravagnalab/SCOUT")
library(SCOUT)
```

------------------------------------------------------------------------

## Tables

Cohort metadata and ground truth tables are stored as public Google
Sheets.

| Function | Description |
|----|----|
| [`get_metadata()`](https://caravagnalab.github.io/SCOUT/reference/get_metadata.md) | Sample-level annotations (tumour type, clonal class, WGD, sex, …) |
| [`get_ground_truth_cna()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_cna.md) | Ground truth copy number segments |
| [`get_ground_truth_drivers()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_drivers.md) | Ground truth driver events (SNVs, CNAs, WGD) |
| [`get_ground_truth_exposures()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_exposures.md) | Ground truth mutational signature exposures |
| [`get_sampling_information()`](https://caravagnalab.github.io/SCOUT/reference/get_sampling_information.md) | Per-sample clone proportions and sampling time |
| [`get_sample_names()`](https://caravagnalab.github.io/SCOUT/reference/get_sample_names.md) | Sample names for a given SPN |
| [`get_tumour_type()`](https://caravagnalab.github.io/SCOUT/reference/get_tumour_type.md) | Tumour type for a given SPN |
| [`get_gender()`](https://caravagnalab.github.io/SCOUT/reference/get_gender.md) | Sex chromosome for a given SPN |

All table functions accept optional `spn` and `sample` arguments:

``` r

get_metadata()
get_ground_truth_cna("SPN01")
get_ground_truth_cna("SPN01", sample = "1.1")
get_ground_truth_drivers("SPN01")
get_ground_truth_exposures("SPN01", type = "SBS")
get_sampling_information("SPN01")

get_sample_names("SPN01")
get_tumour_type("SPN01")
get_gender("SPN01")
```

See the **Tables** article for the full column-level reference.

------------------------------------------------------------------------

## Zenodo

Data on Zenodo are organised as follows:

| Data type | Content |
|----|----|
| Sequencing ground truth | One record per SPN — `SPN0X_sequencing.tar.gz` |
| Normal sarek outputs | One shared record — `SPN0X_normal.tar.gz` per SPN |
| Sarek + tumourevo (SPN01–06) | One record per SPN per purity (`0.9`, `0.6`, `0.3`) |
| SPN07 sarek | One record per purity |
| SPN07 tumourevo | One record for purity 0.9 + 0.6, one for 0.3 |

For the full list of record IDs see the **Zenodo** article.

Files are downloaded once and cached at `~/.cache/SCOUT/<spn>/`.
Override the cache root with `SCOUT_CACHE_DIR`:

``` r

Sys.setenv(SCOUT_CACHE_DIR = "/scratch/shared/SCOUT")
```

### Download functions

``` r

# Tumour sequencing ground truth (all purities and coverages)
get_sequencing_data("SPN04")

# Normal sarek VCF outputs
get_normal_data("SPN04")

# Sarek and tumourevo pipeline results for a given purity
get_sarek_results("SPN04", purity = 0.9)
get_tumourevo_results("SPN04", purity = 0.9)
```

### Getter functions

Once downloaded, dedicated getters resolve file paths without manual
directory navigation:

``` r

# Ground truth mutations
get_mutations("SPN04", type = "tumour", coverage = 100, purity = 0.9)
get_mutations("SPN04", type = "normal")

# Sarek VCF and CNA files
get_sarek_vcf("SPN04", "SPN04_1.1", 100, 0.9, "mutect2", "tumour")
get_sarek_cna("SPN04", "SPN04_1.1", 100, 0.9, "ascat")

# tumourevo outputs
get_tumourevo_snv("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")
get_tumourevo_cna("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")
get_tumourevo_driver("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")
get_tumourevo_subclonal("SPN04", 50, 0.6, "mutect2", "sequenza",
                        "mobster", "SPN04_1.1")
get_tumourevo_qc("SPN04", 50, 0.6, "mutect2", "sequenza", "cnaqc", "SPN04_1.1")
get_tumourevo_signatures("SPN04", 50, 0.6, "mutect2", "sequenza", "BASCULE")
```

See the **Zenodo** article for the full function reference.

------------------------------------------------------------------------

## Raw FASTQ data

Raw paired-end FASTQ files are available in the European Nucleotide
Archive under accession **PRJEB97253**. There are 158 files in total:
144 tumour (24 samples × 3 purities × R1+R2) and 14 normal (7 SPNs ×
R1+R2). Each file is 200× coverage, internally organised as 40 bins of
5× each.

Use
[`list_ena_files()`](https://caravagnalab.github.io/SCOUT/reference/list_ena_files.md)
to inspect available files and
[`get_fastq()`](https://caravagnalab.github.io/SCOUT/reference/get_fastq.md)
to download them:

``` r

# List all tumour files for SPN01 at purity 0.9
list_ena_files("SPN01", purity = "0.9")

# Download R1 + R2 for SPN01 sample 1.1, purity 0.9
paths <- get_fastq("SPN01", sample = "1.1", purity = "0.9")
paths$R1
paths$R2
```

Standard coverage levels can be reproduced by subsetting consecutive
bins with SeqKit:

| Coverage | Bins        |
|----------|-------------|
| 50×      | `t00`–`t09` |
| 100×     | `t00`–`t19` |
| 150×     | `t00`–`t29` |

See the **Raw FASTQ data** article for full download and subsampling
commands.

------------------------------------------------------------------------
