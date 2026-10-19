# Input access and nonredistributed requirements

PUBLIC needs no person-level input. Frozen aggregates are in data/derived_public with SHA-256 manifest. These are outputs, not public source microdata.

FULL requires all six exact files listed in data/input_manifest.csv in data/raw:

1. BASE TESIS 19750.sav: immutable investigator-controlled pivot, 19,750 rows/85 columns. No public URL or redistribution permission established. Request authorized access from the investigator; it cannot be reconstructed by arbitrarily selecting 19,750 F4 participants.
2. 8_BDD_ENS2018_f4_fact_riesgo.dta: INEC A9 F4, 23,621 rows/90 variables.
3. 1_BDD_ENS2018_f1_personas.dta: official F1 persons.
4. 2_BDD_ENS2018_f1_hogar.dta: official F1 households.
5. K_BASELINE_ANTHROPOMETRY_ONLY.rds: certified OWOB01K input including adjudicated birth/measurement dates, official readings and verified LMS reference. Nonredistributed, person-level; request authorized access. This avoids repeating unresolved documentary adjudications by guesswork.
6. FROZEN_INPUTS_WITH_CANDIDATE.rds: certified OWOB01L paired-sample contract, original covariates/outcomes/masks and S2 comparator. Nonredistributed, person-level; request authorized access. FULL independently rebuilds the numerical frame and verifies it against this contract before any fit.

INEC official catalogue: https://anda.inec.gob.ec/anda5/index.php/catalog/891
Published products archive: https://anda.inec.gob.ec/anda5/index.php/catalog/891/download/18674
Within the published products, select A9. BDD_ENSANUT_2018_STATA_1 and the exact filenames above. Catalogue reference: ECU-INEC-DIES-ENSANUT-2018-v1.4. Consult current INEC terms and prescribed citation. Some automated requests currently return HTTP 403; use the catalogue's normal download workflow. There is no unattended downloader that bypasses that restriction.

Verify every extracted file against input_manifest.csv; FULL rejects missing or changed inputs. No automatic download of the pivot or private adjudication/model contracts is attempted. No new crosswalk is published. The exact 23,621→19,750 selection mechanism remains NOT IDENTIFIED. Public official files alone are insufficient for exact analytical reproduction.

Only read your original source files. Copy authorized inputs into the ignored data/raw directory; never git-add them. FULL writes generated person-level work only under private/, also ignored. PUBLIC/CI cannot access these directories. No private inputs are included in releases or local review bundles.

