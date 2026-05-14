
define_params <- function(param_set) {
  return(
    do.call(crossing, param_set) |>
      mutate(beta4 = -0.75 * beta1,
             .after = beta3) |>
      mutate(cohens_d = beta1 / sigma)
  )
}

# define_params(param_set, here::here("param_key.csv"))


