// generated with brms 2.23.0
functions {
}
data {
  int<lower=1> N;  // total number of observations
  int<lower=1> N_aux1;  // number of observations
  vector[N_aux1] Y_aux1;  // response variable
  int<lower=1> K_aux1;  // number of population-level effects
  matrix[N_aux1, K_aux1] X_aux1;  // population-level design matrix
  int<lower=1> Kc_aux1;  // number of population-level effects after centering
  int<lower=1> Ksp_aux1;  // number of special effects terms
  int<lower=1> N_aux2;  // number of observations
  vector[N_aux2] Y_aux2;  // response variable
  int<lower=1> K_aux2;  // number of population-level effects
  matrix[N_aux2, K_aux2] X_aux2;  // population-level design matrix
  int<lower=1> Kc_aux2;  // number of population-level effects after centering
  int<lower=1> Ksp_aux2;  // number of special effects terms
  int<lower=1> N_aux3;  // number of observations
  vector[N_aux3] Y_aux3;  // response variable
  int<lower=1> K_aux3;  // number of population-level effects
  matrix[N_aux3, K_aux3] X_aux3;  // population-level design matrix
  int<lower=1> Kc_aux3;  // number of population-level effects after centering
  int<lower=1> Ksp_aux3;  // number of special effects terms
  int<lower=1> N_y2;  // number of observations
  vector[N_y2] Y_y2;  // response variable
  int<lower=1> K_y2;  // number of population-level effects
  matrix[N_y2, K_y2] X_y2;  // population-level design matrix
  int<lower=1> Kc_y2;  // number of population-level effects after centering
  int<lower=1> Ksp_y2;  // number of special effects terms
  // covariates of special effects terms
  vector[N_y2] Csp_y2_1;
  vector[N_y2] Csp_y2_2;
  vector[N_y2] Csp_y2_3;
  int<lower=1> N_y1z;  // number of observations
  vector[N_y1z] Y_y1z;  // response variable
  int<lower=0> Nmi_y1z;  // number of missings
  array[Nmi_y1z] int<lower=1> Jmi_y1z;  // positions of missings
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
  matrix[N_aux1, Kc_aux1] Xc_aux1;  // centered version of X_aux1 without an intercept
  vector[Kc_aux1] means_X_aux1;  // column means of X_aux1 before centering
  matrix[N_aux2, Kc_aux2] Xc_aux2;  // centered version of X_aux2 without an intercept
  vector[Kc_aux2] means_X_aux2;  // column means of X_aux2 before centering
  matrix[N_aux3, Kc_aux3] Xc_aux3;  // centered version of X_aux3 without an intercept
  vector[Kc_aux3] means_X_aux3;  // column means of X_aux3 before centering
  matrix[N_y2, Kc_y2] Xc_y2;  // centered version of X_y2 without an intercept
  vector[Kc_y2] means_X_y2;  // column means of X_y2 before centering
  for (i in 2:K_aux1) {
    means_X_aux1[i - 1] = mean(X_aux1[, i]);
    Xc_aux1[, i - 1] = X_aux1[, i] - means_X_aux1[i - 1];
  }
  for (i in 2:K_aux2) {
    means_X_aux2[i - 1] = mean(X_aux2[, i]);
    Xc_aux2[, i - 1] = X_aux2[, i] - means_X_aux2[i - 1];
  }
  for (i in 2:K_aux3) {
    means_X_aux3[i - 1] = mean(X_aux3[, i]);
    Xc_aux3[, i - 1] = X_aux3[, i] - means_X_aux3[i - 1];
  }
  for (i in 2:K_y2) {
    means_X_y2[i - 1] = mean(X_y2[, i]);
    Xc_y2[, i - 1] = X_y2[, i] - means_X_y2[i - 1];
  }
}
parameters {
  vector[Kc_aux1] b_aux1;  // regression coefficients
  real Intercept_aux1;  // temporary intercept for centered predictors
  vector[Ksp_aux1] bsp_aux1;  // special effects coefficients
  real<lower=0> sigma_aux1;  // dispersion parameter
  vector[Kc_aux2] b_aux2;  // regression coefficients
  real Intercept_aux2;  // temporary intercept for centered predictors
  vector[Ksp_aux2] bsp_aux2;  // special effects coefficients
  real<lower=0> sigma_aux2;  // dispersion parameter
  vector[Kc_aux3] b_aux3;  // regression coefficients
  real Intercept_aux3;  // temporary intercept for centered predictors
  vector[Ksp_aux3] bsp_aux3;  // special effects coefficients
  real<lower=0> sigma_aux3;  // dispersion parameter
  vector[Kc_y2] b_y2;  // regression coefficients
  real Intercept_y2;  // temporary intercept for centered predictors
  vector[Ksp_y2] bsp_y2;  // special effects coefficients
  real<lower=0> sigma_y2;  // dispersion parameter
  vector[Nmi_y1z] Ymi_y1z;  // estimated missings
  real Intercept_y1z;  // temporary intercept for centered predictors
  real<lower=0> sigma_y1z;  // dispersion parameter
}
transformed parameters {
  // prior contributions to the log posterior
  real lprior = 0;
  lprior += student_t_lpdf(Intercept_aux1 | 3, -0.1, 2.5);
  lprior += student_t_lpdf(sigma_aux1 | 3, 0, 2.5)
    - 1 * student_t_lccdf(0 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_aux2 | 3, 0.3, 2.5);
  lprior += student_t_lpdf(sigma_aux2 | 3, 0, 2.5)
    - 1 * student_t_lccdf(0 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_aux3 | 3, 0, 2.5);
  lprior += student_t_lpdf(sigma_aux3 | 3, 0, 2.5)
    - 1 * student_t_lccdf(0 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_y2 | 3, 0.2, 2.5);
  lprior += student_t_lpdf(sigma_y2 | 3, 0, 2.5)
    - 1 * student_t_lccdf(0 | 3, 0, 2.5);
  lprior += student_t_lpdf(Intercept_y1z | 3, 0, 2.5);
  lprior += student_t_lpdf(sigma_y1z | 3, 0, 2.5)
    - 1 * student_t_lccdf(0 | 3, 0, 2.5);
}
model {
  // likelihood including constants
  if (!prior_only) {
    // vector combining observed and missing responses
    vector[N_y1z] Yl_y1z = Y_y1z;
    // initialize linear predictor term
    vector[N_aux1] mu_aux1 = rep_vector(0.0, N_aux1);
    // initialize linear predictor term
    vector[N_aux2] mu_aux2 = rep_vector(0.0, N_aux2);
    // initialize linear predictor term
    vector[N_aux3] mu_aux3 = rep_vector(0.0, N_aux3);
    // initialize linear predictor term
    vector[N_y2] mu_y2 = rep_vector(0.0, N_y2);
    // initialize linear predictor term
    vector[N_y1z] mu_y1z = rep_vector(0.0, N_y1z);
    Yl_y1z[Jmi_y1z] = Ymi_y1z;
    mu_aux1 += Intercept_aux1;
    mu_aux2 += Intercept_aux2;
    mu_aux3 += Intercept_aux3;
    mu_y2 += Intercept_y2;
    mu_y1z += Intercept_y1z;
    for (n in 1:N_aux1) {
      // add more terms to the linear predictor
      mu_aux1[n] += (bsp_aux1[1]) * Yl_y1z[n];
    }
    for (n in 1:N_aux2) {
      // add more terms to the linear predictor
      mu_aux2[n] += (bsp_aux2[1]) * Yl_y1z[n];
    }
    for (n in 1:N_aux3) {
      // add more terms to the linear predictor
      mu_aux3[n] += (bsp_aux3[1]) * Yl_y1z[n];
    }
    for (n in 1:N_y2) {
      // add more terms to the linear predictor
      mu_y2[n] += (bsp_y2[1]) * Yl_y1z[n] + (bsp_y2[2]) * Yl_y1z[n] * Csp_y2_1[n] + (bsp_y2[3]) * Yl_y1z[n] * Csp_y2_2[n] + (bsp_y2[4]) * Yl_y1z[n] * Csp_y2_3[n];
    }
    target += normal_id_glm_lpdf(Y_aux1 | Xc_aux1, mu_aux1, b_aux1, sigma_aux1);
    target += normal_id_glm_lpdf(Y_aux2 | Xc_aux2, mu_aux2, b_aux2, sigma_aux2);
    target += normal_id_glm_lpdf(Y_aux3 | Xc_aux3, mu_aux3, b_aux3, sigma_aux3);
    target += normal_id_glm_lpdf(Y_y2 | Xc_y2, mu_y2, b_y2, sigma_y2);
    target += normal_lpdf(Yl_y1z | mu_y1z, sigma_y1z);
  }
  // priors including constants
  target += lprior;
}
generated quantities {
  // actual population-level intercept
  real b_aux1_Intercept = Intercept_aux1 - dot_product(means_X_aux1, b_aux1);
  // actual population-level intercept
  real b_aux2_Intercept = Intercept_aux2 - dot_product(means_X_aux2, b_aux2);
  // actual population-level intercept
  real b_aux3_Intercept = Intercept_aux3 - dot_product(means_X_aux3, b_aux3);
  // actual population-level intercept
  real b_y2_Intercept = Intercept_y2 - dot_product(means_X_y2, b_y2);
  // actual population-level intercept
  real b_y1z_Intercept = Intercept_y1z;
}
