# Raw FASTQ data

Raw FASTQ files for all SCOUT samples are deposited in the European
Nucleotide Archive (ENA) under accession number **PRJEB97253**.

------------------------------------------------------------------------

## ENA record structure

The accession **PRJEB97253** contains one file per sample × purity ×
read direction, plus matched normals:

| Data type | Files | Count |
|----|----|----|
| Tumour (24 samples × 3 purities × R1+R2) | `{spn}_{sample}_{purity}.R1.fastq.gz` / `.R2.fastq.gz` | 144 |
| Normal (7 SPNs × R1+R2) | `{spn}_normal.R1.fastq.gz` / `.R2.fastq.gz` | 14 |
| **Total** |  | **158** |

Examples:

    SPN02_1.1_0.9.R1.fastq.gz    SPN02_1.1_0.9.R2.fastq.gz
    SPN02_1.1_0.6.R1.fastq.gz    SPN02_1.1_0.6.R2.fastq.gz
    SPN02_1.1_0.3.R1.fastq.gz    SPN02_1.1_0.3.R2.fastq.gz
    SPN05_normal.R1.fastq.gz      SPN05_normal.R2.fastq.gz

## Internal structure of each FASTQ file

Each tumour FASTQ file (e.g. `SPN02_1.1_0.9.R1.fastq.gz`) is a
concatenation of 40 bins `t00`–`t39`, where each bin contains reads from
one 5× coverage chunk. The reads are named with the bin prefix and
sample identifier:

    t14_SPN01_1.2.R2.fastq.gz    (individual bin file, tumour)
    n3_normal_sample.R2.fastq.gz  (individual bin file, normal)

Each bin × 5× = **200× total** per sample across all 40 bins.

------------------------------------------------------------------------

## Coverage bins

Each `tXX` bin corresponds to exactly **5× sequencing coverage**.
Consecutive bins are combined to reproduce standard coverage levels:

| Coverage | Bins used   | Number of bins |
|----------|-------------|----------------|
| 50×      | `t00`–`t09` | 10             |
| 100×     | `t00`–`t19` | 20             |
| 150×     | `t00`–`t29` | 30             |
| 200×     | `t00`–`t39` | 40             |

------------------------------------------------------------------------

## Subsampling with SeqKit

[SeqKit](https://bioinf.shenwei.me/seqkit/) is required to subset FASTQ
files by header pattern while preserving valid FASTQ format.

### Installation

``` bash
# Conda (recommended)
conda install bioconda::seqkit

# Docker
docker pull quay.io/biocontainers/seqkit:2.9.0--h9ee0642_0

# Singularity
singularity pull https://depot.galaxyproject.org/singularity/seqkit:2.9.0--h9ee0642_0
```

The input is the merged FASTQ file from ENA
(e.g. `SPN02_1.1_0.9.R1.fastq.gz`), which contains reads from all 40
bins concatenated together. SeqKit filters by the `tXX` prefix in each
read name to extract a specific coverage level.

### 50× coverage

Select bins `t00`–`t09` (10 × 5× = 50×):

``` bash
seqkit grep --threads 2 -n -r -p "^t0[0-9]" \
  SPN02_1.1_0.9.R1.fastq.gz -o SPN02_1.1_0.9_50x.R1.fastq.gz

seqkit grep --threads 2 -n -r -p "^t0[0-9]" \
  SPN02_1.1_0.9.R2.fastq.gz -o SPN02_1.1_0.9_50x.R2.fastq.gz
```

### 100× coverage

Select bins `t00`–`t19` (20 × 5× = 100×):

``` bash
seqkit grep --threads 2 -n -r -p "^t(0[0-9]|1[0-9])_" \
  SPN02_1.1_0.9.R1.fastq.gz -o SPN02_1.1_0.9_100x.R1.fastq.gz

seqkit grep --threads 2 -n -r -p "^t(0[0-9]|1[0-9])_" \
  SPN02_1.1_0.9.R2.fastq.gz -o SPN02_1.1_0.9_100x.R2.fastq.gz
```

### 150× coverage

Select bins `t00`–`t29` (30 × 5× = 150×):

``` bash
seqkit grep --threads 2 -n -r -p "^t(0[0-9]|1[0-9]|2[0-9])_" \
  SPN02_1.1_0.9.R1.fastq.gz -o SPN02_1.1_0.9_150x.R1.fastq.gz

seqkit grep --threads 2 -n -r -p "^t(0[0-9]|1[0-9]|2[0-9])_" \
  SPN02_1.1_0.9.R2.fastq.gz -o SPN02_1.1_0.9_150x.R2.fastq.gz
```

### 200× coverage (full)

Use the file as downloaded — no filtering needed.

------------------------------------------------------------------------

## Notes

- The same bin pattern must be applied consistently to both `R1` and
  `R2` to maintain paired-end integrity.
- Output files are valid FASTQ and can be passed directly to any
  alignment or variant calling pipeline (e.g. Sarek).
- SeqKit is recommended for large files due to its speed and low memory
  usage.
