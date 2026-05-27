# ── Sarek getters ─────────────────────────────────────────────────────────────
# Archive structure after extraction:
#   <cache>/<spn>/purity_<p>/sarek/<spn>/sarek/<cov>x_<p>p/variant_calling/
#                                                            <caller>/
#                                                            <sample>_vs_normal_sample/

.sarek_base <- function(spn, purity) {
  file.path(.scout_cache_dir(spn, purity), "sarek", spn, "sarek")
}

.sarek_dir <- function(spn, coverage, purity) {
  file.path(.sarek_base(spn, purity),
            paste0(coverage, "x_", purity, "p"),
            "variant_calling")
}

# Sample directory name: e.g. "SPN04_1.1_vs_normal_sample"
.sarek_sample_dir <- function(sample, normal_id = "normal_sample") {
  paste0(sample, "_vs_", normal_id)
}

.sarek_caller_path <- function(spn, coverage, purity, caller, sample,
                                normal_id) {
  base <- .sarek_dir(spn, coverage, purity)
  if (caller == "mutect2") {
    # mutect2 uses SPN-level directory
    file.path(base, "mutect2", spn)
  } else if (caller %in% c("haplotypecaller", "freebayes", "strelka") &&
             is.null(sample)) {
    # normal-only callers
    file.path(base, caller, normal_id)
  } else {
    file.path(base, caller, .sarek_sample_dir(sample, normal_id))
  }
}

.sarek_list_files <- function(path) {
  list.files(path, full.names = TRUE, recursive = FALSE)
}

.sarek_parse_files <- function(files, caller) {
  if (length(files) == 0) return(list())
  named <- list()

  if (caller == "mutect2") {
    for (f in files) {
      if (endsWith(f, "filtered.vcf.gz") && !grepl("filteringStats", f))
        named[["vcf"]] <- f
      else if (endsWith(f, "filtered.vcf.gz.tbi"))
        named[["tbi"]] <- f
      else if (endsWith(f, "filteringStats.tsv"))
        named[["filteringStats"]] <- f
    }
  } else if (caller == "strelka") {
    for (f in files) {
      if (endsWith(f, "somatic.vcf.gz"))
        named[["vcf"]] <- f
      else if (endsWith(f, "somatic.vcf.gz.tbi"))
        named[["tbi"]] <- f
      else if (endsWith(f, "genome.vcf.gz"))
        named[["genome_vcf"]] <- f
      else if (endsWith(f, "variants.vcf.gz"))
        named[["variants_vcf"]] <- f
    }
  } else if (caller == "freebayes") {
    for (f in files) {
      if (endsWith(f, "freebayes.vcf.gz"))
        named[["vcf"]] <- f
      else if (endsWith(f, "freebayes.vcf.gz.tbi"))
        named[["tbi"]] <- f
    }
  } else if (caller == "haplotypecaller") {
    for (f in files) {
      if (endsWith(f, "filtered.vcf.gz"))
        named[["vcf"]] <- f
      else if (endsWith(f, "filtered.vcf.gz.tbi"))
        named[["tbi"]] <- f
    }
  } else if (caller == "ascat") {
    for (f in files) {
      if (endsWith(f, "purityploidy.txt"))
        named[["purityploidy"]] <- f
      else if (endsWith(f, "segments.txt"))
        named[["segments"]] <- f
      else if (endsWith(f, "cnvs.txt"))
        named[["cnvs"]] <- f
      else if (endsWith(f, "tumour_tumourBAF.txt"))
        named[["tumourBAF"]] <- f
      else if (endsWith(f, "tumour_tumourLogR.txt"))
        named[["tumourLogR"]] <- f
      else if (endsWith(f, "metrics.txt"))
        named[["metrics"]] <- f
    }
  } else if (caller == "battenberg") {
    for (f in files) {
      if (endsWith(f, "_subclones.txt"))
        named[["subclones"]] <- f
      else if (endsWith(f, "_rho_and_psi.txt"))
        named[["rho_and_psi"]] <- f
      else if (endsWith(f, ".BAFsegmented.txt"))
        named[["BAFsegmented"]] <- f
      else if (endsWith(f, ".logRsegmented.txt"))
        named[["logRsegmented"]] <- f
      else if (endsWith(f, "_GCwindowCorrelations_afterCorrection.txt"))
        named[["GCwindow"]] <- f
    }
  } else if (caller == "sequenza") {
    for (f in files) {
      if (endsWith(f, "_segments.txt"))
        named[["segments"]] <- f
      else if (endsWith(f, "_confints_CP.txt"))
        named[["confints_CP"]] <- f
      else if (endsWith(f, "_mutations.txt"))
        named[["mutations"]] <- f
      else if (endsWith(f, "_alternative_solutions.txt"))
        named[["alternative_solutions"]] <- f
    }
  } else if (caller == "cnvkit") {
    for (f in files) {
      if (endsWith(f, ".cns"))
        named[["cns"]] <- f
    }
  }
  named
}

