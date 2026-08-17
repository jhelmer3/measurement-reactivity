
fit_and_tidy_one <- function(data, params, compiled_brms_model) {
  browser()
  methods <- list(
    lm_between = \() lm(y2_between ~ treatment, data = data),
    lm_pretest = \() lm(y2_pretest ~ treatment * y1_z, data = data),
    lm_true = \() lm(y2 ~ treatment * pretest * y1_z, data = data),
    fiml = \() fiml_model(data),
    mi = \() mi_model(data),
    brms = \() brms_model(data, compiled_brms_model)
  )
  
  imap(methods, \(method_fit_function, method_name) {
    result <- method_fit_function()
    tidied <- tidy_one_result(result, params, method_name) 
    rm(result)
    tidied
  }) |>
    list_rbind()
}

