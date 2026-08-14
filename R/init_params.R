
init_params <- function(n_reps) {
  beta1 = .3 # treatment
  beta2 = .2 # pretest elicitation
  beta3 = 1 # y1 score
  
  return(
    list(
      n_reps = n_reps,
      N = 200,
      K = 3,
      r2_aux = .33,
      p_pretest = .4,
      p_treatment = .5,
      beta0 = 0, # intercept
      beta1 = beta1, # treatment
      beta2 = beta2, # pretest elicitation
      beta3 = beta3, # y1 score
      beta4 = c(-.75, 0, .75) * beta1, # beta4 defined as a function of beta1 in define_params(), treatment * pretest
      beta5 = c(-.75, 0, .75) * beta1, # y1 * treatment
      beta6 = c(-.75, 0, .75) * beta3, # y1 * pretest
      beta7 = 0, # y1 * treatment * pretest
      sigma = 1
    )
  )
}

