# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule perCellQCMetrics:
    input:
        rds = "analysis/droplet-processing/filterByDrops.rds",
        txt = expand("resources/subsets/{subset}.txt", subset = "MT")
    output:
        rds = "analysis/quality-control/perCellQCMetrics.rds"
    log:
        out = "analysis/quality-control/perCellQCMetrics.out",
        err = "analysis/quality-control/perCellQCMetrics.err"
    message:
        "[Quality Control] Compute per-cell quality control metrics"
    script:
        "../scripts/quality-control/perCellQCMetrics.R"

rule fixedPerCellQC:
    input:
        rds = "analysis/quality-control/perCellQCMetrics.rds"
    output:
        rds = "analysis/quality-control/fixedPerCellQC.rds"
    log:
        out = "analysis/quality-control/fixedPerCellQC.out",
        err = "analysis/quality-control/fixedPerCellQC.err"
    message:
        "[Quality Control] Identify low-quality cells based on frequently defined QC metrics"
    script:
        "../scripts/quality-control/fixedPerCellQC.R"

rule quickPerCellQC:
    input:
        rds = "analysis/quality-control/perCellQCMetrics.rds"
    output:
        rds = "analysis/quality-control/quickPerCellQC.rds"
    params:
        subsets = "MT",
        nmads = 3
    log:
        out = "analysis/quality-control/quickPerCellQC.out",
        err = "analysis/quality-control/quickPerCellQC.err"
    message:
        "[Quality Control] Identify low-quality cells based on frequently used QC metrics"
    script:
        "../scripts/quality-control/quickPerCellQC.R"

rule outlyPerCellQC:
    input:
        rds = "analysis/quality-control/perCellQCMetrics.rds"
    output:
        rds = "analysis/quality-control/outlyPerCellQC.rds"
    params:
        subsets = "MT",
        nmads = 3
    log:
        out = "analysis/quality-control/outlyPerCellQC.out",
        err = "analysis/quality-control/outlyPerCellQC.err"
    message:
        "[Quality Control] Identify outliers in high-dimensional space based on frequently used QC metrics"
    script:
        "../scripts/quality-control/outlyPerCellQC.R"

rule plotColData_sum:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "analysis/quality-control/plotColData.sum.pdf"
    log:
        out = "analysis/quality-control/plotColData.sum.out",
        err = "analysis/quality-control/plotColData.sum.err"
    message:
        "[Quality Control] Plot the sum of counts for each cell"
    script:
        "../scripts/quality-control/plotColData-sum.R"

rule plotColData_detected:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "analysis/quality-control/plotColData.detected.pdf"
    log:
        out = "analysis/quality-control/plotColData.detected.out",
        err = "analysis/quality-control/plotColData.detected.err"
    message:
        "[Quality Control] Plot the number of observations above detection limit"
    script:
        "../scripts/quality-control/plotColData-detected.R"

rule plotColData_MT:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "analysis/quality-control/plotColData.subsets_MT_percent.pdf"
    log:
        out = "analysis/quality-control/plotColData.subsets_MT_percent.out",
        err = "analysis/quality-control/plotColData.subsets_MT_percent.err"
    message:
        "[Quality Control] Plot the number of observations above detection limit"
    script:
        "../scripts/quality-control/plotColData-MT.R"

rule plotColData_sum_detected:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "analysis/quality-control/plotColData-sum-detected.pdf"
    log:
        out = "analysis/quality-control/plotColData-sum-detected.out",
        err = "analysis/quality-control/plotColData-sum-detected.err"
    message:
        "[Quality control] Plot library size against number of expressed genes"
    script:
        "../scripts/quality-control/plotColData-sum-detected.R"

rule plotColData_sum_MT:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "analysis/quality-control/plotColData-sum-MT.pdf"
    log:
        out = "analysis/quality-control/plotColData-sum-MT.out",
        err = "analysis/quality-control/plotColData-sum-MT.err"
    message:
        "[Quality control] Plot library size against MT proportion"
    script:
        "../scripts/quality-control/plotColData-sum-MT.R"

rule eulerPerCellQC:
    input:
        csv = expand("analysis/quality-control/{basename}.csv", basename = ["fixedPerCellQC", "quickPerCellQC", "robustPerCellQC"])
    output:
        pdf = "analysis/quality-control/eulerPerCellQC.pdf"
    log:
        out = "analysis/quality-control/eulerPerCellQC.out",
        err = "analysis/quality-control/eulerPerCellQC.err"
    message:
        "[Quality Control] Compare low-quality cells"
    script:
        "../scripts/quality-control/eulerPerCellQC.R"

rule topTagsByQC:
    input:
        rds = "analysis/droplet-processing/filterByDrops.rds",
        csv = "analysis/quality-control/quickPerCellQC.csv"
    output:
        csv = "analysis/quality-control/topTagsByQC.csv"
    log:
        out = "analysis/quality-control/topTagsByQC.out",
        err = "analysis/quality-control/topTagsByQC.err"
    message:
        "[Quality Control] Perform DE analysis between cells which passed and failed QC"
    script:
        "../scripts/quality-control/topTagsByQC.R"

