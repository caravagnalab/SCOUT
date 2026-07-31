# List FASTQ files available for a SCOUT SPN on ENA

Returns a tibble of expected filenames and their ENA run accessions for
a given SPN. The ENA accession is **PRJEB97253**. Does not make a
network request.

## Usage

``` r
list_ena_files(spn, type = "tumour", purity = NULL)
```

## Arguments

- spn:

  SPN identifier, e.g. `"SPN01"`.

- type:

  `"tumour"` (default), `"normal"`, or `"all"`.

- purity:

  Purity filter: `"0.9"`, `"0.6"`, `"0.3"`, or `NULL` (all). Ignored
  when `type = "normal"`.

## Value

A tibble with columns `filename`, `run_accession`, `type`, `spn`,
`sample`, `purity`, `read`.

## Examples

``` r
list_ena_files("SPN01")
#> # A tibble: 18 × 7
#>    filename                  run_accession type   spn   sample purity read 
#>    <chr>                     <chr>         <chr>  <chr> <chr>  <chr>  <chr>
#>  1 SPN01_1.1_0.3.R1.fastq.gz ERR15743951   tumour SPN01 1.1    0.3    R1   
#>  2 SPN01_1.1_0.3.R2.fastq.gz ERR15743951   tumour SPN01 1.1    0.3    R2   
#>  3 SPN01_1.1_0.6.R1.fastq.gz ERR15750078   tumour SPN01 1.1    0.6    R1   
#>  4 SPN01_1.1_0.6.R2.fastq.gz ERR15750078   tumour SPN01 1.1    0.6    R2   
#>  5 SPN01_1.1_0.9.R1.fastq.gz ERR15750982   tumour SPN01 1.1    0.9    R1   
#>  6 SPN01_1.1_0.9.R2.fastq.gz ERR15750982   tumour SPN01 1.1    0.9    R2   
#>  7 SPN01_1.2_0.3.R1.fastq.gz ERR15756720   tumour SPN01 1.2    0.3    R1   
#>  8 SPN01_1.2_0.3.R2.fastq.gz ERR15756720   tumour SPN01 1.2    0.3    R2   
#>  9 SPN01_1.2_0.6.R1.fastq.gz ERR15757038   tumour SPN01 1.2    0.6    R1   
#> 10 SPN01_1.2_0.6.R2.fastq.gz ERR15757038   tumour SPN01 1.2    0.6    R2   
#> 11 SPN01_1.2_0.9.R1.fastq.gz ERR15757711   tumour SPN01 1.2    0.9    R1   
#> 12 SPN01_1.2_0.9.R2.fastq.gz ERR15757711   tumour SPN01 1.2    0.9    R2   
#> 13 SPN01_1.3_0.3.R1.fastq.gz ERR15760992   tumour SPN01 1.3    0.3    R1   
#> 14 SPN01_1.3_0.3.R2.fastq.gz ERR15760992   tumour SPN01 1.3    0.3    R2   
#> 15 SPN01_1.3_0.6.R1.fastq.gz ERR15761713   tumour SPN01 1.3    0.6    R1   
#> 16 SPN01_1.3_0.6.R2.fastq.gz ERR15761713   tumour SPN01 1.3    0.6    R2   
#> 17 SPN01_1.3_0.9.R1.fastq.gz ERR15761859   tumour SPN01 1.3    0.9    R1   
#> 18 SPN01_1.3_0.9.R2.fastq.gz ERR15761859   tumour SPN01 1.3    0.9    R2   
list_ena_files("SPN01", purity = "0.9")
#> # A tibble: 6 × 7
#>   filename                  run_accession type   spn   sample purity read 
#>   <chr>                     <chr>         <chr>  <chr> <chr>  <chr>  <chr>
#> 1 SPN01_1.1_0.9.R1.fastq.gz ERR15750982   tumour SPN01 1.1    0.9    R1   
#> 2 SPN01_1.1_0.9.R2.fastq.gz ERR15750982   tumour SPN01 1.1    0.9    R2   
#> 3 SPN01_1.2_0.9.R1.fastq.gz ERR15757711   tumour SPN01 1.2    0.9    R1   
#> 4 SPN01_1.2_0.9.R2.fastq.gz ERR15757711   tumour SPN01 1.2    0.9    R2   
#> 5 SPN01_1.3_0.9.R1.fastq.gz ERR15761859   tumour SPN01 1.3    0.9    R1   
#> 6 SPN01_1.3_0.9.R2.fastq.gz ERR15761859   tumour SPN01 1.3    0.9    R2   
list_ena_files("SPN01", type = "normal")
#> # A tibble: 2 × 7
#>   filename                 run_accession type   spn   sample purity read 
#>   <chr>                    <chr>         <chr>  <chr> <chr>  <chr>  <chr>
#> 1 SPN01_normal.R1.fastq.gz ERR15726468   normal SPN01 NA     NA     R1   
#> 2 SPN01_normal.R2.fastq.gz ERR15726468   normal SPN01 NA     NA     R2   
```
