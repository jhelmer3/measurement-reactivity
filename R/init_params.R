
init_params <- function(n_reps) {
  return(
    list(
      rep = n_reps,
      N = c(100, 400),
      K = 3,
      r2_aux = .33,
      p_pretest = .4,
      p_treatment = .5,
      beta0 = 0, # intercept
      beta1 = .3, # treatment
      beta2 = .2, # pretest elicitation
      beta3 = 1, # y1 score
      # beta4 defined as a function of beta1 in define_params(), treatment * pretest
      beta5 = -.1, # y1 * treatment
      beta6 = 0, # y1 * pretest
      beta7 = 0, # y1 * treatment * pretest
      sigma = 1
    )
  )
}

