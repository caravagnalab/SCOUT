# Internal helpers shared across SCOUT functions

.scout_sheet_url <- function(sheet_id, gid = NULL) {
  url <- paste0(
    "https://docs.google.com/spreadsheets/d/", sheet_id,
    "/export?format=csv"
  )
  if (!is.null(gid)) url <- paste0(url, "&gid=", gid)
  url
}

.scout_read_sheet <- function(sheet_id, gid = NULL) {
  url <- .scout_sheet_url(sheet_id, gid)
  readr::read_csv(url, show_col_types = FALSE, progress = FALSE)
}

.scout_zenodo_record <- function(record_id) {
  url <- paste0("https://zenodo.org/api/records/", record_id)
  resp <- httr::GET(url, httr::user_agent("SCOUT R package"))
  if (httr::http_error(resp)) {
    stop("Zenodo request failed for record ", record_id,
         " (HTTP ", httr::status_code(resp), ")", call. = FALSE)
  }
  httr::content(resp, as = "parsed", simplifyVector = TRUE)
}
