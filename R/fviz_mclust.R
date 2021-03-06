#' Plot Model-Based Clustering Results using ggplot2
#' @description Plots the classification, the uncertainty and the BIC values returned by the Mclust() function.
#' @inheritParams ggpubr::ggpar
#' @inheritParams fviz_cluster
#' @param object an object of class Mclust
#' @param what choose from one of the following three options: "classification" (default), "uncertainty" and "BIC".
#' @param shape point shape. To change point shape by model names use shape = "model".
#' @param color point and line color.
#' @param ... other arguments to be passed to the functions \link{fviz_cluster} and \link[ggpubr]{ggpar}.
#' 
#' @examples
#' 
#' if(require("mclust")){
#' 
#' # Compute model-based-clustering 
#' require("mclust")
#' data("diabetes")
#' mc <- Mclust(diabetes[, -1])
#' 
#' # Visaulize BIC values
#' fviz_mclust_bic(mc)
#' 
#' # Visualize classification
#' fviz_mclust(mc, "classification", geom = "point")
#' }
#' 
#' @describeIn fviz_mclust Plots classification and uncertainty.
#' @export
fviz_mclust <- function(object, 
                        what = c("classification", "uncertainty", "BIC"),
                        ellipse.type = "norm", ellipse.level = 0.4, 
                        ggtheme = theme_classic(), ...)
{
  uncertainty <- cluster <- NULL
  what <- match.arg(what)
  if(what == "classification")
    p <- fviz_cluster(object, ellipse.type = ellipse.type, ellipse.level =ellipse.level,
                      ggtheme = theme_classic(), ...)+
    labs(subtitle = "Classification")
  if(what == "uncertainty")
    p <- fviz_cluster(object, ellipse.type = ellipse.type, ellipse.level =ellipse.level,
                      ggtheme = theme_classic(), geom = "none", ...)+
    geom_point(aes(size = uncertainty, color = cluster))+
    scale_size(range =c(0, 2))+
    labs(subtitle = "Uncertainty")+
    guides(size = FALSE)
  else if(what == "BIC") p <- fviz_mclust_bic(object, ggtheme = theme_classic(),  ...)
  
  return(p)
}


#' @describeIn fviz_mclust Plots the BIC values.
#' @param model.names one or more model names corresponding to models fit in object. The default
#'   is to plot the BIC for all of the models fit.
#' @export
fviz_mclust_bic <- function(object, model.names = NULL, shape = 19, color = "model",
                            palette = NULL, legend = NULL,
                            main = "Model selection", xlab = "Number of components", ylab = "BIC", ...){
  if(!inherits(object, "Mclust"))
    stop("An object of class Mclust is required.")
  
  best_model <- object$modelName
  number_of_cluster <- object$G
  x <- object$BIC
  
  # Convert to a data frame
  n <- ncol(x)
  dnx <- dimnames(x)
  x <- matrix(as.vector(x), ncol = n)
  dimnames(x) <- dnx
  x <- as.data.frame(x)
  if (is.null(model.names)) 
    model.names <- dimnames(x)[[2]]
  x <- x[, model.names, drop = FALSE]
  # Add number of clusters
  x <- cbind.data.frame(cluster = rownames(x), x)
  x <- tidyr::gather_(x, key_col = "model", value_col = "BIC", 
                       gather_cols = colnames(x)[-1])
  x <- x[!is.na(x$BIC), , drop = FALSE]
  x$model <- factor(x$model, levels = dnx[[2]])
  
  if(ggpubr:::.is_col_palette(palette)) palette <- ggpubr:::.get_pal(palette, k = length(model.names))
  p <- ggpubr::ggline(x, x ="cluster", y = "BIC", group = "model",
                 color = color, shape = shape, palette = palette,
                 main = main, xlab = xlab, ylab = ylab,...)+
    labs(subtitle = paste0("Best model: ", best_model, 
                           " | Optimal clusters: n = ",  number_of_cluster))+
    geom_vline(xintercept = number_of_cluster, linetype = 2, color = "red")+
    theme(legend.title = element_blank())

  
  if(missing(legend)) p + theme(legend.position = c(0.7, 0.2), legend.direction = "horizontal",
                                legend.key.height = unit(0.5, "line"))+
    guides(color = guide_legend(nrow=5,byrow=TRUE))
  else p + theme(legend.position = legend)
}


