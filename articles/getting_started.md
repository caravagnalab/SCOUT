# Getting started with SCOUT

The `SCOUT` package gives you direct access to the Simulated Cohort of
Universal Tumours from R. Data live in two places and the package knows
how to talk to both:

| Source | What is stored there | Key functions |
|----|----|----|
| **Google Sheets** | Cohort metadata, ground truth tables | [`get_metadata()`](https://caravagnalab.github.io/SCOUT/reference/get_metadata.md), [`get_ground_truth_cna()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_cna.md), [`get_ground_truth_drivers()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_drivers.md), [`get_ground_truth_exposures()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth_exposures.md), [`get_sampling_information()`](https://caravagnalab.github.io/SCOUT/reference/get_sampling_information.md) |
| **Zenodo** | Per-SPN archives (ground truth RDS, Sarek, tumourevo) | [`get_ground_truth()`](https://caravagnalab.github.io/SCOUT/reference/get_ground_truth.md), [`get_sarek_results()`](https://caravagnalab.github.io/SCOUT/reference/get_sarek_results.md), [`get_tumourevo_results()`](https://caravagnalab.github.io/SCOUT/reference/get_tumourevo_results.md) |

## Installation

``` r

devtools::install_github("caravagnalab/SCOUT")
library(SCOUT)
```

## Data sources

### Google Sheets

Cohort tables are published as public Google Sheets. All functions
return tibbles directly — no authentication or extra packages required.

The following tables are available:

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

All table functions accept optional `spn` and `sample` arguments to
subset the results:

``` r

get_metadata()
get_ground_truth_cna("SPN01")
get_ground_truth_cna("SPN01", sample = "1.1")
get_ground_truth_drivers("SPN01")
get_ground_truth_exposures("SPN01", type = "SBS")
get_sampling_information("SPN01")
```

Convenience lookups return a single value for a given SPN:

``` r

get_sample_names("SPN01")
get_tumour_type("SPN01")
get_gender("SPN01")
```

See the **Google Sheets** article for the full column-level reference.

### Zenodo

Each SPN has a dedicated Zenodo record containing three zip archives:

| Archive | Contents | Returned as |
|----|----|----|
| `ground_truth.zip` | Simulation ground truth (RDS files) | Named list of R objects |
| `sarek.zip` | Sarek pipeline outputs | Local directory path |
| `tumourevo.zip` | tumourevo pipeline outputs | Local directory path |

Files are downloaded once and cached at `~/.cache/SCOUT/<spn>/`. Repeat
calls detect the cache and skip the download. Override the cache root
with the `SCOUT_CACHE_DIR` environment variable (useful on HPC
clusters):

``` r

Sys.setenv(SCOUT_CACHE_DIR = "/scratch/shared/SCOUT")
```

``` r

gt        <- get_ground_truth("SPN01")
sarek_dir <- get_sarek_results("SPN01")
te_dir    <- get_tumourevo_results("SPN01")
```

Once downloaded, dedicated getter functions let you access specific
results without manually navigating the directory structure:

``` r

# Ground truth mutations
path <- get_mutations("SPN01", type = "tumour", coverage = 100, purity = 0.9)

# Sarek variant calls
get_sarek_vcf("SPN01", "SPN01_1", 100, 0.9, "mutect2", "tumour")
get_sarek_cna("SPN01", "SPN01_1", 100, 0.9, "ascat")

# tumourevo results
get_tumourevo_driver("SPN01", 100, 0.9, "mutect2", "ascat", "SPN01_1")
get_tumourevo_subclonal("SPN01", 100, 0.9, "mutect2", "ascat", "mobster", "SPN01_1")
get_tumourevo_qc("SPN01", 100, 0.9, "mutect2", "ascat", "cnaqc", "SPN01_1")
get_tumourevo_signatures("SPN01", 100, 0.9, "mutect2", "ascat", "BASCULE")
```

See the **Zenodo** article for the full function reference.

## Typical workflow

``` r

library(SCOUT)

# 1. Explore the cohort
meta    <- get_metadata()
drivers <- get_ground_truth_drivers("SPN01")
cna     <- get_ground_truth_cna("SPN01")
exp     <- get_ground_truth_exposures("SPN01", type = "SBS")

# 2. Download archives for one SPN
gt        <- get_ground_truth("SPN01")
sarek_dir <- get_sarek_results("SPN01")
te_dir    <- get_tumourevo_results("SPN01")

# 3. Access specific results
mut_path <- get_mutations("SPN01", type = "tumour", coverage = 100, purity = 0.9)
vcf      <- get_sarek_vcf("SPN01", "SPN01_1", 100, 0.9, "mutect2", "tumour")
sigs     <- get_tumourevo_signatures("SPN01", 100, 0.9, "mutect2", "ascat", "BASCULE")
```
