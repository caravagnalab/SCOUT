# ENA run accession lookup table for PRJEB97253.
#
# Key: "<SPN>_<sample>_<purity>" for tumour, "<SPN>_normal" for normals.
# Value: ENA run accession (ERR...). Each run covers both R1 and R2.
# Files are under: ftp.sra.ebi.ac.uk/vol1/run/<ERR-prefix>/<ERR>/<filename>

.SCOUT_ENA_RUNS <- c(
  # ── SPN01 ──────────────────────────────────────────────────────────────────
  "SPN01_normal"  = "ERR15726468",
  "SPN01_1.1_0.3" = "ERR15743951",
  "SPN01_1.1_0.6" = "ERR15750078",
  "SPN01_1.1_0.9" = "ERR15750982",
  "SPN01_1.2_0.3" = "ERR15756720",
  "SPN01_1.2_0.6" = "ERR15757038",
  "SPN01_1.2_0.9" = "ERR15757711",
  "SPN01_1.3_0.3" = "ERR15760992",
  "SPN01_1.3_0.6" = "ERR15761713",
  "SPN01_1.3_0.9" = "ERR15761859",

  # ── SPN02 ──────────────────────────────────────────────────────────────────
  "SPN02_normal"  = "ERR17603652",
  "SPN02_1.1_0.6" = "ERR17625911",
  "SPN02_1.1_0.9" = "ERR17626192",
  "SPN02_1.2_0.6" = "ERR17630557",
  "SPN02_1.2_0.9" = "ERR17632556",

  # ── SPN03 ──────────────────────────────────────────────────────────────────
  "SPN03_normal"  = "ERR15751770",
  "SPN03_1.1_0.3" = "ERR15772337",
  "SPN03_1.1_0.6" = "ERR15772781",
  "SPN03_1.1_0.9" = "ERR15773219",
  "SPN03_2.1_0.3" = "ERR15797837",
  "SPN03_2.1_0.6" = "ERR15798553",
  "SPN03_2.1_0.9" = "ERR15799893",
  "SPN03_3.1_0.3" = "ERR15800648",
  "SPN03_3.1_0.6" = "ERR15801298",
  "SPN03_3.1_0.9" = "ERR15801715",
  "SPN03_4.1_0.3" = "ERR15805035",
  "SPN03_4.1_0.6" = "ERR15805842",
  "SPN03_4.1_0.9" = "ERR15806126",

  # ── SPN04 ──────────────────────────────────────────────────────────────────
  "SPN04_normal"  = "ERR15751912",
  "SPN04_1.1_0.3" = "ERR15765472",
  "SPN04_1.1_0.6" = "ERR15765510",
  "SPN04_1.1_0.9" = "ERR15765559",
  "SPN04_2.1_0.3" = "ERR15765578",
  "SPN04_2.1_0.6" = "ERR15766084",
  "SPN04_2.1_0.9" = "ERR15766489",

  # ── SPN06 ──────────────────────────────────────────────────────────────────
  "SPN06_normal"  = "ERR15752203",
  "SPN06_1.1_0.3" = "ERR15810993",
  "SPN06_1.1_0.6" = "ERR15811483",
  "SPN06_1.1_0.9" = "ERR15811585",
  "SPN06_1.2_0.3" = "ERR15811699",
  "SPN06_1.2_0.6" = "ERR15812456",
  "SPN06_1.2_0.9" = "ERR15813859",
  "SPN06_2.1_0.3" = "ERR15813942",
  "SPN06_2.1_0.6" = "ERR15814016",
  "SPN06_2.1_0.9" = "ERR15814028",
  "SPN06_3.1_0.3" = "ERR15814262",
  "SPN06_3.1_0.6" = "ERR15814505",
  "SPN06_3.1_0.9" = "ERR15814526",
  "SPN06_3.2_0.3" = "ERR15814543",
  "SPN06_3.2_0.6" = "ERR15815742",
  "SPN06_3.2_0.9" = "ERR15815983",

  # ── SPN07 ──────────────────────────────────────────────────────────────────
  "SPN07_normal"  = "ERR15764709",
  "SPN07_1.1_0.3" = "ERR15823985",
  "SPN07_1.1_0.6" = "ERR15824443",
  "SPN07_1.1_0.9" = "ERR15824573",
  "SPN07_1.2_0.3" = "ERR15826291",
  "SPN07_1.2_0.6" = "ERR15827077",
  "SPN07_1.2_0.9" = "ERR15827374",
  "SPN07_1.3_0.3" = "ERR15827485",
  "SPN07_1.3_0.6" = "ERR15828408",
  "SPN07_1.3_0.9" = "ERR15833982",
  "SPN07_2.1_0.3" = "ERR15834853",
  "SPN07_2.1_0.6" = "ERR15835036",
  "SPN07_2.1_0.9" = "ERR15835245",
  "SPN07_2.2_0.3" = "ERR15836007",
  "SPN07_2.2_0.6" = "ERR15836680",
  "SPN07_2.2_0.9" = "ERR15837918"
)

# Build the FTP URL for a given filename using the ERR accession lookup.
# Files are stored at: ftp.sra.ebi.ac.uk/vol1/run/<ERR-prefix>/<ERR>/<filename>
.ena_ftp_url_from_accession <- function(key, filename) {
  run <- .SCOUT_ENA_RUNS[[key]]
  if (is.null(run) || is.na(run))
    stop("No ENA run accession found for '", key, "'.\n",
         "The file may not yet be deposited or the key is incorrect.",
         call. = FALSE)
  prefix <- substr(run, 1, 9)  # e.g. ERR157439 -> ERR157/051 style
  # ENA path pattern: /vol1/run/ERR<3digits>/ERR<full>/<filename>
  err_dir <- paste0("ERR", substr(run, 4, 6))  # ERR157, ERR158, ERR176
  paste0("ftp://ftp.sra.ebi.ac.uk/vol1/run/", err_dir, "/", run, "/", filename)
}
