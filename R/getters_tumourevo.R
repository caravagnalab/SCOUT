# ── tumourevo getters ─────────────────────────────────────────────────────────
# Archive structure after extraction:
#   <cache>/<spn>/purity_<p>/tumourevo/<spn>/tumourevo/<cov>x_<p>p_<vcf>_<cna>/
#                                                       driver_annotation/...
#                                                       formatter/...
#                                                       qc/...
#                                                       signature_deconvolution/...
#                                                       subclonal_deconvolution/...
#                                                       variant_annotation/...

.te_base <- function(spn, purity) {
  file.path(.scout_cache_dir(spn, purity), "tumourevo", spn, "tumourevo")
}

.te_dir <- function(spn, coverage, purity, vcf_caller, cna_caller) {
  vcf_callers <- c("mutect2", "strelka")
  cna_callers <- c("ascat", "sequenza")

  if (!is.numeric(coverage) || coverage %% 1 != 0)
    stop("'coverage' must be an integer", call. = FALSE)
  if (!is.numeric(purity) || purity > 1 || purity < 0)
    stop("'purity' must be a number between 0 and 1", call. = FALSE)
  if (!(vcf_caller %in% vcf_callers))
    stop("'vcf_caller' must be one of: ",
         paste(vcf_callers, collapse = ", "), call. = FALSE)
  if (!(cna_caller %in% cna_callers))
    stop("'cna_caller' must be one of: ",
         paste(cna_callers, collapse = ", "), call. = FALSE)

  ptr <- paste(paste0(coverage, "x"), paste0(purity, "p"),
               vcf_caller, cna_caller, sep = "_")
  file.path(.te_base(spn, purity), ptr)
}

# Sample directory name inside tumourevo: e.g. "SPN04_SPN04_1.1"
.te_sample_dir <- function(spn, sample) {
  paste(spn, sample, sep = "_")
}

.te_named_files <- function(dir_path) {
  files <- list.files(dir_path, full.names = TRUE)
  files <- files[!file.info(files)$isdir]
  stats::setNames(as.list(files),
                  tools::file_path_sans_ext(basename(files)))
}

.te_normalise <- function(input_list,
                           prefix_pattern = paste0("^SCOUT_SPN\\d+_")) {
  stats::setNames(
    input_list,
    lapply(names(input_list), function(nm) {
      gsub("\\.", "_", sub(prefix_pattern, "", nm))
    })
  )
}

# ── Formatter ─────────────────────────────────────────────────────────────────

#' Get tumourevo formatted SNV (vcf2cnaqc) file paths
#'
#' @param spn        SPN identifier, e.g. `"SPN01"`.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param sample     Sample name, e.g. `"SPN04_1.1"`. If `NULL`, returns paths
#'   for all samples.
#'
#' @return Named list of file paths to SNV RDS files.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_snv("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")
#' }
get_tumourevo_snv <- function(spn, coverage, purity, vcf_caller, cna_caller,
                               sample = NULL) {
  base <- file.path(.te_dir(spn, coverage, purity, vcf_caller, cna_caller),
                    "formatter/vcf2cnaqc/SCOUT", spn)
  .te_sample_files(base, spn, sample)
}

#' Get tumourevo formatted CNA (cna2cnaqc) file paths
#'
#' @param spn        SPN identifier, e.g. `"SPN01"`.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param sample     Sample name. If `NULL`, returns paths for all samples.
#'
#' @return Named list of file paths to CNA RDS files.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_cna("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")
#' }
get_tumourevo_cna <- function(spn, coverage, purity, vcf_caller, cna_caller,
                               sample = NULL) {
  base <- file.path(.te_dir(spn, coverage, purity, vcf_caller, cna_caller),
                    "formatter/cna2cnaqc/SCOUT", spn)
  .te_sample_files(base, spn, sample)
}

#' Get tumourevo joint CNAqc table (cnaqc2tsv)
#'
#' @param spn        SPN identifier, e.g. `"SPN01"`.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#'
#' @return Path to the joint table TSV file.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_joint_table("SPN04", 50, 0.6, "mutect2", "sequenza")
#' }
get_tumourevo_joint_table <- function(spn, coverage, purity,
                                       vcf_caller, cna_caller) {
  path <- file.path(.te_dir(spn, coverage, purity, vcf_caller, cna_caller),
                    "formatter/cnaqc2tsv/SCOUT", spn,
                    paste0("SCOUT_", spn, "_joint_table.tsv"))
  if (!file.exists(path))
    stop("Joint table not found: ", path, call. = FALSE)
  path
}

