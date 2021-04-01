# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule StrippedDetection_findStrippedClusters:
    input:
        rds = ["analysis/doublet-detection/mockDoubletSCE.rds", "analysis/quality-control/perCellQCMetrics.rds"]
    output:
        rds = "analysis/stripped-detection/findStrippedClusters.rds"
    params:
        nmads = config["findStrippedClusters"]["nmads"]
    log:
        out = "analysis/stripped-detection/findStrippedClusters.out",
        err = "analysis/stripped-detection/findStrippedClusters.err"
    message:
        "[Stripped detection] Detect stripped nuclei clusters"
    script:
        "../scripts/stripped-detection/findStrippedClusters.R"

rule StrippedDetection_colStripped:
    input:
        rds = ["analysis/doublet-detection/mockDoubletSCE.rds", "analysis/stripped-detection/findStrippedClusters.rds"]
    output:
        rds = "analysis/stripped-detection/colStripped.rds"
    log:
        out = "analysis/stripped-detection/colStripped.out",
        err = "analysis/stripped-detection/colStripped.err"
    message:
        "[Stripped detection] Assign stripped nuclei clusters"
    script:
        "../scripts/stripped-detection/colStripped.R"

rule StrippedDetection_plotStrippedSina:
    input:
        rds = ["analysis/stripped-detection/colStripped.rds", "analysis/quality-control/perCellQCMetrics.rds"]
    output:
        pdf = "analysis/stripped-detection/plotStrippedSina.pdf"
    log:
        out = "analysis/stripped-detection/plotStrippedSina.out",
        err = "analysis/stripped-detection/plotStrippedSina.err"
    message:
        "[Stripped detection] Plot stripped nuclei by cluster"
    script:
        "../scripts/stripped-detection/plotStrippedSina.R"