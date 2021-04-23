# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule iSEE:
    input:
        rds = "analysis/cell-cycle/addPerCellPhase.rds"
    output:
        txt = "analysis/interactive/app.R",
        rds = "analysis/interactive/sce.rds"
    params:
        dir = "analysis/interactive"
    script:
        "../scripts/interactive/iSEE.R"