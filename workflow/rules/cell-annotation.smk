# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule classifySingleR:
    input:
        rds = ["analysis/cell-cycle/addPerCellPhase.rds", "resources/references/trainSingleR.rds"]
    output:
        rds = "analysis/cell-annotation/classifySingleR.rds"
    log:
        out = "analysis/cell-annotation/classifySingleR.out",
        err = "analysis/cell-annotation/classifySingleR.err"
    message:
        "[Cell type annotation] Classify cells with SingleR"
    threads:
        4
    script:
        "../scripts/cell-annotation/classifySingleR.R"

rule plotScoreHeatmap:
    input:
        rds = "analysis/cell-annotation/classifySingleR.rds"
    output:
        pdf = "analysis/cell-annotation/plotScoreHeatmap.pdf"
    log:
        out = "analysis/cell-annotation/plotScoreHeatmap.out",
        err = "analysis/cell-annotation/plotScoreHeatmap.err"
    message:
        "[Cell type annotation] Plot a score heatmap"
    script:
        "../scripts/cell-annotation/plotScoreHeatmap.R"

rule buildRankings:
    input:
        rds = "analysis/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "analysis/cell-annotation/buildRankings.rds"
    log:
        out = "analysis/cell-annotation/buildRankings.out",
        err = "analysis/cell-annotation/buildRankings.err"
    message:
        "[Cell type annotation] Build gene expression rankings for each cell"
    script:
        "../scripts/cell-annotation/buildRankings.R"

rule calcAUC:
    input:
        tsv = "config/markers.tsv",
        rds = "analysis/cell-annotation/buildRankings.rds"
    output:
        rds = "analysis/cell-annotation/calcAUC.rds"
    log:
        out = "analysis/cell-annotation/buildRankings.out",
        err = "analysis/cell-annotation/buildRankings.err"
    message:
        "[Cell type annotation] Calculate AUC"
    script:
        "../scripts/cell-annotation/calcAUC.R"

rule exploreThresholds:
    input:
        rds = "analysis/cell-annotation/calcAUC.rds"
    output:
        pdf = "analysis/cell-annotation/exploreThresholds.pdf"
    log:
        out = "analysis/cell-annotation/exploreThresholds.out",
        err = "analysis/cell-annotation/exploreThresholds.err"
    message:
        "[Cell type annotation] Plot AUC histograms"
    script:
        "../scripts/cell-annotation/exploreThresholds.R"

rule addCelltype:
    input:
        rds = ["analysis/cell-cycle/addPerCellPhase.rds", "analysis/cell-annotation/calcAUC.rds"]
    output:
        rds = "analysis/cell-annotation/addCelltype.rds"
    log:
        out = "analysis/cell-annotation/addCelltype.out",
        err = "analysis/cell-annotation/addCelltype.err"
    message:
        "[Cell type annotation] Add celltype annotation"
    script:
        "../scripts/cell-annotation/addCelltype.R"
