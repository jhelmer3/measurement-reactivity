
define_params <- function(param_set) {
  return(
    do.call(crossing, param_set) |>
      mutate(cohens_d = beta1 / sigma) |>
      mutate(condition_id = row_number(),
             .before = everything())
  )
}

# do.call(crossing, tar_read(param_set))
# 
# tar_read(param_set)
#   define_params() |> View()


# define_params(param_set, here::here("param_key.csv"))


