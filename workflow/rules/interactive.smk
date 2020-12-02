# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule iSEE:
    input:
        rds = "analysis/cell-annotation/addCelltype.rds"
    output:
        txt = "analysis/interactive/app.R",
        rds = "analysis/interactive/data.rds"
    params:
        appDir = "analysis/interactive",
        appName = "DiasTailbudData",
        appTitle = "DiasTailbudData"
    log:
        out = "analysis/interactive/log.out",
        err = "analysis/interactive/log.err"
    message:
        "[Interactive data exploration] Deploy iSEE app"
    script:
        "../scripts/interactive/iSEE.R"
