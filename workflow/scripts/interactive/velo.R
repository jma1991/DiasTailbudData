#!/usr/bin/env Rscript

# TODO: Implement RNA velocity plot for iSEE


Velocity <- function(x, row.names, col.names, ) {

    
    
    
    plt <- ggplot(dat, aes(UMAP.1, UMAP.2, colour = Pseudotime)) + 
        geom_point() +
        scale_colour_viridis_c(name = "Pseudotime") +
        
        geom_segment(
            data = vec,
            mapping = aes(x = start.UMAP.1, y = start.UMAP.2, xend = end.UMAP.1, yend = end.UMAP.2),
            arrow = arrow(length = unit(0.02, "inches"), type = "closed"),
            inherit.aes = FALSE,
        ) +
        labs(x = "UMAP 1", y = "UMAP 2") +
        theme_bw() +
        theme(aspect.ratio = 1)






    print(plt)

}