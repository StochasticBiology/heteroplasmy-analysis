library(ggplot2)
library(gridExtra)
library(metR)
library(kimura)
library(heteroplasmy)

# problem 1
# Broz data
h = c(91,0,0,100,0,0,0,0,95,100,92,100,98,0,0,0,91,0,0,0,0,94.2,0,0)/100

hbar = mean(h)
s2 = var(h)
n = length(h)

nhat = hbar*(1-hbar)/s2
nhat

# synthetic data
h = c(0,1)
hbar = mean(h)
s2 = var(h)
n = length(h)

nhat = hbar*(1-hbar)/s2
nhat

h0 = 0.1
s2 = sum((h-h0)**2)/(n-1)
s2

nhat = h0*(1-h0)/s2
nhat

# problem 2
# Freyer data for h < 0.6
h = c(0.73,0.69,0.68,0.77,0.34,0.58,0.00,0.69,0.57,0.64,0.75,0.39,0.22,0.87,0.74,0.75,0.31,0.78,0.54,0.66,0.63,0.53,0.62,0.54,0.66,0.71,0.75,0.62,0.69,0.75,0.27,0.64,0.81,0.63,0.61,0.7,0.52,0.5,0.28,0.45,0.80,0.69,0.66,0.67,0.6,0.73,0.45,0.54,0.62,0.68,0.64,0.51,0.64,0.38,0.45,0.65,0.67,0.62,0.76,0.67,0.44,0.63,0.85,0.75,0.73,0.72,0.67,0.17,0.73,0.73,0.71,0.79,0.67,0.66,0.72,0.47,0.62,0.7,0.62,0.57,0.7,0.61,0.62,0.6,0.61,0.54,0.62,0.45,0.3,0.56,0.53,0.53)
# MoM KS fit
test_kimura(h, num_MC = 10000, round=F)
# min KS KS fit
ks.fit = estimate_parameters_ks(h)
test_kimura_par(h, ks.fit[1], ks.fit[2], num_MC = 10000, round=F)

# synthetic data
h = rep(c(0, 0.9), 4)
# MoM KS fit
test_kimura(h, num_MC = 10000, round=F)
# min KS KS fit
ks.fit = estimate_parameters_ks(h)
test_kimura_par(h, ks.fit[1], ks.fit[2], num_MC = 10000,round=F)

# extension of problem 1 -- bad parameter estimates for WCS-K

h = c(0,1)
mom.fit = estimate_parameters(h)
mom.fit
p = mom.fit[1]
b = mom.fit[2]

# max lik solution

h = c(0,1)
estimate_parameters_ml(h)

best = optim(c(0.5, 0.5), kimura_neg_loglik, h=h, h0=F, hessian=T)

best$b.hat = transfun(best$par[1])
best$h0.hat = transfun(best$par[2])

# for Broz data
h = c(91,0,0,100,0,0,0,0,95,100,92,100,98,0,0,0,91,0,0,0,0,94.2,0,0)/100
best = optim(c(0.5, 0.5), kimura_neg_loglik, h = h, h0 = h0, hessian = T)
best$b.hat = transfun(best$par[1])
best$b.lo = transfun(best$par[1] - 1.96*sqrt(1/best$hessian[1,1]))
best$b.hi = transfun(best$par[1] + 1.96*sqrt(1/best$hessian[1,1]))
best$n.hat = 1/(1-best$b.hat)
best$n.lo = 1/(1-best$b.lo)
best$n.hi = 1/(1-best$b.hi)
best$h0.hat = transfun(best$par[2])

# LRT

h1 = list( c(0.2,0.4), c(0.6,0.7) )
h2 = list( c(0.1,0.7), c(0.3,1.0) )
kimura_lrt(h1, h2)
