
init_params_tidy_key <- function() {
  return(
    tibble::tribble(~ param_label, ~ tidy_label,
                    "beta0", "(Intercept)",
                    "beta1", "treatment",
                    "beta2", "pretest",
                    "beta3", "y1_z",
                    "beta4", "treatment:pretest",
                    "beta5", "y1_z:treatment",
                    "beta6", "y1_z:pretest",
                    "beta7", "y1_z:treatment:pretest",
                    "cohens_d", "cohens_d",
                    "sigma", "sigma")
  )
}
