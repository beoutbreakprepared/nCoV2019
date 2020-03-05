#' -----------------------------------------------------------------------------
#' This script looks at the cleaned data sets and prints a table describing the
#' proportion records where each variable has a known value.
#'
#' -----------------------------------------------------------------------------
#' Usage:
#'
#' $ Rscript src/completeness-tables.R
#'
#' -----------------------------------------------------------------------------
#' ChangeLog:
#'
#' - 05-03-20
#'   + Initial draft.
#'
#' -----------------------------------------------------------------------------

source("src/tools.cleaner.R")


prop_complete_func <- function(x) {
    function(n) {
        1 - .prop_literal_na(x[,n])
    }
}

dataset_1_name <- "data/clean-hubei.csv"
d1 <- read.csv(dataset_1_name)
d1$dataset <- dataset_1_name
prop_complete_d1 <- prop_complete_func(d1)

dataset_2_name <- "data/clean-outside-hubei.csv"
d2 <- read.csv(dataset_2_name)
d2$dataset <- dataset_2_name
prop_complete_d2 <- prop_complete_func(d2)


var_names <- names(d1)
if (!all(names(d1) == names(d2))) {
    print(setdiff(names(d1), names(d2)))
    print(setdiff(names(d2), names(d1)))
    stop()
}

cat("| Variable | Proportion Complete | Dataset |\n")
cat("|----------|---------------------|---------|\n")
for (n in var_names) {
    cat(sprintf("| \`%s\`| %f | \`%s\` |\n", n, prop_complete_d1(n), dataset_1_name))
    cat(sprintf("| \`%s\`| %f | \`%s\` |\n", n, prop_complete_d2(n), dataset_2_name))
}

