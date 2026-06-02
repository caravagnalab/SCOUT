.SCOUT_TAR_SAREK     <- "sarek.tar.gz"
.SCOUT_TAR_TUMOUREVO <- "tumourevo.tar.gz"

.scout_cache_dir <- function(spn, purity = NULL) {
  root <- Sys.getenv("SCOUT_CACHE_DIR",
                     unset = file.path(path.expand("~"), ".cache", "SCOUT"))
  if (!is.null(purity))
    file.path(root, spn, paste0("purity_", purity))
  else
    file.path(root, spn)
}

.scout_download_tar <- function(url, dest_tar, dest_dir, spn = NULL) {
  dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
  if (!file.exists(dest_tar)) {
    message("Downloading ", basename(dest_tar), " ...")
    resp <- httr::GET(url,
                      httr::write_disk(dest_tar, overwrite = TRUE),
                      httr::progress(),
                      httr::user_agent("SCOUT R package"))
    if (httr::http_error(resp)) {
      unlink(dest_tar)
      stop("Download failed (HTTP ", httr::status_code(resp), ")",
           call. = FALSE)
    }
  }
  message("Extracting ", basename(dest_tar), " ...")
  extract_dir <- if (!is.null(spn)) file.path(dest_dir, spn) else dest_dir
  dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)
  utils::untar(dest_tar, exdir = extract_dir)
  dest_dir
}

.scout_tar_url <- function(record_id, tar_name) {
  record <- .scout_zenodo_record(record_id)
  files  <- record$files
  if (is.null(files) || length(files) == 0)
    stop("No files found in Zenodo record ", record_id, call. = FALSE)
  idx <- which(files$key == tar_name)
  if (length(idx) == 0)
    stop("'", tar_name, "' not found in Zenodo record ", record_id,
         call. = FALSE)
  files$links$self[[idx]]
}

# ── Public API ────────────────────────────────────────────────────────────────

#' List files available in a Zenodo record
#'
#' @param record_id Zenodo record ID (integer or string).
#'
#' @return A tibble with columns `filename`, `size`, `download_url`.
#' @export
list_zenodo_files <- function(record_id) {
  record <- .scout_zenodo_record(record_id)
  files  <- record$files
  if (is.null(files) || length(files) == 0) {
    return(tibble::tibble(filename = character(), size = integer(),
                          download_url = character()))
  }
  tibble::tibble(
    filename     = files$key,
    size         = files$size,
    download_url = files$links$self
  )
}

#' Download SCOUT sequencing ground truth for a SPN
#'
#' Downloads and extracts `SPN0X_sequencing.tar.gz` from the SPN's sequencing
#' Zenodo record (if not already cached). The archive contains tumour mutation
#' RDS files for all purity and coverage combinations.
#'
#' @param spn       SPN identifier, e.g. `"SPN01"`.
#' @param record_id Zenodo record ID. Defaults to the registered sequencing
#'   record for this SPN.
#' @param cache_dir Local directory to cache downloaded files.
#'
#' @return Invisible path to the extracted directory.
#' @export
#'
#' @examples
#' \dontrun{
#' get_sequencing_data("SPN04")
#' }
get_sequencing_data <- function(spn,
                                 record_id = .scout_sequencing_record_id(),
                                 cache_dir = .scout_cache_dir(spn)) {
  tar_name <- paste0(spn, "_sequencing.tar.gz")
  dest_dir <- file.path(cache_dir, "sequencing")
  dest_tar <- file.path(cache_dir, tar_name)

  if (!dir.exists(dest_dir) || length(list.files(dest_dir)) == 0) {
    url <- .scout_tar_url(record_id, tar_name)
    .scout_download_tar(url, dest_tar, dest_dir)
  } else {
    message("Sequencing data already cached at: ", dest_dir)
  }

  invisible(dest_dir)
}

