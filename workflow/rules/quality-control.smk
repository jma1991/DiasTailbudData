# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule perCellQCMetrics:
    input:
        rds = "analysis/droplet-processing/filterByDrops.rds",
        txt = expand("resources/subsets/{subset}.txt", subset = config["perCellQCMetrics"]["subsets"])
    output:
        rds = "analysis/quality-control/perCellQCMetrics.rds"
    log:
        out = "analysis/quality-control/perCellQCMetrics.out",
        err = "analysis/quality-control/perCellQCMetrics.err"
    message:
        "[Quality Control] Compute per-cell quality control metrics"
    script:
        "../scripts/quality-control/perCellQCMetrics.R"

rule quickPerCellQC:
    input:
        rds = "analysis/quality-control/perCellQCMetrics.rds"
    output:
        rds = "analysis/quality-control/quickPerCellQC.rds"
    params:
        subsets = config["quickPerCellQC"]["subsets"],
        nmads = config["quickPerCellQC"]["nmads"]
    log:
        out = "analysis/quality-control/quickPerCellQC.out",
        err = "analysis/quality-control/quickPerCellQC.err"
    message:
        "[Quality Control] Identify low-quality cells based on frequently used QC metrics"
    script:
        "../scripts/quality-control/quickPerCellQC.R"

rule plotCellQCMetrics_sum:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "analysis/quality-control/plotCellQCMetrics.sum.pdf"
    log:
        out = "analysis/quality-control/plotCellQCMetrics.sum.out",
        err = "analysis/quality-control/plotCellQCMetrics.sum.err"
    message:
        "[Quality Control] Plot the sum of counts for each cell"
    script:
        "../scripts/quality-control/plotCellQCMetrics.sum.R"

rule plotCellQCMetrics_detected:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "analysis/quality-control/plotCellQCMetrics.detected.pdf"
    log:
        out = "analysis/quality-control/plotCellQCMetrics.detected.out",
        err = "analysis/quality-control/plotCellQCMetrics.detected.err"
    message:
        "[Quality Control] Plot the number of observations above detection limit"
    script:
        "../scripts/quality-control/plotCellQCMetrics.detected.R"

rule plotCellQCMetrics_MT:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "analysis/quality-control/plotCellQCMetrics.MT.pdf"
    log:
        out = "analysis/quality-control/plotCellQCMetrics.MT.out",
        err = "analysis/quality-control/plotCellQCMetrics.MT.err"
    message:
        "[Quality Control] Plot the proportion of mitochondrial counts"
    script:
        "../scripts/quality-control/plotCellQCMetrics.MT.R"

rule plotCellQCMetrics_sum_MT:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "analysis/quality-control/plotCellQCMetrics.sum.MT.pdf"
    log:
        out = "analysis/quality-control/plotCellQCMetrics.sum.MT.out",
        err = "analysis/quality-control/plotCellQCMetrics.sum.MT.err"
    message:
        "[Quality Control] Plot the sum of counts for each cell against the proportion of mitochondrial counts"
    script:
        "../scripts/quality-control/plotCellQCMetrics.sum.MT.R"

rule plotCellQCMetrics_sum_detected:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "analysis/quality-control/plotCellQCMetrics.sum.detected.pdf"
    log:
        out = "analysis/quality-control/plotCellQCMetrics.sum.detected.out",
        err = "analysis/quality-control/plotCellQCMetrics.sum.detected.err"
    message:
        "[Quality Control] Plot the sum of counts for each cell against the number of observations above detection limit"
    script:
        "../scripts/quality-control/plotCellQCMetrics.sum.detected.R"

