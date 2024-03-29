% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flm_test.R
\name{flm_test}
\alias{flm_test}
\title{Goodness-of-fit test for functional linear models}
\usage{
flm_test(X, Y, beta0 = NULL, B = 500, est_method = "fpcr", p = NULL,
  q = NULL, thre_p = 0.99, thre_q = 0.99, lambda = NULL,
  boot_scores = TRUE, verbose = TRUE, plot_dens = TRUE,
  plot_proc = TRUE, plot_max_procs = 100, plot_max_p = 2,
  plot_max_q = 2, save_fit_flm = TRUE, save_boot_stats = TRUE,
  int_rule = "trapezoid", refit_lambda = FALSE, ...)
}
\arguments{
\item{X, Y}{samples of functional/scalar predictors and functional/scalar
response. Either \code{\link[fda.usc]{fdata}} objects (for functional
variables) or vectors of length \code{n} (for scalar variables).}

\item{beta0}{if provided (defaults to \code{NULL}), the \emph{simple} null
hypothesis \eqn{H_0: m = m_{\beta_0}} is tested. \code{beta0} must be a
matrix of size\cr \code{c(length(X$argvals), length(Y$argvals))}. If \code{X}
or \code{Y} are scalar, \code{beta0} can be also an
\code{\link[fda.usc]{fdata}} object, with the same \code{argvals} as
\code{X} or \code{Y}. Can also be a constant (understood as a shorthand for
a matrix with \emph{all} its entries equal to the constant).}

\item{B}{number of bootstrap replicates. Defaults to \code{500}.}

\item{est_method}{either \code{"fpcr"} (Functional Principal Components
Regression; FPCR), \code{"fpcr_l2"} (FPCR with ridge penalty),
\code{"fpcr_l1"} (FPCR with lasso penalty) or \code{"fpcr_l1s"}
(FPCR with lasso-selected FPC). If \code{X} is scalar, \code{flm_est}
only considers \code{"fpcr"} as estimation method. See details below.
Defaults to \code{"fpcr_l1s"}.}

\item{p, q}{either index vectors indicating the specific FPC to be
considered for the truncated bases expansions of \code{X} and \code{Y},
respectively. If a single number for \code{p} is provided, then
\code{p <- 1:max(p)} internally (analogously for \code{q}) and the first
\code{max(p)} FPC are considered. If \code{NULL} (default), then a
data-driven selection of \code{p} and \code{q} is done. See details below.}

\item{thre_p, thre_q}{thresholds for the \emph{proportion} of variance
that is explained, \emph{at least}, by the first \eqn{p} and \eqn{q} FPC
of \code{X} and \code{Y}, respectively. These thresholds are employed
for an (initial) automatic selection of \eqn{p} and \eqn{q}.
Default to \code{0.99}. \code{thre_p} (\code{thre_q}) is ignored if
\code{p} (\code{q}) is provided.}

\item{lambda}{regularization parameter \eqn{\lambda} for the estimation
methods \code{"fpcr_l2"}, \code{"fpcr_l1"}, and \code{"fpcr_l1s"}. If
\code{NULL} (default), it is chosen with \code{\link[goffda]{cv_glmnet}}.}

\item{boot_scores}{flag to indicate if the bootstrap shall be applied to the
scores of the residuals, rather than to the functional residuals. This
improves the computational expediency notably. Defaults to \code{TRUE}.}

\item{verbose}{flag to show information about the testing progress. Defaults
to \code{TRUE}.}

\item{plot_dens}{flag to indicate if a kernel density estimation of the
bootstrap statistics shall be plotted. Defaults to \code{TRUE}.}

\item{plot_proc}{whether to display a graphical tool to identify the
degree of departure from the null hypothesis. If \code{TRUE} (default),
the residual marked empirical process, projected in several FPC directions
of \code{X} and \code{Y}, is shown, together with bootstrap analogues.
The FPC directions are ones selected at the estimation stage.}

\item{plot_max_procs}{maximum number of bootstrapped processes to plot in
the graphical tool. Set as the minimum of \code{plot_max_procs} and \code{B}.
Defaults to \code{100}.}

\item{plot_max_p, plot_max_q}{maximum number of FPC directions to be
considered in the graphical tool. They limit the resulting plot to be at
most of size \code{c(plot_max_p, plot_max_q)}. Default to \code{2}.}

\item{save_fit_flm, save_boot_stats}{flag to return \code{fit_flm} and
\code{boot_*}. If \code{FALSE}, these memory-expensive objects
are set to \code{NA}. Default to \code{TRUE}.}

\item{int_rule}{quadrature rule for approximating the definite
unidimensional integral: trapezoidal rule (\code{int_rule = "trapezoid"})
and extended Simpson rule (\code{int_rule = "Simpson"}) are available.
Defaults to \code{"trapezoid"}.}

\item{refit_lambda}{flag to reselect \eqn{lambda} in each bootstrap
replicate, incorporating its variability in the bootstrap calibration.
Much more time consumig. Defaults to \code{FALSE}.}

\item{...}{further parameters to be passed to \code{\link{cv_glmnet}}
(and then to \code{\link[glmnet]{cv.glmnet}}) such as \code{cv_1se},
\code{cv_nlambda} or \code{cv_parallel}, among others.}
}
\value{
An object of the \code{htest} class with the following elements:
\item{statistic}{test statistic.}
\item{p.value}{\eqn{p}-value of the test.}
\item{boot_statistics}{the bootstrapped test statistics, a vector
of length \code{B}.}
\item{method}{information on the type of test performed.}
\item{parameter}{a vector with the dimensions \eqn{p} and \eqn{q}
considered in the test statistic. These are the lengths of the outputs
\code{p} and \code{q}.}
\item{p}{the index of the FPC considered for \code{X}.}
\item{q}{the index of the FPC considered for \code{Y}.}
\item{fit_flm}{the output resulted from calling \code{\link{flm_est}}.}
\item{boot_lambda}{bootstrapped \eqn{lambda}.}
\item{boot_p}{a list with the bootstrapped indexes of the FPC considered
for \code{X}.}
\item{data.name}{name of the value of \code{data}.}
}
\description{
Goodness-of-fit test of a functional linear model with
functional response \eqn{Y \in L^2([c, d])} and functional predictor
\eqn{X \in L^2([a, b])}, where \eqn{L^2([a, b])} is the Hilbert space of
square-integrable functions in \eqn{[a, b]}.

The goodness-of-fit test checks the \emph{linearity} of the regression model
\eqn{m:L^2([a, b])\rightarrow L^2([c, d])} that relates \eqn{Y} and \eqn{X}
by
\deqn{Y(t) = m(X) + \varepsilon(t),}{Y(t) = m(X)(t) + \epsilon(t),}
where \eqn{\varepsilon}{\epsilon} is a random variable in
\eqn{L^2([c, d])} and \eqn{t \in [c, d]}. The check is formalized as the
test of the composite hypothesis
\deqn{H_0: m \in \{m_\beta : \beta \in L^2([a, b]) \otimes L^2([c, d])\},}{
H_0: m \in {m_\beta : \beta \in L^2([a, b]) \otimes L^2([c, d])},}
where
\deqn{m_\beta(X(s))(t) = \int_a^b \beta(s, t) X(s)\,\mathrm{d}s}{
m_\beta(X(s))(t) = \int_a^b \beta(s, t) X(s) ds}
is the linear, Hilbert--Schmidt, integral operator parametrized by
the bivariate kernel \eqn{\beta}. Its estimation is done by the
truncated expansion of \eqn{\beta} in the tensor product of the
data-driven bases of \emph{Functional Principal Components} (FPC) of
\eqn{X} and \eqn{Y}. The FPC basis for \eqn{X} is truncated in \eqn{p}
components, while the FPC basis for \eqn{Y} is truncated in \eqn{q}
components.

The particular cases in which either \eqn{X} or \eqn{Y} are
\emph{constant} functions give either a scalar predictor or response.
The simple linear model arises if both \eqn{X} and \eqn{Y} are scalar,
for which \eqn{\beta} is a constant.
}
\details{
The function implements the bootstrap-based goodness-of-fit test for
the functional linear model with functional/scalar response and
functional/scalar predictor, as described in Algorithm 1 in
García-Portugués et al. (2021). The specifics are detailed there.

By default \code{cv_1se = TRUE} for \code{\link{cv_glmnet}} is
considered, unless it is changed via \code{...}. This is the recommended
choice for conducting the goodness-of-fit test based on regularized
estimators, as the oversmoothed estimate of the regression model under the
null hypothesis notably facilitates the calibration of the test (see
García-Portugués et al., 2021).

The graphical tool obtained with \code{plot_proc = TRUE} is based on
an extension of the tool described in García-Portugués et al. (2014).

Repeated observations on \code{X} are internally removed, as otherwise they
would cause \code{NaN}s in \code{Adot}. Missing values on \code{X} and
\code{Y} are also automatically removed.
}
\examples{
## Quick example for functional response and predictor

# Generate data under H0
n <- 100
set.seed(987654321)
X_fdata <- r_ou(n = n, t = seq(0, 1, l = 101), sigma = 2)
epsilon <- r_ou(n = n, t = seq(0, 1, l = 101), sigma = 0.5)
Y_fdata <- epsilon

# Test the FLMFR
flm_test(X = X_fdata, Y = Y_fdata)

# Simple hypothesis
flm_test(X = X_fdata, Y = Y_fdata, beta0 = 0)

# Generate data under H1
n <- 100
set.seed(987654321)
sample_frm_fr <- r_frm_fr(n = n, scenario = 3, s = seq(0, 1, l = 101),
                          t = seq(0, 1, l = 101), nonlinear = "quadratic")
X_fdata <- sample_frm_fr[["X_fdata"]]
Y_fdata <- sample_frm_fr[["Y_fdata"]]

# Test the FLMFR
flm_test(X = X_fdata, Y = Y_fdata)
\donttest{
## Functional response and predictor

# Generate data under H0
n <- 50
B <- 100
set.seed(987654321)
t <- seq(0, 1, l = 201)
X_fdata <- r_ou(n = n, t = t, sigma = 2)
epsilon <- r_ou(n = n, t = t, sigma = 0.5)
Y_fdata <- epsilon

# With boot_scores = TRUE
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr", B = B)
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr_l2", B = B)
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr_l1s", B = B)

# With boot_scores = FALSE
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr_l2",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr_l1",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr_l1s",
         boot_scores = FALSE, B = B)

# Simple hypothesis
flm_test(X = X_fdata, Y = Y_fdata, beta0 = 2, est_method = "fpcr", B = B)
flm_test(X = X_fdata, Y = Y_fdata, beta0 = 0, est_method = "fpcr", B = B)
flm_test(X = X_fdata, Y = Y_fdata, beta0 = 0, est_method = "fpcr_l1s", B = B)

# Generate data under H1
n <- 50
B <- 100
set.seed(987654321)
sample_frm_fr <- r_frm_fr(n = n, scenario = 3, s = t, t = t,
                          nonlinear = "quadratic")
X_fdata <- sample_frm_fr$X_fdata
Y_fdata <- sample_frm_fr$Y_fdata

# With boot_scores = TRUE
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr", B = B)
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr_l2", B = B)
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr_l1s", B = B)

# With boot_scores = FALSE
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr_l2",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr_l1",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y_fdata, est_method = "fpcr_l1s",
         boot_scores = FALSE, B = B)

