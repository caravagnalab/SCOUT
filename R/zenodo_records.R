# Zenodo record IDs for each SPN.
# Fill in the record_id values once the deposits are published.
.SCOUT_ZENODO_RECORDS <- c(
  SPN01 = NA_character_,
  SPN02 = NA_character_,
  SPN03 = NA_character_,
  SPN04 = NA_character_,
  SPN05 = NA_character_,
  SPN06 = NA_character_,
  SPN07 = NA_character_
)

.scout_record_id <- function(spn) {
  id <- .SCOUT_ZENODO_RECORDS[spn]
  if (is.na(id))
    stop("No Zenodo record ID registered for '", spn, "'. ",
         "Check R/zenodo_records.R.", call. = FALSE)
  id
}
