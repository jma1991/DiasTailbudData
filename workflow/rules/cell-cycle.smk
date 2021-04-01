# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule CellCycle_plotCyclinExprs:
    input:
        rds = "analysis/stripped-detection/colStripped.rds"
    output:
        pdf = "analysis/cell-cycle/plotCyclinExprs.pdf"
    params:
        pattern = "^Ccn[abde][0-9]$",
        size = 1000
    log:
        out = "analysis/cell-cycle/plotCyclinExprs.out",
        err = "analysis/cell-cycle/plotCyclinExprs.err"
    message:
        "[Cell cycle assignment] Plot expression of cyclins"
    script:
        "../scripts/cell-cycle/plotCyclinExprs.R"

rule CellCycle_cyclone:
    input:
        rds = "analysis/quality-control/filterCellsByQC.rds"
    output:
        rds = "analysis/cell-cycle/cyclone.rds"
    params:
        rds = "mouse_cycle_markers.rds"
    log:
        out = "analysis/cell-cycle/cyclone.out",
        err = "analysis/cell-cycle/cyclone.err"
    message:
        "[Cell cycle assignment] Cell cycle phase classification"
    threads:
        4
    script:
        "../scripts/cell-cycle/cyclone.R"

rule CellCycle_addPerCellPhase:
    input:
        rds = ["analysis/stripped-detection/colStripped.rds", "analysis/cell-cycle/cyclone.rds"]
    output:
        rds = "analysis/cell-cycle/addPerCellPhase.rds"
    log:
        out = "analysis/cell-cycle/addPerCellPhase.out",
        err = "analysis/cell-cycle/addPerCellPhase.err"
    message:
        "[Cell cycle assignment] Add cell cycle phase to SingleCellExperiment"
    script:
        "../scripts/cell-cycle/addPerCellPhase.R"

rule CellCycle_plotCyclone:
    input:
        rds = "analysis/cell-cycle/cyclone.rds"
    output:
        pdf = "analysis/cell-cycle/plotCyclone.pdf"
    log:
        out = "analysis/cell-cycle/plotCyclone.out",
        err = "analysis/cell-cycle/plotCyclone.err"
    message:
        "[Cell cycle assignment] Plot cyclone scores"
    script:
        "../scripts/cell-cycle/plotCyclone.R"

rule CellCycle_plotPhaseSina:
    input:
        rds = "analysis/cell-cycle/addPerCellPhase.rds"
    output:
        pdf = "analysis/cell-cycle/plotPhaseSina.pdf"
    log:
        out = "analysis/cell-cycle/plotPhaseSina.out",
        err = "analysis/cell-cycle/plotPhaseSina.err"
    message:
        "[Doublet detection] Plot cell-cycle phase by cluster"
    script:
        "../scripts/cell-cycle/plotPhaseSina.R"

rule CellCycle_plotPhasePCA:
    input:
        rds = "analysis/cell-cycle/addPerCellPhase.rds"
    output:
        pdf = "analysis/cell-cycle/plotPhasePCA.pdf"
    log:
        out = "analysis/cell-cycle/plotPhasePCA.out",
        err = "analysis/cell-cycle/plotPhasePCA.err"
    message:
        "[Cell cycle assignment] Plot PCA coloured by cell cycle phase"
    script:
        "../scripts/cell-cycle/plotPhasePCA.R"

rule CellCycle_plotPhaseTSNE:
    input:
        rds = "analysis/cell-cycle/addPerCellPhase.rds"
    output:
        pdf = "analysis/cell-cycle/plotPhaseTSNE.pdf"
    log:
        out = "analysis/cell-cycle/plotPhaseTSNE.out",
        err = "analysis/cell-cycle/plotPhaseTSNE.err"
    message:
        "[Cell cycle assignment] Plot TSNE coloured by cell cycle phase"
    script:
        "../scripts/cell-cycle/plotPhaseTSNE.R"

rule CellCycle_plotPhaseUMAP:
    input:
        rds = "analysis/cell-cycle/addPerCellPhase.rds"
    output:
        pdf = "analysis/cell-cycle/plotPhaseUMAP.pdf"
    log:
        out = "analysis/cell-cycle/plotPhaseUMAP.out",
        err = "analysis/cell-cycle/plotPhaseUMAP.err"
    message:
        "[Cell cycle assignment] Plot UMAP coloured by cell cycle phase"
    script:
        "../scripts/cell-cycle/plotPhaseUMAP.R"
