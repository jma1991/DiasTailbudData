# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule FeatureSelection_modelGeneVar:
    input:
        rds = "analysis/normalization/logNormCounts.rds"
    output:
        rds = "analysis/feature-selection/modelGeneVar.rds"
    log:
        out = "analysis/feature-selection/modelGeneVar.out",
        err = "analysis/feature-selection/modelGeneVar.err"
    message:
        "[Feature selection] Model the per-gene variance"
    script:
        "../scripts/feature-selection/modelGeneVar.R"

rule FeatureSelection_plotGeneVar:
    input:
        rds = ["analysis/feature-selection/modelGeneVar.rds", "analysis/feature-selection/modelGeneVar.HVG.rds"]
    output:
        pdf = "analysis/feature-selection/plotGeneVar.pdf"
    params:
        n = 25
    log:
        out = "analysis/feature-selection/plotGeneVar.out",
        err = "analysis/feature-selection/plotGeneVar.err"
    message:
        "[Feature selection] Plot the per-gene variance"
    script:
        "../scripts/feature-selection/plotGeneVar.R"

rule FeatureSelection_modelGeneCV2:
    input:
        rds = "analysis/normalization/logNormCounts.rds"
    output:
        rds = "analysis/feature-selection/modelGeneCV2.rds"
    log:
        out = "analysis/feature-selection/modelGeneCV2.out",
        err = "analysis/feature-selection/modelGeneCV2.err"
    message:
        "[Feature selection] Model the per-gene CV2"
    script:
        "../scripts/feature-selection/modelGeneCV2.R"

rule FeatureSelection_plotGeneCV2:
    input:
        rds = ["analysis/feature-selection/modelGeneCV2.rds", "analysis/feature-selection/modelGeneCV2.HVG.rds"]
    output:
        pdf = "analysis/feature-selection/plotGeneCV2.pdf"
    params:
        n = 25
    log:
        out = "analysis/feature-selection/plotGeneCV2.out",
        err = "analysis/feature-selection/plotGeneCV2.err"
    message:
        "[Feature selection] Plot the per-gene CV2"
    script:
        "../scripts/feature-selection/plotGeneCV2.R"

rule FeatureSelection_modelGeneVarByPoisson:
    input:
        rds = "analysis/normalization/logNormCounts.rds"
    output:
        rds = "analysis/feature-selection/modelGeneVarByPoisson.rds"
    log:
        out = "analysis/feature-selection/modelGeneVarByPoisson.out",
        err = "analysis/feature-selection/modelGeneVarByPoisson.err"
    message:
        "[Feature selection] Model the per-gene variance with Poisson noise"
    script:
        "../scripts/feature-selection/modelGeneVarByPoisson.R"

rule FeatureSelection_plotGeneVarByPoisson:
    input:
        rds = ["analysis/feature-selection/modelGeneVarByPoisson.rds", "analysis/feature-selection/modelGeneVarByPoisson.HVG.rds"]
    output:
        pdf = "analysis/feature-selection/plotGeneVarByPoisson.pdf"
    params:
        n = 25
    log:
        out = "analysis/feature-selection/plotGeneVarByPoisson.out",
        err = "analysis/feature-selection/plotGeneVarByPoisson.err"
    message:
        "[Feature selection] Plot the per-gene variance with Poisson noise"
    script:
        "../scripts/feature-selection/plotGeneVarByPoisson.R"

rule FeatureSelection_getTopHVGs:
    input:
        rds = "analysis/feature-selection/{model}.rds",
        txt = expand("resources/subsets/{subset}.txt", subset = ["CC", "MT", "RP", "X", "Y"])
    output:
        rds = "analysis/feature-selection/{model}.HVG.rds"
    params:
        FDR = config["getTopHVGs"]["fdr.threshold"]
    log:
        out = "analysis/feature-selection/{model}.HVG.out",
        err = "analysis/feature-selection/{model}.HVG.err"
    message:
        "[Feature selection] Identify HVG using {wildcards.model} (fdr.threshold = {params.FDR})"
    script:
        "../scripts/feature-selection/getTopHVGs.R"

rule FeatureSelection_aggregateReference:
    input:
        rds = "analysis/normalization/logNormCounts.rds"
    output:
        rds = "analysis/normalization/aggregateReference.rds"
    log:
        out = "analysis/normalization/aggregateReference.out",
        err = "analysis/normalization/aggregateReference.err"
    message:
        "[Feature selection] Aggregate reference samples"
    threads:
        16
    script:
        "../scripts/feature-selection/aggregateReference.R"