## Scalar response and functional predictor

# Generate data under H0
n <- 50
B <- 100
set.seed(987654321)
t <- seq(0, 1, l = 201)
X_fdata <- r_ou(n = n, t = t, sigma = 2)
beta <- r_ou(n = 1, t = t, sigma = 0.5, x0 = 2)
epsilon <- rnorm(n = n)
Y <- drop(inprod_fdata(X_fdata1 = X_fdata, X_fdata2 = beta) + epsilon)

# With boot_scores = TRUE
flm_test(X = X_fdata, Y = Y, est_method = "fpcr", B = B)
flm_test(X = X_fdata, Y = Y, est_method = "fpcr_l2", B = B)
flm_test(X = X_fdata, Y = Y, est_method = "fpcr_l1s", B = B)

# With boot_scores = FALSE
flm_test(X = X_fdata, Y = Y, est_method = "fpcr",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y, est_method = "fpcr_l2",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y, est_method = "fpcr_l1",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y, est_method = "fpcr_l1s",
         boot_scores = FALSE, B = B)

# Simple hypothesis
flm_test(X = X_fdata, Y = Y, beta0 = beta, est_method = "fpcr", B = B)
flm_test(X = X_fdata, Y = Y, beta0 = 0, est_method = "fpcr", B = B)
flm_test(X = X_fdata, Y = Y, beta0 = 0, est_method = "fpcr_l1s", B = B)