#' Download SCOUT normal sarek results for a SPN
#'
#' Downloads and extracts `SPN0X_normal_sequencing.tar.gz` from the SPN's
#' sequencing Zenodo record (if not already cached). The archive contains
#' haplotypecaller and freebayes VCF files for the normal sample.
#'
#' @param spn       SPN identifier, e.g. `"SPN04"`.
#' @param record_id Zenodo record ID. Defaults to the sequencing record for
#'   this SPN.
#' @param cache_dir Local directory to cache downloaded files.
#'
#' @return Invisible path to the extracted directory.
#' @export
#'
#' @examples
#' \dontrun{
#' get_normal_data("SPN04")
#' }
get_normal_data <- function(spn,
                             record_id = .scout_sequencing_record_id(),
                             cache_dir = .scout_cache_dir(spn)) {
  tar_name <- paste0(spn, "_normal_sequencing.tar.gz")
  dest_dir <- file.path(cache_dir, "normal")
  dest_tar <- file.path(cache_dir, tar_name)

  if (!dir.exists(dest_dir) || length(list.files(dest_dir)) == 0) {
    url <- .scout_tar_url(record_id, tar_name)
    .scout_download_tar(url, dest_tar, dest_dir)
  } else {
    message("Normal data already cached at: ", dest_dir)
  }

  invisible(dest_dir)
}

#' Get the local path to Sarek results for a SCOUT SPN
#'
#' Downloads and extracts the Sarek archive for a given SPN and purity
#' (if not already cached) and returns the path to the extracted directory.
#'
#' @param spn       SPN identifier, e.g. `"SPN01"`.
#' @param purity    Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param record_id Zenodo record ID. Defaults to the registered record for
#'   this SPN and purity.
#' @param cache_dir Local directory to cache downloaded files.
#'
#' @return Invisible path to the directory containing the Sarek results.
#' @export
#'
#' @examples
#' \dontrun{
#' path <- get_sarek_results("SPN01", purity = 0.9)
#' }
get_sarek_results <- function(spn, purity,
                               record_id = .scout_record_id(spn, purity,
                                                             type = "sarek"),
                               cache_dir = .scout_cache_dir(spn, purity)) {
  dest_dir <- file.path(cache_dir, "sarek")
  dest_tar <- file.path(cache_dir, .SCOUT_TAR_SAREK)

  if (!dir.exists(dest_dir) || length(list.files(dest_dir)) == 0) {
    url <- .scout_tar_url(record_id, .SCOUT_TAR_SAREK)
    .scout_download_tar(url, dest_tar, dest_dir, spn = spn)
  } else {
    message("Sarek results already cached at: ", dest_dir)
  }

  invisible(dest_dir)
}

#' Get the local path to tumourevo results for a SCOUT SPN
#'
#' Downloads and extracts the tumourevo archive for a given SPN and purity
#' (if not already cached) and returns the path to the extracted directory.
#'
#' @param spn       SPN identifier, e.g. `"SPN01"`.
#' @param purity    Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param record_id Zenodo record ID. Defaults to the registered record for
#'   this SPN and purity.
#' @param cache_dir Local directory to cache downloaded files.
#'
#' @return Invisible path to the directory containing the tumourevo results.
#' @export
#'
#' @examples
#' \dontrun{
#' path <- get_tumourevo_results("SPN01", purity = 0.9)
#' }
get_tumourevo_results <- function(spn, purity,
                                   record_id = .scout_record_id(spn, purity,
                                                                 type = "tumourevo"),
                                   cache_dir = .scout_cache_dir(spn, purity)) {
  # SPN07 purity 0.9 and 0.6 live in separate named archives
  tar_name <- if (spn == "SPN07" && as.character(purity) %in% c("0.9", "0.6"))
    paste0("tumourevo_", purity, ".tar.gz")
  else
    .SCOUT_TAR_TUMOUREVO

  dest_dir <- file.path(cache_dir, "tumourevo")
  dest_tar <- file.path(cache_dir, tar_name)

  if (!dir.exists(dest_dir) || length(list.files(dest_dir)) == 0) {
    url <- .scout_tar_url(record_id, tar_name)
    .scout_download_tar(url, dest_tar, dest_dir, spn = spn)
  } else {
    message("tumourevo results already cached at: ", dest_dir)
  }

  invisible(dest_dir)
}
