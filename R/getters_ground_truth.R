# ── Ground truth getters ──────────────────────────────────────────────────────
# All functions resolve paths inside the cached ground_truth/ directory.
# The sarek/ directory mirrors the same base_path structure used by ProCESS.

.gt_base <- function(spn) {
  file.path(.scout_cache_dir(spn), "ground_truth")
}

#' Get mutations from SCOUT ground truth
#'
#' Returns the path to the sequencing mutations RDS file for a given SPN,
#' sample type, coverage and purity.
#'
#' @param spn      SPN identifier, e.g. `"SPN01"`.
#' @param type     Sample type: `"tumour"` or `"normal"`.
#' @param coverage Sequencing coverage (integer, e.g. `100`). Required for
#'   `type = "tumour"`.
#' @param purity   Sample purity between 0 and 1 (e.g. `0.9`). Required for
#'   `type = "tumour"`.
#'
#' @return Path to the mutations RDS file.
#' @export
#'
#' @examples
#' \dontrun{
#' path <- get_mutations("SPN01", type = "tumour", coverage = 100, purity = 0.9)
#' readRDS(path)
#' }
get_mutations <- function(spn, type, coverage = NA, purity = NA) {
  if (is.na(type)) stop("type is required: 'tumour' or 'normal'", call. = FALSE)
  base_path <- .gt_base(spn)

  if (type == "tumour") {
    if (is.na(coverage))
      stop("coverage is required for type = 'tumour'", call. = FALSE)
    if (is.na(purity))
      stop("purity is required for type = 'tumour'", call. = FALSE)
    path <- file.path(base_path, spn,
                      paste0("sequencing/tumour/purity_", purity),
                      paste0("data/mutations/seq_results_muts_merged_coverage_",
                             coverage, "x.rds"))
  } else {
    path <- file.path(base_path, spn,
                      "sequencing/normal/purity_1/data/mutations",
                      "seq_results_muts_merged_coverage_30x.rds")
  }

  if (!file.exists(path))
    stop("File not found — check purity and coverage values:\n  ",
         path, call. = FALSE)
  path
}


#' Get sample names for a SCOUT SPN
#'
#' Looks up sample names from the SCOUT metadata Google Sheet.
#'
#' @param spn SPN identifier, e.g. `"SPN01"`.
#'
#' @return Character vector of sample names.
#' @export
#'
#' @examples
#' \dontrun{
#' get_sample_names("SPN01")
#' }
get_sample_names <- function(spn) {
  .gt_sample_names(spn)
}

#' Get subject gender for a SCOUT SPN
#'
#' Looks up gender from the SCOUT metadata Google Sheet. Requires a `Gender`
#' column to be present in the sheet.
#'
#' @param spn SPN identifier, e.g. `"SPN01"`.
#'
#' @return A character string, e.g. `"XY"` or `"XX"`.
#' @export
#'
#' @examples
#' \dontrun{
#' get_gender("SPN01")
#' }
get_gender <- function(spn) {
  meta <- get_metadata()
  rows <- meta[meta$SPN == spn, "Sex"]
  if (nrow(rows) == 0)
    stop("SPN '", spn, "' not found in metadata.", call. = FALSE)
  unique(rows$Sex)
}

#' Get tumour type for a SCOUT SPN
#'
#' Looks up the tumour type from the SCOUT metadata Google Sheet.
#'
#' @param spn SPN identifier, e.g. `"SPN01"`.
#'
#' @return A character string, e.g. `"CRC"`, `"AML"`.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumour_type("SPN01")
#' }
get_tumour_type <- function(spn) {
  meta <- get_metadata()
  rows <- meta[meta$SPN == spn, "Tumour type"]
  if (nrow(rows) == 0)
    stop("SPN '", spn, "' not found in metadata.", call. = FALSE)
  unique(rows$`Tumour type`)
}

# Internal: get sample names for an SPN from the metadata sheet
.gt_sample_names <- function(spn) {
  meta <- get_metadata()
  rows <- meta[meta$SPN == spn, "Sample"]
  if (nrow(rows) == 0)
    stop("SPN '", spn, "' not found in metadata.", call. = FALSE)
  unique(rows$Sample)
}
