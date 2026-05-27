# Zenodo record IDs.
#
# Sequencing ground truth: one record per SPN, containing SPN0X_sequencing.tar.gz
# Normal samples:          one shared record, containing SPN0X_normal.tar.gz for each SPN
# tumourevo/sarek:         one record per SPN per purity (SPN01-SPN06);
#                          SPN07 has separate records for sarek and tumourevo

.SCOUT_ZENODO_RECORDS <- list(

  # ── Sequencing ground truth (one record per SPN) ───────────────────────────
  sequencing = list(
    SPN01 = NA_character_,
    SPN02 = NA_character_,
    SPN03 = NA_character_,
    SPN04 = NA_character_,
    SPN05 = NA_character_,
    SPN06 = NA_character_,
    SPN07 = NA_character_
  ),

  # ── Normal sarek outputs (one shared record for all SPNs) ──────────────────
  normal = NA_character_,

  # ── tumourevo + sarek (one record per SPN per purity) ─────────────────────
  SPN01 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),
  SPN02 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),
  SPN03 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),
  SPN04 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),
  SPN05 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),
  SPN06 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),

  # SPN07: sarek per-purity; tumourevo split (0.9+0.6 share one record)
  SPN07 = list(
    sarek = list(
      `0.9` = NA_character_,
      `0.6` = NA_character_,
      `0.3` = NA_character_
    ),
    tumourevo = list(
      `0.9_0.6` = NA_character_,
      `0.3`     = NA_character_
    )
  )
)

# ── Lookup helpers ────────────────────────────────────────────────────────────

# Record for sequencing ground truth of one SPN
.scout_sequencing_record_id <- function(spn) {
  id <- .SCOUT_ZENODO_RECORDS[["sequencing"]][[spn]]
  if (is.null(id))
    stop("Unknown SPN: '", spn, "'", call. = FALSE)
  .check_record_id(id, paste("sequencing", spn))
}

# Shared record for all normal samples
.scout_normal_record_id <- function() {
  .check_record_id(.SCOUT_ZENODO_RECORDS[["normal"]], "normal")
}

# Record for sarek/tumourevo of a given SPN + purity (+ type for SPN07)
.scout_record_id <- function(spn, purity, type = NULL) {
  entry <- .SCOUT_ZENODO_RECORDS[[spn]]
  if (is.null(entry))
    stop("Unknown SPN: '", spn, "'", call. = FALSE)

  if (spn == "SPN07") {
    if (is.null(type))
      stop("'type' (\"sarek\" or \"tumourevo\") is required for SPN07",
           call. = FALSE)
    sub <- entry[[type]]
    key <- if (type == "tumourevo" && purity %in% c("0.9", "0.6")) "0.9_0.6"
           else as.character(purity)
    id <- sub[[key]]
    if (is.null(id))
      stop("No record for SPN07 / ", type, " / purity ", purity, call. = FALSE)
  } else {
    id <- entry[[as.character(purity)]]
    if (is.null(id))
      stop("No record for ", spn, " / purity ", purity, call. = FALSE)
  }

  .check_record_id(id, paste(spn, "purity", purity))
}

.check_record_id <- function(id, label) {
  if (is.na(id))
    stop("Zenodo record ID not yet registered for: ", label,
         ". Fill in R/zenodo_records.R.", call. = FALSE)
  id
}
