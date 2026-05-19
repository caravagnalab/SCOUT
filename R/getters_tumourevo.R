# ── tumourevo getters ─────────────────────────────────────────────────────────
# All functions resolve paths inside the cached tumourevo/ directory.

.te_base <- function(spn) {
  file.path(.scout_cache_dir(spn), "tumourevo")
}

.te_dir <- function(spn, coverage, purity, vcf_caller, cna_caller) {
  vcf_callers <- c("mutect2", "strelka")
  cna_callers <- c("ascat", "sequenza")

  if (!is.numeric(coverage) || coverage %% 1 != 0)
    stop("'coverage' must be an integer", call. = FALSE)
  if (!is.numeric(purity) || purity > 1 || purity < 0)
    stop("'purity' must be a number between 0 and 1", call. = FALSE)
  if (!(vcf_caller %in% vcf_callers))
    stop("'vcf_caller' must be one of: ", paste(vcf_callers, collapse = ", "), call. = FALSE)
  if (!(cna_caller %in% cna_callers))
    stop("'cna_caller' must be one of: ", paste(cna_callers, collapse = ", "), call. = FALSE)

  ptr <- paste(paste0(coverage, "x"), paste0(purity, "p"),
               vcf_caller, cna_caller, sep = "_")
  file.path(.te_base(spn), spn, "tumourevo", ptr)
}

.te_named_files <- function(dir_path) {
  files <- list.files(dir_path, full.names = TRUE)
  files <- files[!file.info(files)$isdir]
  stats::setNames(as.list(files),
                  tools::file_path_sans_ext(basename(files)))
}

.te_normalise <- function(input_list, prefix_pattern = "^SCOUT_SPN\\d+_") {
  stats::setNames(
    input_list,
    lapply(names(input_list), function(nm) {
      gsub("\\.", "_", sub(prefix_pattern, "", nm))
    })
  )
}

#' Get tumourevo driver annotation paths
#'
#' @param spn        SPN identifier, e.g. `"SPN01"`.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity (0–1).
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param sample     Sample name.
#'
#' @return Character vector of paths to driver RDS files.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_driver("SPN01", 100, 0.9, "mutect2", "ascat", "SPN01_1")
#' }
get_tumourevo_driver <- function(spn, coverage, purity, vcf_caller, cna_caller, sample) {
  main_path <- file.path(
    .te_dir(spn, coverage, purity, vcf_caller, cna_caller),
    "driver_annotation/annotate_driver/SCOUT", spn
  )
  list.files(main_path, pattern = paste0("\\", sample, "_driver.rds$"),
             full.names = TRUE, recursive = TRUE)
}

#' Get tumourevo subclonal deconvolution result paths
#'
#' @param spn        SPN identifier.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity (0–1).
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param tool       Deconvolution tool: `"mobster"`, `"pyclonevi"`, `"ctree"`,
#'   or `"viber"`.
#' @param sample     Sample name.
#'
#' @return Named list of file paths.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_subclonal("SPN01", 100, 0.9, "mutect2", "ascat", "mobster", "SPN01_1")
#' }
get_tumourevo_subclonal <- function(spn, coverage, purity, vcf_caller, cna_caller,
                                    tool, sample) {
  tool_list <- c("mobster", "pyclonevi", "ctree", "viber")
  if (!(tool %in% tool_list))
    stop("'tool' must be one of: ", paste(tool_list, collapse = ", "), call. = FALSE)

  main_path <- file.path(
    .te_dir(spn, coverage, purity, vcf_caller, cna_caller),
    "subclonal_deconvolution", tool, "SCOUT", spn
  )

  if (tool == "ctree") {
    if (sample != spn) main_path <- file.path(main_path, paste0(spn, "_", sample))
    output <- .te_named_files(main_path)
    nms    <- names(output)
    nms    <- sub(".*?(ctree.*|REPORT.*)", "\\1", nms)
    nms    <- paste0(nms, "_", tools::file_ext(unlist(output)))
    stats::setNames(output, nms)

  } else if (tool == "mobster") {
    main_path <- file.path(main_path, paste0(spn, "_", sample))
    output    <- .te_named_files(main_path)
    nms       <- names(output)
    nms       <- sub(".*?(mobsterh.*|REPORT.*)", "\\1", nms)
    nms       <- paste0(nms, "_", tools::file_ext(unlist(output)))
    stats::setNames(output, nms)

  } else {
    .te_normalise(.te_named_files(main_path))
  }
}

