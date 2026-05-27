# Tables

Cohort-level tables are stored as public Google Sheets and are
accessible directly as tibbles — no authentication or extra packages
required.

## `get_metadata()`

Returns a tibble with one row per sample and signature context, covering
high-level cohort annotations.

``` r

meta <- get_metadata()
meta
```

| Column               | Description                                         |
|----------------------|-----------------------------------------------------|
| `SPN`                | SPN identifier (e.g. `SPN01`)                       |
| `Sample`             | Sample identifier                                   |
| `FGA`                | Fraction of genome altered (`High` / `Low`)         |
| `FGS`                | Fraction of genome with SNVs (`High` / `Low`)       |
| `Clonal Class`       | Clonal architecture class                           |
| `Clonal Subclass`    | Clonal architecture subclass                        |
| `Tumour type`        | Tumour type abbreviation (e.g. `CRC`, `AML`)        |
| `Sample type`        | `Multi-region` or `Longitudinal`                    |
| `Hypermutant Sample` | Whether this sample is hypermutant                  |
| `Hypermutant SPN`    | Whether the SPN as a whole is hypermutant           |
| `WGD`                | Whole-genome duplication detected                   |
| `Signature Context`  | Mutational signature channel (e.g. `SBS96`, `ID83`) |
| `Signature Class`    | Complexity class of the signature activity          |
| `Sex`                | Subject sex chromosome complement (e.g. `XY`, `XX`) |

Convenience functions derived from the metadata table:

``` r

get_sample_names("SPN01")   # character vector of sample names
get_tumour_type("SPN01")    # tumour type string
get_gender("SPN01")         # sex chromosome complement
```

## `get_ground_truth_cna()`

Returns a tibble of ground truth copy number segments. Can be filtered
by SPN and/or sample.

``` r

get_ground_truth_cna()                          # all SPNs
get_ground_truth_cna("SPN01")                   # one SPN
get_ground_truth_cna("SPN01", sample = "1.1")   # one sample
```

| Column       | Description              |
|--------------|--------------------------|
| `SPN`        | SPN identifier           |
| `Sample`     | Sample identifier        |
| `Chromosome` | Chromosome               |
| `Start`      | Segment start position   |
| `End`        | Segment end position     |
| `Major`      | Major allele copy number |
| `minor`      | Minor allele copy number |
| `CCF`        | Cancer cell fraction     |

## `get_ground_truth_drivers()`

Returns a tibble of ground truth driver events (SNVs, CNAs, WGD). Can be
filtered by SPN.

``` r

get_ground_truth_drivers()          # all SPNs
get_ground_truth_drivers("SPN01")   # one SPN
```

| Column          | Description                                    |
|-----------------|------------------------------------------------|
| `SPN`           | SPN identifier                                 |
| `mutant`        | Clone carrying the event                       |
| `type`          | Event type (`SID`, `CNA`, `WGD`)               |
| `CNA_type`      | CNA subtype (e.g. `D` for deletion)            |
| `chr`           | Chromosome                                     |
| `start` / `end` | Genomic coordinates                            |
| `ref` / `alt`   | Reference and alternate alleles                |
| `code`          | Gene and amino acid change (e.g. `APC R1450*`) |
| `allele`        | Affected allele                                |
| `src_allele`    | Source allele                                  |

## `get_ground_truth_exposures()`

Returns a tibble of ground truth mutational signature exposures. Can be
filtered by SPN, sample, and/or signature type.

``` r

get_ground_truth_exposures()                          # all
get_ground_truth_exposures("SPN01")                   # one SPN
get_ground_truth_exposures("SPN01", type = "SBS")     # SBS only
get_ground_truth_exposures("SPN01", sample = "1.1")   # one sample
```

| Column      | Description                         |
|-------------|-------------------------------------|
| `SPN`       | SPN identifier                      |
| `Sample`    | Sample identifier                   |
| `Coverage`  | Sequencing coverage                 |
| `Purity`    | Sample purity                       |
| `Type`      | Signature type (`SBS`, `ID`)        |
| `Signature` | Signature name (e.g. `SBS1`, `ID2`) |
| `Exposure`  | Signature exposure value            |

## `get_sampling_information()`

Returns a tibble with per-sample sampling details including number of
cells, sampling time, and clone proportions. Can be filtered by SPN
and/or sample.

``` r

get_sampling_information()                          # all SPNs
get_sampling_information("SPN01")                   # one SPN
get_sampling_information("SPN01", sample = "1.1")   # one sample
```

| Column                 | Description                          |
|------------------------|--------------------------------------|
| `SPN`                  | SPN identifier                       |
| `Sample`               | Sample identifier                    |
| `Number of cells`      | Number of sampled cells              |
| `Sampling time`        | Time of sampling                     |
| `Clone 1–7 proportion` | Proportion of each clone at sampling |

## `read_sheet()`

Generic reader for any public Google Sheet. Useful for accessing
additional tables not yet wrapped by a dedicated function.

``` r

df <- read_sheet(
  sheet_id = "<sheet_id>",
  gid      = "<tab_id>"
)
```

The `sheet_id` is the long string in the Google Sheets URL:

    https://docs.google.com/spreadsheets/d/<sheet_id>/edit#gid=<gid>
