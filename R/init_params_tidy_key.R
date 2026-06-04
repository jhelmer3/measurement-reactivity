
init_params_tidy_key <- function() {
  return(
    tibble::tribble(~ param_label, ~ tidy_label,
                    "beta0", "(Intercept)",
                    "beta1", "treatment",
                    "beta2", "pretest",
                    "beta3", "y1_z",
                    "beta4", "treatment:pretest",
                    "beta5", "treatment:y1_z",
                    "beta6", "pretest:y1_z",
                    "beta7", "treatment:pretest:y1_z",
                    "cohens_d", "cohens_d",
                    "sigma", "sigma")
  )
}