#' Get tumourevo QC result paths
#'
#' @param spn        SPN identifier.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity (0–1).
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param tool       QC tool: `"cnaqc"`, `"join_cnaqc"`, or `"tinc"`.
#' @param sample     Sample name.
#'
#' @return Named list of file paths.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_qc("SPN01", 100, 0.9, "mutect2", "ascat", "cnaqc", "SPN01_1")
#' }
get_tumourevo_qc <- function(spn, coverage, purity, vcf_caller, cna_caller,
                              tool, sample) {
  tool_list <- c("cnaqc", "join_cnaqc", "tinc")
  if (!(tool %in% tool_list))
    stop("'tool' must be one of: ", paste(tool_list, collapse = ", "), call. = FALSE)

  main_path <- file.path(
    .te_dir(spn, coverage, purity, vcf_caller, cna_caller),
    "qc", tool, "SCOUT", spn
  )

  if (tool != "join_cnaqc") {
    all_dirs     <- list.dirs(main_path, full.names = FALSE, recursive = FALSE)
    matching_dir <- all_dirs[grepl(sample, all_dirs)]
    main_path    <- file.path(main_path, matching_dir)
    .te_normalise(.te_named_files(main_path),
                  prefix_pattern = "^SCOUT_SPN\\d+_SPN\\d+_SPN\\d+_\\d+\\.\\d+_")
  } else {
    .te_normalise(.te_named_files(main_path))
  }
}

#' Get tumourevo signature deconvolution result paths
#'
#' @param spn        SPN identifier.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity (0–1).
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param tool       Signature tool: `"sigprofiler"`, `"sparsesignatures"`, or
#'   `"BASCULE"`.
#' @param context    Mutational context, e.g. `"SBS96"` or `"ID83"`. Required
#'   for `tool = "sigprofiler"`.
#'
#' @return Named list of file paths.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_signatures("SPN01", 100, 0.9, "mutect2", "ascat", "BASCULE")
#' get_tumourevo_signatures("SPN01", 100, 0.9, "mutect2", "ascat", "sigprofiler", "SBS96")
#' }
get_tumourevo_signatures <- function(spn, coverage, purity, vcf_caller, cna_caller,
                                     tool, context = NULL) {
  tool_list <- c("sigprofiler", "sparsesignatures", "BASCULE")
  if (!(tool %in% tool_list))
    stop("'tool' must be one of: ", paste(tool_list, collapse = ", "), call. = FALSE)

  main_path <- file.path(
    .te_dir(spn, coverage, purity, vcf_caller, cna_caller),
    "signature_deconvolution"
  )

  if (tool == "sigprofiler") {
    if (is.null(context))
      stop("'context' is required for sigprofiler (e.g. 'SBS96')", call. = FALSE)
    sig_class      <- gsub("[[:digit:]]+", "", context)
    context_matrix <- file.path(main_path, tool, "SCOUT", "results", "output",
                                sig_class, paste0("SCOUT.", context, ".all"))
    solution_path  <- file.path(main_path, tool, "SCOUT", "results",
                                context, context, "Suggested_Solution")
    cosmic_path    <- file.path(solution_path, paste0("COSMIC_", context, "_Decomposed_Solution"))
    denovo_path    <- file.path(solution_path, paste0(context, "_De-Novo_Solution"))
    list(
      context_matrix    = context_matrix,
      COSMIC_exposure   = file.path(cosmic_path, "Activities",
                                    paste0("COSMIC_", context, "_Activities.txt")),
      COSMIC_signatures = file.path(cosmic_path, "Signatures",
                                    paste0("COSMIC_", context, "_Signatures.txt")),
      denovo_exposure   = file.path(denovo_path, "Activities",
                                    paste0(context, "_De-Novo_Activities_refit.txt")),
      denovo_signatures = file.path(denovo_path, "Signatures",
                                    paste0(context, "_De-Novo_Signatures.txt"))
    )

  } else if (tool == "sparsesignatures") {
    p <- file.path(main_path, tool, "SCOUT")
    list(
      nmf_Lasso_out      = file.path(p, "SCOUT_nmf_Lasso_out.rds"),
      cv_means_mse       = file.path(p, "SCOUT_cv_means_mse.rds"),
      best_params_config = file.path(p, "SCOUT_best_params_config.rds"),
      mut_counts         = file.path(p, "SCOUT_mut_counts.rds")
    )

  } else {
    p <- file.path(main_path, tool, "SCOUT")
    list(
      refined_fit = file.path(p, "bascule_refined_fit.rds"),
      base_fit    = file.path(p, "bascule_fit.rds")
    )
  }
}
