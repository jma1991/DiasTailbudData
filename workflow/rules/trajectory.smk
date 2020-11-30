# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule perCellEntropy:
    input:
        rds = "analysis/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "analysis/trajectory/perCellEntropy.rds"
    log:
        out = "analysis/trajectory/perCellEntropy.out",
        err = "analysis/trajectory/perCellEntropy.err"
    message:
        "[Trajectory analysis] Compute the per-cell entropy"
    script:
        "../scripts/trajectory/perCellEntropy.R"

rule plotEntropy:
    input:
        rds = ["analysis/cell-cycle/addPerCellPhase.rds", "analysis/trajectory/perCellEntropy.rds"]
    output:
        pdf = "analysis/trajectory/plotEntropy.pdf"
    log:
        out = "analysis/trajectory/plotEntropy.out",
        err = "analysis/trajectory/plotEntropy.err"
    message:
        "[Trajectory analysis] Plot the per-cell entropy"
    script:
        "../scripts/trajectory/plotEntropy.R"

rule slingshot:
    input:
        rds = "analysis/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "analysis/trajectory/slingshot.rds"
    log:
        out = "analysis/trajectory/slingshot.out",
        err = "analysis/trajectory/slingshot.err"
    message:
        "[Trajectory analysis] Perform lineage inference with Slingshot"
    script:
        "../scripts/trajectory/slingshot.R"

rule plotCurves:
    input:
        rds = ["analysis/cell-cycle/addPerCellPhase.rds", "analysis/trajectory/slingshot.rds"]
    output:
        pdf = "analysis/trajectory/plotCurves.pdf"
    log:
        out = "analysis/trajectory/plotCurves.out",
        err = "analysis/trajectory/plotCurves.err"
    message:
        "[Trajectory analysis]"
    script:
        "../scripts/trajectory/plotCurves.R"

rule scvelo:
    input:
        rds = "analysis/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "analysis/trajectory/scvelo.rds"
    log:
        out = "analysis/trajectory/scvelo.out",
        err = "analysis/trajectory/scvelo.err"
    message:
        "[Trajectory analysis] RNA velocity with scVelo"
    threads:
        16
    script:
        "../scripts/trajectory/scvelo.R"

rule embedVelocity:
    input:
        rds = ["analysis/cell-cycle/addPerCellPhase.rds", "analysis/trajectory/scvelo.rds"]
    output:
        rds = "analysis/trajectory/embedVelocity.{reducedDim}.rds"
    log:
        out = "analysis/trajectory/embedVelocity.{reducedDim}.out",
        err = "analysis/trajectory/embedVelocity.{reducedDim}.err"
    message:
        "[Trajectory analysis] Project velocities onto {wildcards.reducedDim} embedding"
    script:
        "../scripts/trajectory/embedVelocity.R"

rule gridVectors:
    input:
        rds = ["analysis/cell-cycle/addPerCellPhase.rds", "analysis/trajectory/embedVelocity.{reducedDim}.rds"]
    output:
        rds = "analysis/trajectory/gridVectors.{reducedDim}.rds"
    log:
        out = "analysis/trajectory/gridVectors.{reducedDim}.out",
        err = "analysis/trajectory/gridVectors.{reducedDim}.err"
    message:
        "[Trajectory analysis] Summarize {wildcards.reducedDim} vectors into a grid"
    script:
        "../scripts/trajectory/gridVectors.R"

rule plotVeloPCA:
    input:
        rds = ["analysis/cell-cycle/addPerCellPhase.rds", "analysis/trajectory/gridVectors.PCA.rds"]
    output:
        pdf = "analysis/trajectory/plotVeloPCA.pdf"
    log:
        out = "analysis/trajectory/plotVeloPCA.out",
        err = "analysis/trajectory/plotVeloPCA.err"
    message:
        "[Trajectory analysis] Plot PCA and RNA velocity vectors"
    script:
        "../scripts/trajectory/plotVeloPCA.R"

rule plotVeloTSNE:
    input:
        rds = ["analysis/cell-cycle/addPerCellPhase.rds", "analysis/trajectory/gridVectors.TSNE.rds"]
    output:
        pdf = "analysis/trajectory/plotVeloTSNE.pdf"
    log:
        out = "analysis/trajectory/plotVeloTSNE.out",
        err = "analysis/trajectory/plotVeloTSNE.err"
    message:
        "[Trajectory analysis] Plot TSNE and RNA velocity vectors"
    script:
        "../scripts/trajectory/plotVeloTSNE.R"

rule plotVeloUMAP:
    input:
        rds = ["analysis/cell-cycle/addPerCellPhase.rds", "analysis/trajectory/gridVectors.UMAP.rds"]
    output:
        pdf = "analysis/trajectory/plotVeloUMAP.pdf"
    log:
        out = "analysis/trajectory/plotVeloUMAP.out",
        err = "analysis/trajectory/plotVeloUMAP.err"
    message:
        "[Trajectory analysis] Plot UMAP and RNA velocity vectors"
    script:
        "../scripts/trajectory/plotVeloUMAP.R"