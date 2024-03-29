% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{ontario}
\alias{ontario}
\title{Ontario temperature and electricity consumption during 2010--2014}
\format{
A list with the following entries:
\describe{
  \item{temp}{an \code{\link[fda.usc]{fdata}} with 368 smoothed
  daily temperature (in Celsius degrees) curves of the Ontario province,
  discretized on 73 equispaced grid points on \eqn{[-24, 48]}
  (see examples).}
  \item{elec}{an \code{\link[fda.usc]{fdata}} with the daily
  electricity consumption (in gigawatts) curves of the Ontario province.
  Discretized on 25 equispaced grid points on \eqn{[0, 24]}.}
  \item{df}{a dataframe with time metadata for each curve:
  \itemize{
    \item{\code{date}: the date of the observation, a \code{\link{POSIXct}}
    object.}
    \item{\code{weekday}: the weekday of the observation.}
  }}
}
}
\source{
The dataset comes from the companion data to Benatia et al. (2017), which
was retrieved from the \href{https://www.davidbenatia.com/publication/}{
first author's website}. The source of the electricity consumption data is
the \href{https://www.ieso.ca/}{System operator's website}. The source
of the preprocessed temperature values is the
\href{https://climat.meteo.gc.ca/}{Environment Canada's website}.
}
\usage{
ontario
}
\description{
Real dataset employed Benatia et al. (2017). Contains the
hourly electricity consumption and air temperature curves in the province
of Ontario (Canada). It features a set of daily curves during the summer
months of 2010--2014.
}
\details{
The summer months correspond to June 1st to September 15th. Weekend days and
holidays are disregarded.

The smoothed temperature curves are constructed by a weighted average of
the temperatures of 41 Ontarian cities that is afterwards smoothed with
a local polynomial regression. The curves correspond to a 3-days window
of the temperature (see examples). The temperature is standardized such
that its original minimum, 6 ºC, is subtracted.

The electricity consumption curves are discretized on the interval
\eqn{[0, 24]}. That means that the last observation of the
\eqn{i}-th curve is the same as the first observation of the
\eqn{(i + 1)}-th curve \emph{if} the curves correspond to consecutive days.

See more details about the construction of the dataset in Benatia et al.
(2017).
}
\examples{
## Show data

# Load data
data("ontario")

# Plot
old_par <- par(mfrow = c(1, 2))
plot(ontario$temp)
plot(ontario$elec)
par(old_par)

# Observe the 3-day windows for each observation
plot(ontario$temp$argvals, ontario$temp$data[2, ], type = "o",
     xlim = c(-48, 72), ylim = c(7, 13), xlab = "Hours",
     ylab = "Electricity consumption", pch = 16)
points(ontario$temp$argvals - 24, ontario$temp$data[1, ], col = 3, pch = 2)
points(ontario$temp$argvals + 24, ontario$temp$data[3, ], col = 2, cex = 1.5)
abline(v = 24 * -2:3, lty = 2)
legend("top", legend = c("Curve 1", "Curve 2", "Curve 3"), col = c(3, 1, 2),
       pt.cex = c(1, 1, 1.5), pch = c(2, 16, 1))

# If the days are not consecutive, then the electricity consumptions at the
# end of one day and the beginning of the next do not match
head(abs(ontario$elec$data[-368, 25] - ontario$elec$data[-1, 1]))
head(diff(ontario$df$date))
\donttest{
## Test the linear model with functional response and predictor

(comp_flmfr <- flm_test(X = ontario$temp, Y = ontario$elec,
                        est_method = "fpcr_l1s"))
(simp_flmfr <- flm_test(X = ontario$temp, Y = ontario$elec,
                        beta0 = 0, est_method = "fpcr_l1s"))

# Visualize estimation
filled.contour(x = ontario$temp$argvals, y = ontario$elec$argvals,
               z = comp_flmfr$fit_flm$Beta_hat,
               color.palette = viridisLite::viridis, nlevels = 20)
}
}
\references{
Benatia, D., Carrasco, M. and Florens, J. P. (2017) Functional linear
regression with functional response. \emph{Journal of Econometrics},
201(2):269--291. \doi{10.1016/j.jeconom.2017.08.008}
}
\author{
Data gathered and processed by David Benatia, Marine Carrasco, and
Jean-Pierre Florens. Javier Álvarez-Liébana and Eduardo García-Portugués
imported the dataset and added temporal metadata.
}
\keyword{datasets}
