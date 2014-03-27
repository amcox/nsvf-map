label_wrap_gen <- function(width = 25) {
    function(variable, value) {
      lapply(strwrap(as.character(value), width=width, simplify=FALSE), 
            paste, collapse="\n")
    }
}