# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule librarySizeFactors:
    input:
        rds = "analysis/quality-control/filterCellsByQC.rds"
    output:
        rds = "analysis/normalization/librarySizeFactors.rds"
    log:
        out = "analysis/normalization/librarySizeFactors.out",
        err = "analysis/normalization/librarySizeFactors.err"
    message:
        "[Normalization] Compute library size factors"
    threads:
        16
    script:
        "../scripts/normalization/librarySizeFactors.R"

rule calculateSumFactors:
    input:
        rds = "analysis/quality-control/filterCellsByQC.rds"
    output:
        rds = "analysis/normalization/calculateSumFactors.rds"
    log:
        out = "analysis/normalization/calculateSumFactors.out",
        err = "analysis/normalization/calculateSumFactors.err"
    message:
        "[Normalization] Normalization by deconvolution"
    threads:
        16
    script:
        "../scripts/normalization/calculateSumFactors.R"

rule logNormCounts:
    input:
        rds = ["analysis/quality-control/filterCellsByQC.rds", "analysis/normalization/calculateSumFactors.rds"]
    output:
        rds = "analysis/normalization/logNormCounts.rds"
    params:
        downsample = config["logNormCounts"]["downsample"]
    log:
        out = "analysis/normalization/logNormCounts.out",
        err = "analysis/normalization/logNormCounts.err"
    message:
        "[Normalization] Compute log-normalized expression values (downsample = {params.downsample})"
    threads:
        16
    script:
        "../scripts/normalization/logNormCounts.R"

rule normalization_calculatePCA:
    input:
        rds = "analysis/normalization/logNormCounts.rds"
    output:
        rds = "analysis/normalization/calculatePCA.rds"
    log:
        out = "analysis/normalization/calculatePCA.out",
        err = "analysis/normalization/calculatePCA.err"
    message:
        "[Normalization] Perform PCA on expression data"
    script:
        "../scripts/normalization/calculatePCA.R"

rule normalization_calculateTSNE:
    input:
        rds = "analysis/normalization/calculatePCA.rds"
    output:
        rds = "analysis/normalization/calculateTSNE.rds"
    log:
        out = "analysis/normalization/calculateTSNE.out",
        err = "analysis/normalization/calculateTSNE.err"
    message:
        "[Normalization] Perform TSNE on expression data"
    script:
        "../scripts/normalization/calculateTSNE.R"

rule normalization_calculateUMAP:
    input:
        rds = "analysis/normalization/calculatePCA.rds"
    output:
        rds = "analysis/normalization/calculateUMAP.rds"
    log:
        out = "analysis/normalization/calculateUMAP.out",
        err = "analysis/normalization/calculateUMAP.err"
    message:
        "[Normalization] Perform UMAP on expression data"
    script:
        "../scripts/normalization/calculateUMAP.R"

rule normalization_plotPCA:
    input:
        rds = ["analysis/normalization/calculatePCA.rds", "analysis/quality-control/perCellQCMetrics.rds"]
    output:
        pdf = "analysis/normalization/plotPCA.{metric}.pdf"
    log:
        out = "analysis/normalization/plotPCA.{metric}.out",
        err = "analysis/normalization/plotPCA.{metric}.err"
    message:
        "[Normalization] Plot PCA coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/normalization/plotPCA.R"

rule normalization_plotTSNE:
    input:
        rds = ["analysis/normalization/calculateTSNE.rds", "analysis/quality-control/perCellQCMetrics.rds"]
    output:
        pdf = "analysis/normalization/plotTSNE.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "analysis/normalization/plotTSNE.{metric}.out",
        err = "analysis/normalization/plotTSNE.{metric}.err"
    message:
        "[Normalization] Plot TSNE coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/normalization/plotTSNE.R"

rule normalization_plotUMAP:
    input:
        rds = ["analysis/normalization/calculateUMAP.rds", "analysis/quality-control/perCellQCMetrics.rds"]
    output:
        pdf = "analysis/normalization/plotUMAP.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "analysis/normalization/plotUMAP.{metric}.out",
        err = "analysis/normalization/plotUMAP.{metric}.err"
    message:
        "[Normalization] Plot UMAP coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/normalization/plotUMAP.R"