# ── Variant annotation ────────────────────────────────────────────────────────

#' Get tumourevo VEP annotated VCF file paths
#'
#' @param spn        SPN identifier, e.g. `"SPN01"`.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param sample     Sample name. If `NULL`, returns paths for all samples.
#'
#' @return Named list of file paths to annotated VCF files.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_vep("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")
#' }
get_tumourevo_vep <- function(spn, coverage, purity, vcf_caller, cna_caller,
                               sample = NULL) {
  base <- file.path(.te_dir(spn, coverage, purity, vcf_caller, cna_caller),
                    "variant_annotation/vep/SCOUT", spn)
  .te_sample_files(base, spn, sample)
}

# ── Driver annotation ─────────────────────────────────────────────────────────

#' Get tumourevo driver annotation file paths
#'
#' @param spn        SPN identifier, e.g. `"SPN01"`.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param sample     Sample name. If `NULL`, returns paths for all samples.
#'
#' @return Named list of file paths to driver RDS files.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_driver("SPN04", 50, 0.6, "mutect2", "sequenza", "SPN04_1.1")
#' }
get_tumourevo_driver <- function(spn, coverage, purity, vcf_caller, cna_caller,
                                  sample = NULL) {
  base <- file.path(.te_dir(spn, coverage, purity, vcf_caller, cna_caller),
                    "driver_annotation/annotate_driver/SCOUT", spn)
  .te_sample_files(base, spn, sample)
}

# ── QC ────────────────────────────────────────────────────────────────────────

#' Get tumourevo QC result paths
#'
#' @param spn        SPN identifier.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param tool       QC tool: `"cnaqc"`, `"join_cnaqc"`, or `"tinc"`.
#' @param sample     Sample name. Required for `"cnaqc"` and `"tinc"`.
#'
#' @return Named list of file paths.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_qc("SPN04", 50, 0.6, "mutect2", "sequenza", "cnaqc", "SPN04_1.1")
#' get_tumourevo_qc("SPN04", 50, 0.6, "mutect2", "sequenza", "join_cnaqc")
#' }
get_tumourevo_qc <- function(spn, coverage, purity, vcf_caller, cna_caller,
                              tool, sample = NULL) {
  tool_list <- c("cnaqc", "join_cnaqc", "tinc")
  if (!(tool %in% tool_list))
    stop("'tool' must be one of: ", paste(tool_list, collapse = ", "),
         call. = FALSE)

  base <- file.path(.te_dir(spn, coverage, purity, vcf_caller, cna_caller),
                    "qc", tool, "SCOUT", spn)

  if (tool == "join_cnaqc") {
    .te_normalise(.te_named_files(base))
  } else {
    if (is.null(sample))
      stop("'sample' is required for tool = '", tool, "'", call. = FALSE)
    path <- file.path(base, .te_sample_dir(spn, sample))
    .te_normalise(.te_named_files(path),
                  prefix_pattern = paste0("^SCOUT_", spn, "_", spn, "_",
                                          spn, "_[0-9.]+_"))
  }
}

# ── Subclonal deconvolution ───────────────────────────────────────────────────

#' Get tumourevo subclonal deconvolution result paths
#'
#' @param spn        SPN identifier.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param tool       Tool: `"mobster"`, `"pyclonevi"`, `"ctree"`, or `"viber"`.
#' @param sample     Sample name. Required for `"mobster"` and per-sample
#'   `"ctree"` results.
#'
#' @return Named list of file paths.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_subclonal("SPN04", 50, 0.6, "mutect2", "sequenza",
#'                          "mobster", "SPN04_1.1")
#' get_tumourevo_subclonal("SPN04", 50, 0.6, "mutect2", "sequenza", "viber")
#' }
get_tumourevo_subclonal <- function(spn, coverage, purity, vcf_caller,
                                     cna_caller, tool, sample = NULL) {
  tool_list <- c("mobster", "pyclonevi", "ctree", "viber")
  if (!(tool %in% tool_list))
    stop("'tool' must be one of: ", paste(tool_list, collapse = ", "),
         call. = FALSE)

  base <- file.path(.te_dir(spn, coverage, purity, vcf_caller, cna_caller),
                    "subclonal_deconvolution", tool, "SCOUT", spn)

  if (tool == "mobster") {
    if (is.null(sample))
      stop("'sample' is required for tool = 'mobster'", call. = FALSE)
    path <- file.path(base, .te_sample_dir(spn, sample))
    .te_normalise(.te_named_files(path))
  } else if (tool == "ctree") {
    if (!is.null(sample)) {
      path <- file.path(base, .te_sample_dir(spn, sample))
      .te_normalise(.te_named_files(path))
    } else {
      .te_normalise(.te_named_files(base))
    }
  } else {
    .te_normalise(.te_named_files(base))
  }
}