# Generate data under H1
n <- 50
B <- 100
set.seed(987654321)
X_fdata <- r_ou(n = n, t = t, sigma = 2)
beta <- r_ou(n = 1, t = t, sigma = 0.5)
epsilon <- rnorm(n = n)
Y <- drop(exp(inprod_fdata(X_fdata1 = X_fdata^2, X_fdata2 = beta)) + epsilon)

# With boot_scores = TRUE
flm_test(X = X_fdata, Y = Y, est_method = "fpcr", B = B)
flm_test(X = X_fdata, Y = Y, est_method = "fpcr_l2", B = B)
flm_test(X = X_fdata, Y = Y, est_method = "fpcr_l1s", B = B)

# With boot_scores = FALSE
flm_test(X = X_fdata, Y = Y, est_method = "fpcr",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y, est_method = "fpcr_l2",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y, est_method = "fpcr_l1",
         boot_scores = FALSE, B = B)
flm_test(X = X_fdata, Y = Y, est_method = "fpcr_l1s",
         boot_scores = FALSE, B = B)

## Functional response and scalar predictor

# Generate data under H0
n <- 50
B <- 100
set.seed(987654321)
X <- rnorm(n)
t <- seq(0, 1, l = 201)
beta <- r_ou(n = 1, t = t, sigma = 0.5, x0 = 3)
beta$data <- matrix(beta$data, nrow = n, ncol = ncol(beta$data),
                    byrow = TRUE)