rule FeatureSelection_plotHeatmap:
    input:
        rds = ["analysis/normalization/aggregateReference.rds", "analysis/feature-selection/{model}.HVG.rds"]
    output:
        pdf = "analysis/feature-selection/plotHeatmap.{model}.HVG.pdf"
    log:
        out = "analysis/feature-selection/plotHeatmap.{model}.HVG.out",
        err = "analysis/feature-selection/plotHeatmap.{model}.HVG.err"
    message:
        "[Feature selection] Plot heatmap of highly variable gene expression values"
    script:
        "../scripts/feature-selection/plotHeatmap.R"

rule FeatureSelection_calculatePCA:
    input:
        rds = ["analysis/normalization/logNormCounts.rds", "analysis/feature-selection/{model}.HVG.rds"]
    output:
        rds = "analysis/feature-selection/calculatePCA.{model}.HVG.rds"
    log:
        out = "analysis/feature-selection/calculatePCA.{model}.HVG.out",
        err = "analysis/feature-selection/calculatePCA.{model}.HVG.err"
    message:
        "[Feature selection] Perform PCA on expression data"
    script:
        "../scripts/feature-selection/calculatePCA.R"

rule FeatureSelection_calculateTSNE:
    input:
        rds = "analysis/feature-selection/calculatePCA.{model}.HVG.rds"
    output:
        rds = "analysis/feature-selection/calculateTSNE.{model}.HVG.rds"
    log:
        out = "analysis/feature-selection/calculateTSNE.{model}.HVG.out",
        err = "analysis/feature-selection/calculateTSNE.{model}.HVG.err"
    message:
        "[Feature selection] Perform TSNE on PCA matrix"
    script:
        "../scripts/feature-selection/calculateTSNE.R"

rule FeatureSelection_calculateUMAP:
    input:
        rds = "analysis/feature-selection/calculatePCA.{model}.HVG.rds"
    output:
        rds = "analysis/feature-selection/calculateUMAP.{model}.HVG.rds"
    log:
        out = "analysis/feature-selection/calculateUMAP.{model}.HVG.out",
        err = "analysis/feature-selection/calculateUMAP.{model}.HVG.err"
    message:
        "[Feature selection] Perform UMAP on PCA matrix"
    threads:
        1
    script:
        "../scripts/feature-selection/calculateUMAP.R"

rule FeatureSelection_plotPCA:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/feature-selection/calculatePCA.{model}.HVG.rds"]
    output:
        pdf = "analysis/feature-selection/plotPCA.{model}.HVG.{metric}.pdf"
    log:
        out = "analysis/feature-selection/plotPCA.{model}.HVG.{metric}.out",
        err = "analysis/feature-selection/plotPCA.{model}.HVG.{metric}.err"
    message:
        "[Feature selection] Plot PCA coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/feature-selection/plotPCA.R"

rule FeatureSelection_plotTSNE:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/feature-selection/calculateTSNE.{model}.HVG.rds"]
    output:
        pdf = "analysis/feature-selection/plotTSNE.{model}.HVG.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "analysis/feature-selection/plotTSNE.{model}.HVG.{metric}.out",
        err = "analysis/feature-selection/plotTSNE.{model}.HVG.{metric}.err"
    message:
        "[Feature selection] Plot TSNE coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/feature-selection/plotTSNE.R"

rule FeatureSelection_plotUMAP:
    input:
        rds = ["analysis/quality-control/perCellQCMetrics.rds", "analysis/feature-selection/calculateUMAP.{model}.HVG.rds"]
    output:
        pdf = "analysis/feature-selection/plotUMAP.{model}.HVG.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "analysis/feature-selection/plotUMAP.{model}.HVG.{metric}.out",
        err = "analysis/feature-selection/plotUMAP.{model}.HVG.{metric}.err"
    message:
        "[Feature selection] Plot UMAP coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/feature-selection/plotUMAP.R"

rule FeatureSelection_rowSubset:
    input:
        rds = ["analysis/normalization/logNormCounts.rds", "analysis/feature-selection/modelGeneVarByPoisson.HVG.rds"]
    output:
        rds = "analysis/feature-selection/rowSubset.rds"
    log:
        out = "analysis/feature-selection/rowSubset.out",
        err = "analysis/feature-selection/rowSubset.err"
    message:
        "[Feature selection] Set the row subset for highly variable genes"
    script:
        "../scripts/feature-selection/rowSubset.R"