#' @title Display q-value object
#'
#' @description
#' Display summary information for a q-value object.
#'
#' @param object A q-value object.
#' @param cuts Vector of significance values to use for table (optional).
#' @param digits Significant digits to display (optional).
#' @param \ldots Additional arguments; currently unused.
#'
#' @details
#' \code{summary} shows the original call, estimated proportion of
#' true null hypotheses, and a table comparing the number of significant calls
#' for the p-values, estimated q-values, and estimated local FDR values using a set of
#' cutoffs given by \code{cuts}.
#'
#' @return
#' Invisibly returns the original object.
#'
#' @references
#' Storey JD. (2002) A direct approach to false discovery rates. Journal
#' of the Royal Statistical Society, Series B, 64: 479-498. \cr
#' \url{http://onlinelibrary.wiley.com/doi/10.1111/1467-9868.00346/abstract}
#'
#' Storey JD and Tibshirani R. (2003) Statistical significance for
#' genome-wide experiments. Proceedings of the National Academy of Sciences,
#' 100: 9440-9445. \cr
#' \url{http://www.pnas.org/content/100/16/9440.full}
#'
#' Storey JD. (2003) The positive false discovery rate: A Bayesian
#' interpretation and the q-value. Annals of Statistics, 31: 2013-2035. \cr
#' \url{http://projecteuclid.org/DPubS/Repository/1.0/Disseminate?view=body&id=pdf_1&handle=euclid.aos/1074290335}
#'
#' Storey JD, Taylor JE, and Siegmund D. (2004) Strong control,
#' conservative point estimation, and simultaneous conservative
#' consistency of false discovery rates: A unified approach. Journal of
#' the Royal Statistical Society, Series B, 66: 187-205. \cr
#' \url{http://onlinelibrary.wiley.com/doi/10.1111/j.1467-9868.2004.00439.x/abstract}
#'
#' Storey JD. (2011) False discovery rates. In \emph{International Encyclopedia of Statistical Science}. \cr
#' \url{http://genomine.org/papers/Storey_FDR_2011.pdf} \cr
#' \url{http://www.springer.com/statistics/book/978-3-642-04897-5}
#'
#' @examples
#' # import data
#' data(hedenfalk)
#' p <- hedenfalk$p
#'
#' # get summary results from q-value object
#' qobj <- qvalue(p)
#' summary(qobj, cuts=c(0.01, 0.05))
#'
#' @author John D. Storey, Andrew J. Bass, Alan Dabney
#' @keywords summary
#' @aliases summary, summary.qvalue
#' @seealso \code{\link{qvalue}}, \code{\link{plot.qvalue}}, \code{\link{write.qvalue}}
#' @export
summary.qvalue <- function (object, cuts = c(0.0001, 0.001, 0.01, 0.025, 0.05, 0.10, 1), digits = getOption("digits"), ...) {
  # Call
  cat("\nCall:\n", deparse(object$call), "\n\n", sep = "")
  # Proportion of nulls
  cat("pi0:", format(object$pi0, digits=digits), "\n", sep="\t")
  cat("\n")
  # Number of significant values for p-value, q-value and local FDR
  cat("Cumulative number of significant calls:\n")
  cat("\n")
  rm_na <- !is.na(object$pvalues)
  pvalues <- object$pvalues[rm_na]
  qvalues <- object$qvalues[rm_na]
  lfdr <- object$lfdr[rm_na]
  counts <- sapply(cuts, function(x) c("p-value"=sum(pvalues < x),
                  "q-value"=sum(qvalues < x),
                  "local FDR"=sum(lfdr < x)))
  colnames(counts) <- paste("<", cuts, sep="")
  print(counts)
  cat("\n")
}