rule filterCellsByQC:
    input:
        rds = ["analysis/droplet-processing/filterByDrops.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        rds = "analysis/quality-control/filterCellsByQC.rds"
    log:
        out = "analysis/quality-control/filterCellsByQC.out",
        err = "analysis/quality-control/filterCellsByQC.err"
    message:
        "[Quality Control] Filter low-quality cells"
    script:
        "../scripts/quality-control/filterCellsByQC.R"

rule perFeatureQCMetrics:
    input:
        rds = "analysis/quality-control/filterCellsByQC.rds"
    output:
        rds = "analysis/quality-control/perFeatureQCMetrics.rds"
    log:
        out = "analysis/quality-control/perFeatureQCMetrics.out",
        err = "analysis/quality-control/perFeatureQCMetrics.err"
    message:
        "[Quality Control] Compute per-feature quality control metrics"
    script:
        "../scripts/quality-control/perFeatureQCMetrics.R"

rule plotFeatureQCMetrics_mean:
    input:
        rds = "analysis/quality-control/perFeatureQCMetrics.rds"
    output:
        pdf = "analysis/quality-control/plotFeatureQCMetrics.mean.pdf"
    log:
        out = "analysis/quality-control/plotFeatureQCMetrics.mean.out",
        err = "analysis/quality-control/plotFeatureQCMetrics.mean.err"
    message:
        "[Quality Control] Plot the mean counts for each feature"
    script:
        "../scripts/quality-control/plotFeatureQCMetrics.mean.R"

rule plotFeatureQCMetrics_detected:
    input:
        rds = "analysis/quality-control/perFeatureQCMetrics.rds"
    output:
        pdf = "analysis/quality-control/plotFeatureQCMetrics.detected.pdf"
    log:
        out = "analysis/quality-control/plotFeatureQCMetrics.detected.out",
        err = "analysis/quality-control/plotFeatureQCMetrics.detected.err"
    message:
        "[Quality Control] Plot the percentage of observations above detection limit"
    script:
        "../scripts/quality-control/plotFeatureQCMetrics.detected.R"

rule plotMeanVsDetected:
    input:
        rds = "analysis/quality-control/perFeatureQCMetrics.rds"
    output:
        pdf = "analysis/quality-control/plotMeanVsDetected.pdf"
    params:
        n = 50
    log:
        out = "analysis/quality-control/plotMeanVsDetected.out",
        err = "analysis/quality-control/plotMeanVsDetected.err"
    message:
        "[Quality Control] Plot mean counts against number of expressed features"
    script:
        "../scripts/quality-control/plotMeanVsDetected.R"

rule plotHighestExprs:
    input:
        rds = "analysis/quality-control/filterCellsByQC.rds"
    output:
        pdf = "analysis/quality-control/plotHighestExprs.pdf"
    params:
        n = 50
    log:
        out = "analysis/quality-control/plotHighestExprs.out",
        err = "analysis/quality-control/plotHighestExprs.err"
    message:
        "[Quality Control] Plot the highest expressing features"
    script:
        "../scripts/quality-control/plotHighestExprs.R"

rule calculatePCA:
    input:
        rds = "analysis/quality-control/filterCellsByQC.rds"
    output:
        rds = "analysis/quality-control/calculatePCA.rds"
    log:
        out = "analysis/quality-control/calculatePCA.out",
        err = "analysis/quality-control/calculatePCA.err"
    message:
        "[Quality Control] Perform PCA on expression data"
    script:
        "../scripts/quality-control/calculatePCA.R"

rule calculateTSNE:
    input:
        rds = "analysis/quality-control/calculatePCA.rds"
    output:
        rds = "analysis/quality-control/calculateTSNE.rds"
    log:
        out = "analysis/quality-control/calculateTSNE.out",
        err = "analysis/quality-control/calculateTSNE.err"
    message:
        "[Quality Control] Perform TSNE on expression data"
    script:
        "../scripts/quality-control/calculateTSNE.R"

rule calculateUMAP:
    input:
        rds = "analysis/quality-control/calculatePCA.rds"
    output:
        rds = "analysis/quality-control/calculateUMAP.rds"
    log:
        out = "analysis/quality-control/calculateUMAP.out",
        err = "analysis/quality-control/calculateUMAP.err"
    message:
        "[Quality Control] Perform UMAP on expression data"
    script:
        "../scripts/quality-control/calculateUMAP.R"

rule plotPCA:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/calculatePCA.rds"]
    output:
        pdf = "analysis/quality-control/plotPCA.{metric}.pdf"
    log:
        out = "analysis/quality-control/plotPCA.{metric}.out",
        err = "analysis/quality-control/plotPCA.{metric}.err"
    message:
        "[Quality Control] Plot PCA coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/quality-control/plotPCA.R"

rule plotTSNE:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/calculateTSNE.rds"]
    output:
        pdf = "analysis/quality-control/plotTSNE.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "analysis/quality-control/plotTSNE.{metric}.out",
        err = "analysis/quality-control/plotTSNE.{metric}.err"
    message:
        "[Quality Control] Plot TSNE coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/quality-control/plotTSNE.R"

rule plotUMAP:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/calculateUMAP.rds"]
    output:
        pdf = "analysis/quality-control/plotUMAP.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "analysis/quality-control/plotUMAP.{metric}.out",
        err = "analysis/quality-control/plotUMAP.{metric}.err"
    message:
        "[Quality Control] Plot UMAP coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/quality-control/plotUMAP.R"