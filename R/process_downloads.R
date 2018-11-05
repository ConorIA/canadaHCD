##' @importFrom utils txtProgressBar setTxtProgressBar
##' @importFrom parallel detectCores makePSOCKcluster parLapply stopCluster
##' @importFrom pbapply pblapply

`process_downloads` <- function(urls, progress = TRUE, ...) {

    cl <- makePSOCKcluster(detectCores() - 1)
    sdata <- if (isTRUE(progress)) {
        pblapply(X = urls, FUN = get_hcd_from_url, ..., cl = cl)
    } else {
        parLapply(cl = cl, X = urls, fun = get_hcd_from_url, ...)
    }
    stopCluster(cl = cl)
    
    sdata
}
