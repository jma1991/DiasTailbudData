# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule DataIntegration_regressBatches:
    input:
        rds = ["analysis/normalization/logNormCounts.rds", "analysis/cell-cycle/cyclone.rds"]
    output:
        rds = "analysis/data-integration/regressBatches.rds"
    log:
        out = "analysis/data-integration/regressBatches.out",
        err = "analysis/data-integration/regressBatches.err"
    message:
        "[Data integration] Regress out batch effects"
    script:
        "../scripts/data-integration/regressBatches.R"