rule plotTagsByQC:
    input:
        csv = "analysis/quality-control/topTagsByQC.csv"
    output:
        pdf = "analysis/quality-control/plotTagsByQC.pdf"
    log:
        out = "analysis/quality-control/plotTagsByQC.out",
        err = "analysis/quality-control/plotTagsByQC.err"
    message:
        "[Quality Control] Create a MD plot for cells which passed and failed QC"
    script:
        "../scripts/quality-control/plotTagsByQC.R"

rule filterCellByQC:
    input:
        rds = ["analysis/droplet-processing/filterByDrops.rds", "analysis/quality-control/quickPerCellQC.rds"]
    output:
        rds = "analysis/quality-control/filterCellByQC.rds"
    log:
        out = "analysis/quality-control/filterCellByQC.out",
        err = "analysis/quality-control/filterCellByQC.err"
    message:
        "[Quality Control] Filter low-quality cells"
    script:
        "../scripts/quality-control/filterCellByQC.R"

rule perFeatureQCMetrics:
    input:
        rds = "analysis/quality-control/filterCellByQC.rds"
    output:
        rds = "analysis/quality-control/perFeatureQCMetrics.rds"
    log:
        out = "analysis/quality-control/perFeatureQCMetrics.out",
        err = "analysis/quality-control/perFeatureQCMetrics.err"
    message:
        "[Quality Control] Compute per-feature quality control metrics"
    script:
        "../scripts/quality-control/perFeatureQCMetrics.R"

rule plotFeatureMean:
    input:
        rds = "analysis/quality-control/perFeatureQCMetrics.rds"
    output:
        pdf = "analysis/quality-control/plotFeatureMean.pdf"
    log:
        out = "analysis/quality-control/plotFeatureMean.out",
        err = "analysis/quality-control/plotFeatureMean.err"
    message:
        "[Quality Control] Plot the mean counts for each feature"
    script:
        "../scripts/quality-control/plotFeatureMean.R"

rule plotFeatureDetected:
    input:
        rds = "analysis/quality-control/perFeatureQCMetrics.rds"
    output:
        pdf = "analysis/quality-control/plotFeatureDetected.pdf"
    log:
        out = "analysis/quality-control/plotFeatureDetected.out",
        err = "analysis/quality-control/plotFeatureDetected.err"
    message:
        "[Quality Control] Plot the percentage of observations above detection limit"
    script:
        "../scripts/quality-control/plotFeatureDetected.R"

rule plotExprsFreqVsMean:
    input:
        rds = "analysis/quality-control/perFeatureQCMetrics.rds"
    output:
        pdf = "analysis/quality-control/plotExprsFreqVsMean.pdf"
    log:
        out = "analysis/quality-control/plotExprsFreqVsMean.out",
        err = "analysis/quality-control/plotExprsFreqVsMean.err"
    message:
        "[Quality Control] Plot frequency of expression against mean expression level"
    script:
        "../scripts/quality-control/plotExprsFreqVsMean.R"

rule plotHighestExprs:
    input:
        rds = "analysis/droplet-processing/filterByDrops.rds"
    output:
        pdf = "analysis/quality-control/plotHighestExprs.pdf"
    log:
        out = "analysis/quality-control/plotHighestExprs.out",
        err = "analysis/quality-control/plotHighestExprs.err"
    message:
        "[Quality Control] Plot the highest expressing features"
    script:
        "../scripts/quality-control/plotHighestExprs.R"

rule calculatePCA:
    input:
        rds = "analysis/droplet-processing/filterByDrops.rds"
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
        rds = "analysis/droplet-processing/filterByDrops.rds"
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
        rds = "analysis/droplet-processing/filterByDrops.rds"
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
        rds = ["analysis/quality-control/calculatePCA.rds", "analysis/quality-control/perCellQCMetrics.rds"]
    output:
        pdf = "analysis/quality-control/plotPCA.{metric}.pdf"
    log:
        out = "analysis/quality-control/plotPCA.{metric}.out",
        err = "analysis/quality-control/plotPCA.{metric}.err"
    message:
        "[Quality Control] Plot PCA coloured by QC metric: {wildcards.metric}"
    threads:
        16
    script:
        "../scripts/quality-control/plotPCA.R"

rule plotTSNE:
    input:
        rds = ["analysis/quality-control/calculateTSNE.rds", "analysis/quality-control/perCellQCMetrics.rds"]
    output:
        pdf = "analysis/quality-control/plotTSNE.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "analysis/quality-control/plotTSNE.{metric}.out",
        err = "analysis/quality-control/plotTSNE.{metric}.err"
    message:
        "[Quality Control] Plot TSNE coloured by QC metric: {wildcards.metric}"
    threads:
        16
    script:
        "../scripts/quality-control/plotTSNE.R"

rule plotUMAP:
    input:
        rds = ["analysis/quality-control/calculateUMAP.rds", "analysis/quality-control/perCellQCMetrics.rds"]
    output:
        pdf = "analysis/quality-control/plotUMAP.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "analysis/quality-control/plotUMAP.{metric}.out",
        err = "analysis/quality-control/plotUMAP.{metric}.err"
    message:
        "[Quality Control] Plot UMAP coloured by QC metric: {wildcards.metric}"
    threads:
        16
    script:
        "../scripts/quality-control/plotUMAP.R"