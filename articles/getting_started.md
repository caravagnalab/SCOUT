# Getting started with SCOUT

The `SCOUT` package gives you direct access to the Simulated Cohort of
Universal Tumours from R. Data live in two places and the package knows
how to talk to both:

| Source | What is stored there | Key functions |
|----|----|----|
| **Tables** | Cohort metadata, ground truth annotation tables | [`get_metadata()`](https://caravagnalab.github.io/SCOUT/reference/get_metadata.md), [`get_ground_truth_cna()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_cna.md), [`get_ground_truth_drivers()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_drivers.md), [`get_ground_truth_exposures()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_exposures.md), [`get_sampling_information()`](https://caravagnalab.github.io/SCOUT/reference/get_sampling_information.md) |
| **Zenodo** | Sequencing RDS files, normal and tumour sarek results, tumourevo results | [`get_sequencing_data()`](https://caravagnalab.github.io/SCOUT/reference/get_sequencing_data.md), [`get_normal_data()`](https://caravagnalab.github.io/SCOUT/reference/get_normal_data.md), [`get_sarek_results()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_results.md), [`get_tumourevo_results()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_results.md) |

## Installation

``` r

devtools::install_github("caravagnalab/SCOUT")
library(SCOUT)
```

------------------------------------------------------------------------

## Tables

Cohort annotation tables are stored as public Google Sheets. All
functions return tibbles directly — no authentication required.

| Function | Description |
|----|----|
| [`get_metadata()`](https://caravagnalab.github.io/SCOUT/reference/get_metadata.md) | Sample-level annotations (tumour type, clonal class, WGD, sex, …) |
| [`get_ground_truth_cna()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_cna.md) | Ground truth copy number segments |
| [`get_ground_truth_drivers()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_drivers.md) | Ground truth driver events (SNVs, CNAs, WGD) |
| [`get_ground_truth_exposures()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_exposures.md) | Ground truth mutational signature exposures |
| [`get_sampling_information()`](https://caravagnalab.github.io/SCOUT/reference/get_sampling_information.md) | Per-sample clone proportions and sampling time |
| [`get_sample_names()`](https://caravagnalab.github.io/SCOUT/reference/get_sample_names.md) | Sample names for a given SPN |
| [`get_tumour_type()`](https://caravagnalab.github.io/SCOUT/reference/get_tumour_type.md) | Tumour type for a given SPN |
| [`get_gender()`](https://caravagnalab.github.io/SCOUT/reference/get_gender.md) | Sex chromosome complement for a given SPN |

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

| Data type | Record structure |
|----|----|
| Sequencing ground truth | One record per SPN — `SPN0X_sequencing.tar.gz` |
| Normal sarek outputs | One shared record — `SPN0X_normal.tar.gz` per SPN |
| Sarek + tumourevo (SPN01–06) | One record per SPN per purity (`0.9`, `0.6`, `0.3`) |
| SPN07 sarek | One record per purity |
| SPN07 tumourevo | One record for purity 0.9 + 0.6, one for 0.3 |

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
get_tumourevo_subclonal("SPN04", 50, 0.6, "mutect2", "sequenza", "mobster", "SPN04_1.1")
get_tumourevo_qc("SPN04", 50, 0.6, "mutect2", "sequenza", "cnaqc", "SPN04_1.1")
get_tumourevo_signatures("SPN04", 50, 0.6, "mutect2", "sequenza", "BASCULE")
```

See the **Zenodo** article for the full function reference.

------------------------------------------------------------------------

## Typical workflow

``` r

library(SCOUT)

# 1. Explore cohort annotations
meta    <- get_metadata()
drivers <- get_ground_truth_drivers("SPN04")
cna     <- get_ground_truth_cna("SPN04")
exp     <- get_ground_truth_exposures("SPN04", type = "SBS")

# 2. Download data
get_sequencing_data("SPN04")
get_sarek_results("SPN04", purity = 0.9)
get_tumourevo_results("SPN04", purity = 0.9)

# 3. Access specific results
mut  <- get_mutations("SPN04", type = "tumour", coverage = 100, purity = 0.9)
vcf  <- get_sarek_vcf("SPN04", "SPN04_1.1", 100, 0.9, "mutect2", "tumour")
sigs <- get_tumourevo_signatures("SPN04", 50, 0.9, "mutect2", "sequenza", "BASCULE")
```