epsilon <- r_ou(n = n, t = t, sigma = 0.5)
Y_fdata <- X * beta + epsilon

# With boot_scores = TRUE
flm_test(X = X, Y = Y_fdata, est_method = "fpcr", B = B)

# With boot_scores = FALSE
flm_test(X = X, Y = Y_fdata, est_method = "fpcr", boot_scores = FALSE, B = B)

# Simple hypothesis
flm_test(X = X, Y = Y_fdata, beta0 = beta[1], est_method = "fpcr", B = B)
flm_test(X = X, Y = Y_fdata, beta0 = 0, est_method = "fpcr", B = B)

# Generate data under H1
n <- 50
B <- 100
set.seed(987654321)
X <- rexp(n)
beta <- r_ou(n = 1, t = t, sigma = 0.5, x0 = 3)
beta$data <- matrix(beta$data, nrow = n, ncol = ncol(beta$data),
                    byrow = TRUE)
epsilon <- r_ou(n = n, t = t, sigma = 0.5)
Y_fdata <- log(X * beta) + epsilon

# With boot_scores = TRUE
flm_test(X = X, Y = Y_fdata, est_method = "fpcr", B = B)

# With boot_scores = FALSE
flm_test(X = X, Y = Y_fdata, est_method = "fpcr", boot_scores = FALSE, B = B)
}
}
\references{
García-Portugués, E., Álvarez-Liébana, J., Álvarez-Pérez, G. and
Gonzalez-Manteiga, W. (2021). A goodness-of-fit test for the functional
linear model with functional response. \emph{Scandinavian Journal of
Statistics}, 48(2):502--528. \doi{10.1111/sjos.12486}

García-Portugués, E., González-Manteiga, W. and Febrero-Bande, M. (2014). A
goodness-of-fit test for the functional linear model with scalar response.
\emph{Journal of Computational and Graphical Statistics}, 23(3):761--778.
\doi{10.1080/10618600.2013.812519}
}
\author{
Eduardo García-Portugués.
}
