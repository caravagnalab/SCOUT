# Expected zip names within each SPN Zenodo record
.SCOUT_ZIP_GROUND_TRUTH <- "ground_truth.zip"
.SCOUT_ZIP_SAREK        <- "sarek.zip"
.SCOUT_ZIP_TUMOUREVO    <- "tumourevo.zip"

# Default local cache root: ~/.cache/SCOUT/
.scout_cache_dir <- function(spn) {
  root <- Sys.getenv("SCOUT_CACHE_DIR",
                     unset = file.path(path.expand("~"), ".cache", "SCOUT"))
  file.path(root, spn)
}

.scout_download_zip <- function(url, dest_zip, dest_dir) {
  dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
  if (!file.exists(dest_zip)) {
    message("Downloading ", basename(dest_zip), " ...")
    resp <- httr::GET(url,
                      httr::write_disk(dest_zip, overwrite = TRUE),
                      httr::progress(),
                      httr::user_agent("SCOUT R package"))
    if (httr::http_error(resp)) {
      unlink(dest_zip)
      stop("Download failed (HTTP ", httr::status_code(resp), ")", call. = FALSE)
    }
  }
  unzip(dest_zip, exdir = dest_dir)
  dest_dir
}

.scout_zip_url <- function(record_id, zip_name) {
  record <- .scout_zenodo_record(record_id)
  files  <- record$files
  if (is.null(files) || length(files) == 0)
    stop("No files found in Zenodo record ", record_id, call. = FALSE)
  idx <- which(files$key == zip_name)
  if (length(idx) == 0)
    stop("'", zip_name, "' not found in Zenodo record ", record_id, call. = FALSE)
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

#' Get ground truth simulation data for a SCOUT SPN
#'
#' Downloads and unzips the ground truth archive from the SPN's Zenodo record
#' (if not already cached), then reads all RDS files into a named list.
#'
#' @param spn    SPN identifier, e.g. `"SPN01"`.
#' @param record_id Zenodo record ID for this SPN.
#' @param cache_dir Local directory to cache downloaded files.
#'   Defaults to `~/.cache/SCOUT/<spn>/`.
#'
#' @return A named list of R objects, one per RDS file in the archive.
#' @export
#'
#' @examples
#' \dontrun{
#' gt <- get_ground_truth("SPN01", record_id = "1234567")
#' }
get_ground_truth <- function(spn, record_id = .scout_record_id(spn),
                             cache_dir = .scout_cache_dir(spn)) {
  dest_dir <- file.path(cache_dir, "ground_truth")
  dest_zip <- file.path(cache_dir, .SCOUT_ZIP_GROUND_TRUTH)

  if (!dir.exists(dest_dir) || length(list.files(dest_dir)) == 0) {
    url <- .scout_zip_url(record_id, .SCOUT_ZIP_GROUND_TRUTH)
    .scout_download_zip(url, dest_zip, dest_dir)
  } else {
    message("Ground truth already cached at: ", dest_dir)
  }

  rds_files <- list.files(dest_dir, pattern = "\\.rds$",
                          recursive = TRUE, full.names = TRUE,
                          ignore.case = TRUE)
  if (length(rds_files) == 0)
    stop("No RDS files found in ground truth archive.", call. = FALSE)

  stats::setNames(lapply(rds_files, readRDS),
                  tools::file_path_sans_ext(basename(rds_files)))
}

#' Get the local path to Sarek results for a SCOUT SPN
#'
#' Downloads and unzips the Sarek archive from the SPN's Zenodo record
#' (if not already cached) and returns the path to the extracted directory.
#'
#' @param spn    SPN identifier, e.g. `"SPN01"`.
#' @param record_id Zenodo record ID for this SPN.
#' @param cache_dir Local directory to cache downloaded files.
#'   Defaults to `~/.cache/SCOUT/<spn>/`.
#'
#' @return Invisible path to the directory containing the Sarek results.
#' @export
#'
#' @examples
#' \dontrun{
#' path <- get_sarek_results("SPN01", record_id = "1234567")
#' list.files(path)
#' }
get_sarek_results <- function(spn, record_id = .scout_record_id(spn),
                              cache_dir = .scout_cache_dir(spn)) {
  dest_dir <- file.path(cache_dir, "sarek")
  dest_zip <- file.path(cache_dir, .SCOUT_ZIP_SAREK)

  if (!dir.exists(dest_dir) || length(list.files(dest_dir)) == 0) {
    url <- .scout_zip_url(record_id, .SCOUT_ZIP_SAREK)
    .scout_download_zip(url, dest_zip, dest_dir)
  } else {
    message("Sarek results already cached at: ", dest_dir)
  }

  invisible(dest_dir)
}

#' Get the local path to tumourevo results for a SCOUT SPN
#'
#' Downloads and unzips the tumourevo archive from the SPN's Zenodo record
#' (if not already cached) and returns the path to the extracted directory.
#'
#' @param spn    SPN identifier, e.g. `"SPN01"`.
#' @param record_id Zenodo record ID for this SPN.
#' @param cache_dir Local directory to cache downloaded files.
#'   Defaults to `~/.cache/SCOUT/<spn>/`.
#'
#' @return Invisible path to the directory containing the tumourevo results.
#' @export
#'
#' @examples
#' \dontrun{
#' path <- get_tumourevo_results("SPN01", record_id = "1234567")
#' list.files(path)
#' }
get_tumourevo_results <- function(spn, record_id = .scout_record_id(spn),
                                  cache_dir = .scout_cache_dir(spn)) {
  dest_dir <- file.path(cache_dir, "tumourevo")
  dest_zip <- file.path(cache_dir, .SCOUT_ZIP_TUMOUREVO)

  if (!dir.exists(dest_dir) || length(list.files(dest_dir)) == 0) {
    url <- .scout_zip_url(record_id, .SCOUT_ZIP_TUMOUREVO)
    .scout_download_zip(url, dest_zip, dest_dir)
  } else {
    message("tumourevo results already cached at: ", dest_dir)
  }

  invisible(dest_dir)
}
