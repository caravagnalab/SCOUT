# Zenodo record IDs.
#
# Sequencing + normal: one shared record for all SPNs, containing:
#   SPN01_sequencing.tar.gz, SPN01_normal_sequencing.tar.gz,
#   SPN02_sequencing.tar.gz, SPN02_normal_sequencing.tar.gz, ... SPN07
# tumourevo/sarek: one record per SPN per purity (SPN01-SPN06);
#   SPN07 has separate records for sarek and tumourevo

.SCOUT_ZENODO_RECORDS <- list(

  # ── One shared record for all sequencing + normal archives ────────────────
  sequencing = NA_character_,

  # ── tumourevo + sarek (one record per SPN per purity) ─────────────────────
  SPN01 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),
  SPN02 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),
  SPN03 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),
  SPN04 = list(`0.9` = NA_character_, `0.6` = 505306,        `0.3` = NA_character_),
  SPN05 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),
  SPN06 = list(`0.9` = NA_character_, `0.6` = NA_character_, `0.3` = NA_character_),

  # SPN07: sarek per-purity; tumourevo split (0.9+0.6 share one record)
  # SPN07: sarek 0.9 and 0.6 are separate records;
  #         purity 0.3 has one record with both sarek + tumourevo;
  #         tumourevo 0.9+0.6 share one record
  SPN07 = list(
    sarek_0.9     = NA_character_,
    sarek_0.6     = NA_character_,
    purity_0.3    = NA_character_,  # contains sarek.tar.gz + tumourevo.tar.gz
    tumourevo_0.9_0.6 = NA_character_
  )
)

# ── Lookup helpers ────────────────────────────────────────────────────────────

# Shared record containing all SPN0X_sequencing.tar.gz and
# SPN0X_normal_sequencing.tar.gz archives
.scout_sequencing_record_id <- function() {
  .check_record_id(.SCOUT_ZENODO_RECORDS[["sequencing"]], "sequencing")
}

# Record for sarek/tumourevo of a given SPN + purity (+ type for SPN07)
.scout_record_id <- function(spn, purity, type = NULL) {
  entry <- .SCOUT_ZENODO_RECORDS[[spn]]
  if (is.null(entry))
    stop("Unknown SPN: '", spn, "'", call. = FALSE)

  if (spn == "SPN07") {
    p <- as.character(purity)
    key <- if (p == "0.3") {
      "purity_0.3"                          # shared sarek + tumourevo record
    } else if (is.null(type)) {
      stop("'type' (\"sarek\" or \"tumourevo\") is required for SPN07 purity ",
           p, call. = FALSE)
    } else if (type == "sarek") {
      paste0("sarek_", p)
    } else {
      "tumourevo_0.9_0.6"                   # 0.9 and 0.6 share one record
    }
    id <- entry[[key]]
    if (is.null(id))
      stop("No record for SPN07 / key ", key, call. = FALSE)
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
