# heteroplasmy

Using the Kimura distribution to explore mtDNA selection, and heteroplasmy statistics to estimate bottleneck size, can lead to substantial issues in interpretation. In particular, the established fitting approach for the Kimura distribution -- using mean and variance statistics -- almost always gives a bad fit to the distribution. Suggestions of selection based on the badness of the fit cannot then be supported. There are also some issues with estimating errors on heteroplasmy statistics using this approach. This package attempts to help by providing a set of tools for better fitting and more robust interpretation. If you use it and/or these ideas, please cite the Giannakis et al. paper [1] https://doi.org/10.1093/g3journal/jkad068.

`heteroplasmy` is an R package to explore different fits to the Kimura distribution using mtDNA heteroplasmy data, and estimate the standard error of the variance (and other quantities related to uncertainty estimation). Its original home is https://github.com/kostasgian21/heteroplasmy ; there is a fork at https://github.com/StochasticBiology/heteroplasmy-analysis where some ongoing development and applications will be implemented. This repo also contains R scripts that use the package to produce plots illustrating some issues with heteroplasmy fitting and analysis. These scripts are `kimura-issues-package.R` and `kimura-plots-package.R`.

To install the `heteroplasmy` package you will need the `devtools` R library. If you have this, you can ignore the first line below.

```
install.packages("devtools")
library("devtools")
devtools::install_github("kostasgian21/heteroplasmy")
```

If you face problems with using devtools to isnstall libraries from github, you can do it directly by using the remotes library.

```
# install.packages("remotes")
remotes::install_github("kostasgian21/heteroplasmy")
```


You can then load the `heteroplasmy` package with

`library("heteroplasmy")`

The documentation is currently incomplete but we are working on it; please contact us if you have any questions!

The code relies on the `kimura` package https://github.com/lbozhilova/kimura for the numerical calculation of various quantities related to the Kimura distribution. A paper describing the approach and the issue it resolves is here [1] . The scripts `kimura-issues-package.R` and `kimura-plots-package.R` respectively demonstrate the scientific and statistical issues outlined there, and produce the plots used in that report. As of February 2023 these have been updated to address peer reviewer comments on the manuscript.

Test case
------

Here is a simple test case demonstrating an issue with using moments to fit the Kimura distribution:

```
library(kimura)
library(heteroplasmy)

# synthetic data
h = rep(c(0, 0.9), 4)
# fit Kimura distribution using moments and perform Monte Carlo Kolmogorov-Smirnov test (p < 0.05)
test_kimura(h, num_MC = 10000)

# fit distribution by minimising KS distance
ks.fit = estimate_parameters_ks(h)
# perform test using these parameters (p >> 0.05)
test_kimura_par(h, ks.fit[1], ks.fit[2], num_MC = 10000)

# fit distribution via maximum likelihood instead
# [1] 0.3044296 0.3364191
# (i.e. p = 0.304, b = 0.336)
estimate_parameters_ml(h)
```

References
----

[1] Giannakis, K., Broz, A.K., Sloan, D.B. and Johnston, I.G., 2023. Avoiding misleading estimates using mtDNA heteroplasmy statistics to study bottleneck size and selection. G3: Genes, Genomes, Genetics, 13(6), p.jkad068.