# ── Signature deconvolution ───────────────────────────────────────────────────

#' Get tumourevo signature deconvolution result paths
#'
#' @param spn        SPN identifier.
#' @param coverage   Sequencing coverage (integer).
#' @param purity     Sample purity: `0.9`, `0.6`, or `0.3`.
#' @param vcf_caller VCF caller: `"mutect2"` or `"strelka"`.
#' @param cna_caller CNA caller: `"ascat"` or `"sequenza"`.
#' @param tool       Tool: `"sigprofiler"`, `"sparsesignatures"`, or
#'   `"BASCULE"`.
#' @param context    Mutational context, e.g. `"SBS96"`, `"ID83"`, `"DBS78"`.
#'   Required for `tool = "sigprofiler"`.
#'
#' @return Named list of file paths.
#' @export
#'
#' @examples
#' \dontrun{
#' get_tumourevo_signatures("SPN04", 50, 0.6, "mutect2", "sequenza", "BASCULE")
#' get_tumourevo_signatures("SPN04", 50, 0.6, "mutect2", "sequenza",
#'                           "sigprofiler", context = "SBS96")
#' }
get_tumourevo_signatures <- function(spn, coverage, purity, vcf_caller,
                                      cna_caller, tool, context = NULL) {
  tool_list <- c("sigprofiler", "sparsesignatures", "BASCULE")
  if (!(tool %in% tool_list))
    stop("'tool' must be one of: ", paste(tool_list, collapse = ", "),
         call. = FALSE)

  base <- file.path(.te_dir(spn, coverage, purity, vcf_caller, cna_caller),
                    "signature_deconvolution")

  if (tool == "sigprofiler") {
    if (is.null(context))
      stop("'context' is required for sigprofiler (e.g. 'SBS96')",
           call. = FALSE)
    sig_class     <- gsub("[[:digit:]]+", "", context)
    results_path  <- file.path(base, tool, "SCOUT", "results")
    solution_path <- file.path(results_path, context, context,
                               "Suggested_Solution")
    cosmic_path   <- file.path(solution_path,
                               paste0("COSMIC_", context, "_Decomposed_Solution"))
    denovo_path   <- file.path(solution_path,
                               paste0(context, "_De-Novo_Solution"))
    list(
      context_matrix    = file.path(results_path, "output", sig_class,
                                    paste0("SCOUT.", context, ".all")),
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
    p <- file.path(base, tool, "SCOUT")
    list(
      nmf_Lasso_out      = file.path(p, "SCOUT_nmf_Lasso_out.rds"),
      cv_means_mse       = file.path(p, "SCOUT_cv_means_mse.rds"),
      best_params_config = file.path(p, "SCOUT_best_params_config.rds"),
      mut_counts         = file.path(p, "SCOUT_mut_counts.rds")
    )

  } else {
    p <- file.path(base, tool, "SCOUT")
    list(
      refined_fit = file.path(p, "bascule_refined_fit.rds"),
      base_fit    = file.path(p, "bascule_fit.rds")
    )
  }
}

# ── Internal helpers ──────────────────────────────────────────────────────────

# List files for one sample directory, or all sample directories if sample=NULL
.te_sample_files <- function(base, spn, sample) {
  if (!is.null(sample)) {
    path <- file.path(base, .te_sample_dir(spn, sample))
    return(.te_normalise(.te_named_files(path)))
  }
  dirs <- list.dirs(base, full.names = TRUE, recursive = FALSE)
  unlist(lapply(dirs, function(d) {
    .te_normalise(.te_named_files(d))
  }), recursive = FALSE)
}
