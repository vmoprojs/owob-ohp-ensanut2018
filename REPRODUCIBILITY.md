# Reproduction contract

PUBLIC_MODE_REPRODUCIBLE: tested with locked R dependencies. FULL_ANALYTICAL_REPRODUCIBLE_FROM_PUBLIC_INPUTS=NO. REQUIRES_NONREDISTRIBUTED_INPUT=YES. Run commands and input requirements are in README and DATA_ACCESS.

Public mode verifies every frozen aggregate SHA-256, regenerates scientific plots and table renderings, checks 28 numeric checkpoints and executes testthat. It cannot validate microdata or the cohort selection mechanism. Full mode reconstructs original D outcomes/MCA/F4 frame, independently computes K-S2 from certified date/measurement input, checks frame identity and replays L's frozen registry. It does not invent access to the historical pivot. Full output and execution logs are private/ignored.

R reference: 4.6.1. Package versions: renv.lock. Reference OS, locale and attached namespaces: results/checkpoints/sessionInfo.txt. Fixed contrasts treatment/poly; survey.lonely.psu=fail; survey.adjust.domain.lonely=FALSE. Fixed variance sensitivities adjust/TRUE and average/TRUE. No stochastic analysis step or simulation seed. Domain designs are subsets of the full F4 design. Survey inference uses model residual design df for Wald-t CIs/p and joint Wald-F tests; unweighted glm uses Wald-normal. No FPC is introduced.

Input IDs and category identities: exact. Rebuilt numerical frame tolerance 1e-12; S2 Z tolerance 1e-10, categories exact. Full coefficient/joint-test replay tolerance 1e-9 absolute (well below published precision). Printed checkpoints use half a unit at the displayed decimal: 5e-5 for OR/CI at four decimals, 5e-7 for p at six decimals. Counts have zero tolerance. No data are rounded to meet a gate.

Source lineage is in docs/provenance/CODE_LINEAGE.csv and FROZEN_SOURCE_HASHES.csv. D modules remove only their old helpers source header. Own orchestration injects relative paths and separates private runtime work. K engine and L model engine are byte-identical; extracted helper functions retain the original definitions. Public aggregate input hashes are checked before rendering. checksums/SHA256SUMS.txt hashes all distributed payload files except itself; it does not claim to hash the future commit object.

Zenodo status: account/integration requires manual action; no DOI verified. A future DOI update must be a new main-branch commit; v1.0.0 must never be moved.

