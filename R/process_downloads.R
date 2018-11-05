##' @importFrom utils txtProgressBar setTxtProgressBar
##' @importFrom parallel detectCores makePSOCKcluster parLapply stopCluster
##' @importFrom pbapply pblapply
##' @importFrom rappdirs user_cache_dir
##' @importFrom storr storr_external driver_rds driver_environment

`process_downloads` <- function(keys, progress = TRUE, cache = FALSE, ...) {

    st_driver <- if (isTRUE(cache)) driver_rds(user_cache_dir("canadaHCD")) else driver_environment()
    st <- storr_external(st_driver, fetch_hook_hcd)
    
    cl <- makePSOCKcluster(detectCores() - 1)
    sdata <- if (isTRUE(progress)) {
        pblapply(X = keys, FUN = st$get, cl = cl)
    } else {
        parLapply(cl = cl, X = keys, fun = st$get)
    }
    stopCluster(cl = cl)
    
    sdata
}
