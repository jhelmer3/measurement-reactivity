
brms_model <- function(data, compiled_brms_model, chains = 4, iter = 2000) {
  brms_data <- data |>
    unnest(aux) |>
    mutate(y1_z = ifelse(pretest == 1, y1_z, NA))
  
  update(compiled_brms_model,
         newdata = brms_data,
         silent = TRUE,
         chains = chains,
         iter = iter)
}

# data <- tar_read(params) |>
#   generate_data() |>
#   pluck("data", 1) |>
#   unnest(aux) |>
#   mutate(y1_z = ifelse(pretest == 1, y1_z, NA))
# 
# brms_frm <- bf(aux1 ~ aux2 + aux3 + y2 + mi(y1_z)) + 
#   bf(aux2 ~ aux3 + y2 + mi(y1_z)) + 
#   bf(aux3 ~ y2 + mi(y1_z)) + 
#   bf(y2 ~  treatment * pretest * mi(y1_z)) + 
#   bf(y1_z | mi() ~ 1) +
#   set_rescor(FALSE)
# 
# brm1 <- brm(brms_frm, data, 
#             save_model = "brms_model.stan",
#             silent = TRUE)
# 
# # default_prior(bf_compiled, data = data)
# 
# data |>
#   pluck("data", 1) |>
#   unnest(aux)
# 
# bf_compiled
# 
# brm1 <- brm(bform, df_ml_brm, 
#             save_model = "main_effect_model.stan",
#             silent = TRUE)
# 
# brm1 <- 
# 
# sumb1 <- summary(brm1)