#' Get Sarek VCF output files for a SCOUT SPN
#'
#' Returns a named list of VCF (and index) file paths from the Sarek variant
#' calling results for a given sample, coverage, purity and caller.
#' Supported callers: `"mutect2"`, `"strelka"`, `"freebayes"`,
#' `"haplotypecaller"`.
#'
#' @param spn        SPN identifier, e.g. `"SPN04"`.
#' @param sample     Sample identifier, e.g. `"SPN04_1.1"`. Not required for
#'   `"mutect2"` (SPN-level) or normal-only callers.
#' @param coverage   Sequencing coverage (integer, e.g. `100`).
#' @param purity     Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param caller     VCF caller: `"mutect2"`, `"strelka"`, `"freebayes"`, or
#'   `"haplotypecaller"`.
#' @param normal_id  Normal sample ID. Defaults to `"normal_sample"`.
#'
#' @return Named list of file paths.
#' @export
#'
#' @examples
#' \dontrun{
#' get_sarek_vcf("SPN04", "SPN04_1.1", 100, 0.3, "mutect2")
#' get_sarek_vcf("SPN04", "SPN04_1.1", 100, 0.3, "strelka")
#' get_sarek_vcf("SPN04", NULL, 100, 0.3, "haplotypecaller")
#' }
get_sarek_vcf <- function(spn, sample, coverage, purity, caller,
                           normal_id = "normal_sample") {
  vcf_callers <- c("mutect2", "strelka", "freebayes", "haplotypecaller")
  if (!(caller %in% vcf_callers))
    stop("'caller' must be one of: ", paste(vcf_callers, collapse = ", "),
         call. = FALSE)
  path  <- .sarek_caller_path(spn, coverage, purity, caller, sample, normal_id)
  files <- .sarek_list_files(path)
  .sarek_parse_files(files, caller)
}

#' Get Sarek CNA output files for a SCOUT SPN
#'
#' Returns a named list of CNA file paths from the Sarek copy-number calling
#' results. Supported callers: `"ascat"`, `"battenberg"`, `"sequenza"`,
#' `"cnvkit"`.
#'
#' @param spn        SPN identifier, e.g. `"SPN04"`.
#' @param sample     Sample identifier, e.g. `"SPN04_1.1"`.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param caller     CNA caller: `"ascat"`, `"battenberg"`, `"sequenza"`, or
#'   `"cnvkit"`.
#' @param normal_id  Normal sample ID. Defaults to `"normal_sample"`.
#'
#' @return Named list of file paths (keys depend on caller).
#' @export
#'
#' @examples
#' \dontrun{
#' get_sarek_cna("SPN04", "SPN04_1.1", 100, 0.3, "ascat")
#' get_sarek_cna("SPN04", "SPN04_1.1", 100, 0.3, "battenberg")
#' get_sarek_cna("SPN04", "SPN04_1.1", 100, 0.3, "sequenza")
#' }
get_sarek_cna <- function(spn, sample, coverage, purity, caller,
                           normal_id = "normal_sample") {
  cna_callers <- c("ascat", "battenberg", "sequenza", "cnvkit")
  if (!(caller %in% cna_callers))
    stop("'caller' must be one of: ", paste(cna_callers, collapse = ", "),
         call. = FALSE)
  path  <- .sarek_caller_path(spn, coverage, purity, caller, sample, normal_id)
  files <- .sarek_list_files(path)
  .sarek_parse_files(files, caller)
}
