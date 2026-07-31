.ENA_ACCESSION <- "PRJEB97253"

.ena_cache_dir <- function(spn) {
  root <- Sys.getenv("SCOUT_CACHE_DIR",
                     unset = file.path(path.expand("~"), ".cache", "SCOUT"))
  file.path(root, spn, "fastq")
}

# ── Public API ────────────────────────────────────────────────────────────────

#' List FASTQ files available for a SCOUT SPN on ENA
#'
#' Returns a tibble of expected filenames and their ENA run accessions for a
#' given SPN. The ENA accession is **PRJEB97253**. Does not make a network
#' request.
#'
#' @param spn     SPN identifier, e.g. `"SPN01"`.
#' @param type    `"tumour"` (default), `"normal"`, or `"all"`.
#' @param purity  Purity filter: `"0.9"`, `"0.6"`, `"0.3"`, or `NULL` (all).
#'   Ignored when `type = "normal"`.
#'
#' @return A tibble with columns `filename`, `run_accession`, `type`, `spn`,
#'   `sample`, `purity`, `read`.
#' @export
#'
#' @examples
#' list_ena_files("SPN01")
#' list_ena_files("SPN01", purity = "0.9")
#' list_ena_files("SPN01", type = "normal")
list_ena_files <- function(spn, type = "tumour", purity = NULL) {
  purities <- c("0.9", "0.6", "0.3")
  if (!is.null(purity)) purities <- as.character(purity)

  rows <- list()

  if (type %in% c("tumour", "all")) {
    # collect all tumour keys for this SPN
    pattern <- paste0("^", spn, "_")
    keys <- names(.SCOUT_ENA_RUNS)
    tumour_keys <- keys[grepl(pattern, keys) & !grepl("_normal$", keys)]
    for (key in sort(tumour_keys)) {
      # key format: SPN01_1.1_0.9
      parts  <- strsplit(key, "_")[[1]]
      s      <- parts[2]          # "1.1"
      p      <- parts[3]          # "0.9"
      if (!p %in% purities) next
      run <- .SCOUT_ENA_RUNS[[key]]
      for (r in c("R1", "R2")) {
        fname <- paste0(key, ".", r, ".fastq.gz")
        rows[[length(rows) + 1]] <- list(
          filename = fname, run_accession = run,
          type = "tumour", spn = spn, sample = s, purity = p, read = r
        )
      }
    }
  }

  if (type %in% c("normal", "all")) {
    key <- paste0(spn, "_normal")
    run <- .SCOUT_ENA_RUNS[[key]]
    for (r in c("R1", "R2")) {
      fname <- paste0(key, ".", r, ".fastq.gz")
      rows[[length(rows) + 1]] <- list(
        filename = fname,
        run_accession = if (is.null(run)) NA_character_ else run,
        type = "normal", spn = spn,
        sample = NA_character_, purity = NA_character_, read = r
      )
    }
  }

  if (length(rows) == 0)
    return(tibble::tibble(filename = character(), run_accession = character(),
                          type = character(), spn = character(),
                          sample = character(), purity = character(),
                          read = character()))

  tibble::tibble(
    filename      = vapply(rows, `[[`, character(1), "filename"),
    run_accession = vapply(rows, `[[`, character(1), "run_accession"),
    type          = vapply(rows, `[[`, character(1), "type"),
    spn           = vapply(rows, `[[`, character(1), "spn"),
    sample        = vapply(rows, `[[`, character(1), "sample"),
    purity        = vapply(rows, `[[`, character(1), "purity"),
    read          = vapply(rows, `[[`, character(1), "read")
  )
}

#' Download raw FASTQ files for a SCOUT SPN from ENA
#'
#' Downloads one or more FASTQ files from the ENA accession **PRJEB97253**
#' using the EBI FTP server. Files are cached locally and re-used on
#' subsequent calls.
#'
#' @param spn     SPN identifier, e.g. `"SPN01"`.
#' @param sample  Sample identifier, e.g. `"1.1"`. Use `NULL` for normal files.
#' @param purity  Tumour purity: `"0.9"`, `"0.6"`, or `"0.3"`. Required when
#'   `sample` is not `NULL`.
#' @param read    Read direction: `"R1"`, `"R2"`, or `"both"` (default).
#' @param cache_dir Local directory to store downloaded files. Defaults to
#'   `~/.cache/SCOUT/<spn>/fastq/`.
#'
#' @return Invisible named character vector of local file paths (names are
#'   `"R1"` and/or `"R2"`).
#' @export
#'
#' @examples
#' \dontrun{
#' # Download R1 and R2 for SPN01 sample 1.1 purity 0.9
#' paths <- get_fastq("SPN01", sample = "1.1", purity = "0.9")
#' paths$R1
#' paths$R2
#'
#' # Download normal files
#' get_fastq("SPN01", sample = NULL)
#' }
get_fastq <- function(spn, sample = NULL, purity = NULL,
                      read = "both",
                      cache_dir = .ena_cache_dir(spn)) {
  reads <- if (identical(read, "both")) c("R1", "R2") else read

  if (is.null(sample)) {
    key       <- paste0(spn, "_normal")
    filenames <- stats::setNames(paste0(key, ".", reads, ".fastq.gz"), reads)
  } else {
    if (is.null(purity))
      stop("'purity' is required for tumour samples", call. = FALSE)
    key       <- paste0(spn, "_", sample, "_", purity)
    filenames <- stats::setNames(paste0(key, ".", reads, ".fastq.gz"), reads)
  }

  dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
  out <- stats::setNames(character(length(reads)), reads)

  for (r in reads) {
    fname    <- filenames[[r]]
    dest     <- file.path(cache_dir, fname)
    out[[r]] <- dest

    if (file.exists(dest)) {
      message(fname, " already cached.")
      next
    }

    url <- .ena_ftp_url_from_accession(key, fname)
    message("Downloading ", fname, " ...")
    resp <- httr::GET(url,
                      httr::write_disk(dest, overwrite = TRUE),
                      httr::progress(),
                      httr::user_agent("SCOUT R package"))
    if (httr::http_error(resp)) {
      unlink(dest)
      stop("Download failed (HTTP ", httr::status_code(resp), "): ", fname,
           call. = FALSE)
    }
  }

  invisible(out)
}
