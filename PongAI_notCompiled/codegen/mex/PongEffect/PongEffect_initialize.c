/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * PongEffect_initialize.c
 *
 * Code generation for function 'PongEffect_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "PongEffect_mexutil.h"
#include "PongEffect.h"
#include "PongEffect_initialize.h"
#include "_coder_PongEffect_mex.h"
#include "PongEffect_data.h"

/* Function Declarations */
static void PongEffect_once(const emlrtStack *sp);

/* Function Definitions */
static void PongEffect_once(const emlrtStack *sp)
{
  int32_T i0;
  velSig = 3.0;
  velSig_dirty = 1U;
  for (i0 = 0; i0 < 7; i0++) {
    V[i0] = 1.0 + (real_T)i0;
  }

  V_dirty = 1U;
  Hn = 4.0;
  Hn_dirty = 1U;
  Ln = 2.0;
  Ln_dirty = 1U;
  b_gamma = 0.30150337950393963;
  gamma_dirty = 1U;
  alpha = 0.99501123501311761;
  alpha_dirty = 1U;
  eps = 0.99950011248500126;
  eps_dirty = 1U;
  H = 8.0;
  H_dirty = 1U;
  L = 10.0;
  L_dirty = 1U;
  beta = 0.3;
  beta_dirty = 1U;
  emlrtSetGlobalSyncFcn(sp, (void (*)(const void *))emlrt_synchGlobalsToML);
}

void PongEffect_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    PongEffect_once(&st);
  }
}

/* End of code generation (PongEffect_initialize.c) */
