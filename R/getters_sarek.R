# ── Sarek getters ─────────────────────────────────────────────────────────────

.sarek_base <- function(spn) {
  file.path(.scout_cache_dir(spn), "sarek")
}

.sarek_variant_files <- function(spn, sample_id, coverage, purity,
                                  variant_caller, type,
                                  normal_id = "normal_sample",
                                  patient_id = NULL) {
  accepted_callers <- c("mutect2", "strelka", "ascat", "freebayes",
                        "haplotypecaller", "cnvkit", "sequenza")

  if (!is.null(type) && !(type %in% c("tumour", "normal")))
    stop("'type' must be 'tumour' or 'normal'", call. = FALSE)
  if (!(variant_caller %in% accepted_callers))
    stop("'variant_caller' not supported: ", variant_caller, call. = FALSE)

  cov_purity <- paste0(coverage, "x_", purity, "p")
  base_path  <- .sarek_base(spn)

  if (is.null(type) || type == "tumour") {
    sample_naming <- if (variant_caller == "mutect2") spn
                     else paste0(sample_id, "_vs_", normal_id)
    path <- file.path(base_path, spn, "sarek", cov_purity,
                      "variant_calling", variant_caller, sample_naming)
  } else {
    if (variant_caller == "mutect2")
      stop("No normal files associated with caller: mutect2", call. = FALSE)
    path <- file.path(base_path, spn, "sarek", cov_purity,
                      "variant_calling", variant_caller, normal_id)
  }

  list.files(path, full.names = TRUE)
}

.sarek_parse_files <- function(files) {
  if (length(files) == 0) return(list())
  first <- files[[1]]
  named <- list()

  if (grepl("mutect2", first, fixed = TRUE)) {
    for (f in files) {
      if (endsWith(f, "filtered.vcf.gz"))       named[["vcf"]] <- f
      else if (endsWith(f, "filtered.vcf.gz.tbi")) named[["tbi"]] <- f
    }
  } else if (grepl("strelka", first, fixed = TRUE)) {
    for (f in files) {
      if (endsWith(f, "snvs.vcf.gz"))              named[["snvs_vcf"]]     <- f
      else if (endsWith(f, "snvs.vcf.gz.tbi"))     named[["snvs_tbi"]]     <- f
      else if (endsWith(f, "indels.vcf.gz"))        named[["indels_vcf"]]   <- f
      else if (endsWith(f, "indels.vcf.gz.tbi"))    named[["indels_tbi"]]   <- f
      else if (endsWith(f, "variants.vcf.gz"))      named[["variants_vcf"]] <- f
      else if (endsWith(f, "variants.vcf.gz.tbi"))  named[["variants_tbi"]] <- f
    }
  } else if (grepl("freebayes", first, fixed = TRUE)) {
    for (f in files) {
      if (endsWith(f, "freebayes.vcf.gz"))           named[["vcf"]] <- f
      else if (endsWith(f, "freebayes.vcf.gz.tbi"))  named[["tbi"]] <- f
    }
  } else if (grepl("haplotypecaller", first, fixed = TRUE)) {
    for (f in files) {
      if (endsWith(f, "haplotypecaller.filtered.vcf.gz"))
        named[["vcf"]] <- f
      else if (endsWith(f, "haplotypecaller.filtered.vcf.gz.tbi"))
        named[["tbi"]] <- f
    }
  } else if (grepl("ascat", first, fixed = TRUE)) {
    for (f in files) {
      if (endsWith(f, "purityploidy.txt"))   named[["purityploidy"]] <- f
      else if (endsWith(f, "segments.txt"))  named[["segments"]]     <- f
      else if (endsWith(f, "cnvs.txt"))      named[["cnvs"]]         <- f
      else if (endsWith(f, "tumourBAF.txt")) named[["tumourBAF"]]    <- f
      else if (endsWith(f, "tumourLogR.txt")) named[["tumourLogR"]]  <- f
    }
  } else if (grepl("cnvkit", first, fixed = TRUE)) {
    for (f in files) {
      if (endsWith(f, "somatic.call.cns"))  named[["somatic.call"]] <- f
      else if (endsWith(f, ".cnr"))         named[["cnr"]]          <- f
    }
  } else if (grepl("sequenza", first, fixed = TRUE)) {
    for (f in files) {
      if (endsWith(f, "segments.txt"))         named[["segments"]]    <- f
      else if (endsWith(f, "confints_CP.txt")) named[["confints_CP"]] <- f
      else if (endsWith(f, "mutations.txt"))   named[["mutations"]]   <- f
    }
  } else {
    stop("Unrecognised caller in file list", call. = FALSE)
  }
  named
}

#' Get Sarek VCF output files for a SCOUT SPN
#'
#' Returns a named list of VCF (and index) file paths from the Sarek variant
#' calling results for a given sample, coverage, purity and caller.
#'
#' @param spn           SPN identifier, e.g. `"SPN01"`.
#' @param sample_id     Sample identifier.
#' @param coverage      Sequencing coverage (integer, e.g. `100`).
#' @param purity        Sample purity (0–1, e.g. `0.9`).
#' @param caller        VCF caller: `"mutect2"`, `"strelka"`, `"freebayes"`,
#'   or `"haplotypecaller"`.
#' @param type          Sample type: `"tumour"` or `"normal"`.
#' @param normal_id     Normal sample ID. Defaults to `"normal_sample"`.
#'
#' @return Named list of file paths (keys depend on caller, e.g. `vcf`, `tbi`,
#'   `snvs_vcf`, etc.).
#' @export
#'
#' @examples
#' \dontrun{
#' get_sarek_vcf("SPN01", "SPN01_1", 100, 0.9, "mutect2", "tumour")
#' }
get_sarek_vcf <- function(spn, sample_id, coverage, purity, caller, type,
                           normal_id = "normal_sample") {
  .sarek_parse_files(
    .sarek_variant_files(spn, sample_id, coverage, purity,
                         caller, type, normal_id)
  )
}

#' Get Sarek CNA output files for a SCOUT SPN
#'
#' Returns a named list of CNA file paths from the Sarek copy-number calling
#' results for a given sample, coverage, purity and caller.
#'
#' @param spn       SPN identifier, e.g. `"SPN01"`.
#' @param sample_id Sample identifier.
#' @param coverage  Sequencing coverage (integer).
#' @param purity    Sample purity (0–1).
#' @param caller    CNA caller: `"ascat"`, `"sequenza"`, or `"cnvkit"`.
#' @param normal_id Normal sample ID. Defaults to `"normal_sample"`.
#'
#' @return Named list of file paths (keys depend on caller, e.g. `segments`,
#'   `purityploidy`, `cnvs`, etc.).
#' @export
#'
#' @examples
#' \dontrun{
#' get_sarek_cna("SPN01", "SPN01_1", 100, 0.9, "ascat")
#' }
get_sarek_cna <- function(spn, sample_id, coverage, purity, caller,
                           normal_id = "normal_sample") {
  .sarek_parse_files(
    .sarek_variant_files(spn, sample_id, coverage, purity,
                         caller, type = NULL, normal_id)
  )
}
