
simulate_over_conditions <- function(params) {
  
  sim_data <- params |>
      pmap(
        \(...) tibble(...) |>
          # repeats each set of parameters for each replication
          uncount(rep) |>
          mutate(rep = row_number()) |>
          generate_data() |>
          fit_models() |>
          tidy_models()
      )
  
  sim_data
}

# tar_read(params) |>
#   simulate_over_conditions() |>
#   map(fit_models)

# tar_read(params) |>
#   pmap(
#     \(...) tibble(...) |>
#       # repeats each set of parameters for each replication
#       uncount(rep) |>
#       mutate(rep = row_number()) |>
#       generate_data()
#   )
# 
# 
# 
# 
# simulate_over_conditions <- function(params) {
#   return(
#     params |>
#       pmap(
#         \(...) tibble(...) |>
#           # repeats each set of parameters for each replication
#           uncount(rep) |>
#           mutate(rep = row_number()) |>
#           pmap(\(...) tibble::tibble(...) |>
#                           generate_data()
#           ) |>
#           list_rbind() |>
#           fit_models() |>
#           tidy_models()
#       )
#   )
# }


