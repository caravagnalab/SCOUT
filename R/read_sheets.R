#' Read a public Google Sheet and return a tibble
#'
#' @param sheet_id The Google Sheets document ID (the long string in the URL).
#' @param gid Optional sheet tab ID (integer). Defaults to the first sheet.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' read_sheet("1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgVE2upms")
#' }
read_sheet <- function(sheet_id, gid = NULL) {
  .scout_read_sheet(sheet_id, gid)
}

#' Get SCOUT sample metadata
#'
#' Returns a tibble with one row per sample, containing identifiers and
#' high-level annotations (tumour type, clonal composition, FGA/FGS,
#' clonal class, hypermutant status, WGD, and signature context).
#'
#' @return A tibble with columns: `SPN`, `Sample`, `FGA`, `FGS`,
#'   `Clonal Class`, `Clonal Subclass`, `Tumour type`, `Sample type`,
#'   `Hypermutant Sample`, `Hypermutant SPN`, `WGD`, `Signature Context`,
#'   `Signature Class`.
#' @export
#'
#' @examples
#' \dontrun{
#' get_metadata()
#' }
get_metadata <- function() {
  .scout_read_sheet(
    sheet_id = "180XPspA_rAYe6wgFCtY7ul7DMTsCAG8MFMrD8-oUiOU",
    gid      = "153231484"
  )
}

#' Get SCOUT ground truth CNA data
#'
#' Returns a tibble of ground truth copy number segments from the SCOUT
#' metadata Google Sheet, with columns `SPN`, `Sample`, `Chromosome`,
#' `Start`, `End`, `Major`, `minor`, and `CCF`.
#' Optionally filtered to a specific SPN and/or sample.
#'
#' @param spn    SPN identifier, e.g. `"SPN01"`. If `NULL`, returns all SPNs.
#' @param sample Sample identifier. If `NULL`, returns all samples for the
#'   selected SPN.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' get_ground_truth_cna()
#' get_ground_truth_cna("SPN01")
#' get_ground_truth_cna("SPN01", sample = "1.1")
#' }
get_ground_truth_cna <- function(spn = NULL, sample = NULL) {
  data <- .scout_read_sheet(
    sheet_id = "180XPspA_rAYe6wgFCtY7ul7DMTsCAG8MFMrD8-oUiOU",
    gid      = "1556881045"
  )
  if (!is.null(spn))    data <- data[data$SPN == spn, ]
  if (!is.null(sample)) data <- data[data$Sample == sample, ]
  data
}

#' Get SCOUT ground truth driver events
#'
#' Returns a tibble of ground truth driver events from the SCOUT metadata
#' Google Sheet, with columns `SPN`, `mutant`, `type`, `CNA_type`, `chr`,
#' `start`, `end`, `ref`, `alt`, `code`, `allele`, `src_allele`.
#' Optionally filtered to a specific SPN.
#'
#' @param spn SPN identifier, e.g. `"SPN01"`. If `NULL`, returns all SPNs.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' get_ground_truth_drivers()
#' get_ground_truth_drivers("SPN01")
#' }
get_ground_truth_drivers <- function(spn = NULL) {
  data <- .scout_read_sheet(
    sheet_id = "180XPspA_rAYe6wgFCtY7ul7DMTsCAG8MFMrD8-oUiOU",
    gid      = "1476373960"
  )
  if (!is.null(spn)) data <- data[data$SPN == spn, ]
  data
}

#' Get SCOUT ground truth mutational signature exposures
#'
#' Returns a tibble of ground truth signature exposures from the SCOUT
#' metadata Google Sheet, with columns `SPN`, `Sample`, `Coverage`, `Purity`,
#' `Type`, `Signature`, and `Exposure`.
#' Optionally filtered by SPN, sample, and/or signature type.
#'
#' @param spn    SPN identifier, e.g. `"SPN01"`. If `NULL`, returns all SPNs.
#' @param sample Sample identifier. If `NULL`, returns all samples.
#' @param type   Signature type, e.g. `"SBS"` or `"ID"`. If `NULL`, returns
#'   all types.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' get_ground_truth_exposures()
#' get_ground_truth_exposures("SPN01")
#' get_ground_truth_exposures("SPN01", type = "SBS")
#' }
get_ground_truth_exposures <- function(spn = NULL, sample = NULL, type = NULL) {
  data <- .scout_read_sheet(
    sheet_id = "180XPspA_rAYe6wgFCtY7ul7DMTsCAG8MFMrD8-oUiOU",
    gid      = "363419813"
  )
  if (!is.null(spn))    data <- data[data$SPN == spn, ]
  if (!is.null(sample)) data <- data[data$Sample == sample, ]
  if (!is.null(type))   data <- data[data$Type == type, ]
  data
}

#' Get SCOUT sampling information
#'
#' Returns a tibble with per-sample sampling details including number of cells,
#' sampling time, and clone proportions.
#' Optionally filtered by SPN and/or sample.
#'
#' @param spn    SPN identifier, e.g. `"SPN01"`. If `NULL`, returns all SPNs.
#' @param sample Sample identifier. If `NULL`, returns all samples.
#'
#' @return A tibble with columns: `SPN`, `Sample`, `Number of cells`,
#'   `Sampling time`, `Clone 1 proportion` … `Clone 7 proportion`.
#' @export
#'
#' @examples
#' \dontrun{
#' get_sampling_information()
#' get_sampling_information("SPN01")
#' get_sampling_information("SPN01", sample = "1.1")
#' }
get_sampling_information <- function(spn = NULL, sample = NULL) {
  data <- .scout_read_sheet(
    sheet_id = "180XPspA_rAYe6wgFCtY7ul7DMTsCAG8MFMrD8-oUiOU",
    gid      = "18585554"
  )
  if (!is.null(spn))    data <- data[data$SPN == spn, ]
  if (!is.null(sample)) data <- data[data$Sample == sample, ]
  data
}
