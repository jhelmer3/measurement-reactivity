init_method_levels <- function() {
  tibble(method = c("lm_true", "lm_between", "lm_pretest", "fiml", "mi", "brms") |>
           factor(levels = c("lm_true", "lm_between", "lm_pretest", "fiml", "mi", "brms")),
         label = c("true", "between", "pretest", "fiml", "mi", "brms"),
         color = c("#D4A8BC", "#A4BFD9", "#88AB7B", "#d29979", "#b39eb5", "#9DC3C1"))
}
