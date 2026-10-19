# OWOB-OHP — ENSANUT 2018 reproducibility materials

Nutritional status and reported oral health impacts in a selected sample of Ecuadorian children and adolescents from ENSANUT 2018.

This research compendium accompanies an author-review draft. **D08 remains pending; SUBMISSION_AUTHORIZED = NO.** No manuscript draft is distributed. WHO 2007 S2 is the approved primary exposure; original SAV categories are sensitivity only. OHRP6 is primary; OHRP7 is sensitivity.

## Quick start

R 4.6.1 was used for verification. Install R and Git, then:

```bash
git clone https://github.com/vmoprojs/owob-ohp-ensanut2018.git
cd owob-ohp-ensanut2018
Rscript -e 'renv::restore()'
Rscript scripts/00_check_environment.R
Rscript run_all.R --public
```

PUBLIC mode reads frozen disclosure-reviewed aggregates, verifies source hashes, regenerates Tables 1–3 and STROBE S16 in CSV/HTML, renders Figure 1 (six OHRP components), Figure 2 (S2 nutrition), an adjusted obesity forest plot, runs numeric checkpoints and tests. **It does not recompute participant-level estimates or fit regressions.** Generated plots preserve numbers; their layout is a compendium rendering, not a byte reproduction of manuscript artwork.

FULL mode requires the six exact nonredistributed inputs in `data/input_manifest.csv`, obtained independently with appropriate authorization, under `data/raw/`. See [DATA_ACCESS.md](DATA_ACCESS.md). Then run:

```bash
Rscript run_all.R --full
```

FULL reconstructs D outcomes, household MCA and F4 design, recalculates K-S2 from the certified anthropometric/date adjudication input, verifies complete frame identity, and replays all 29 L model pairs (58 fits) plus 40 fixed variance-sensitivity fits. SAV model estimates remain frozen comparators. Private generated data and logs stay ignored. **Full analytical reproduction from public inputs alone is not available.**

## Structure

`R/` contains minimally adapted scientific algorithms and portable orchestration; `scripts/` controls execution; `data/derived_public/` holds own aggregate outputs; `results/` holds rendered artifacts and checkpoints; `tests/` and GitHub Actions run PUBLIC mode; `docs/provenance/` contains source SHA-256 and code lineage.

## Scientific checkpoints

F4 23,621; pivot 19,750; children 11,319; adolescents 8,431; S2 evaluable 19,750; SAV-to-S2 discordances 1,201.

| Domain | Adjusted survey OR, obesity vs healthy weight | 95% CI | p |
|---|---:|---|---:|
| Total | 0.8499 | 0.7234–0.9985 | 0.047951 |
| Children | 0.7820 | 0.6469–0.9454 | 0.011095 |
| Adolescents | 0.9807 | 0.7120–1.3506 | 0.904803 |
| Adolescent males | 1.2175 | 0.7850–1.8884 | 0.379188 |
| Adolescent females | 0.7886 | 0.5187–1.1990 | 0.266440 |

Children's joint nutrition p=0.082584; adolescent nutrition × sex p=0.314558. The total association is borderline. Neither stratum-specific p differences nor these tests establish a causal or sex-modification claim.

## Limits and data access

The selection mechanism from 23,621 F4 records to the 19,750 pivot is **NOT IDENTIFIED**. These are selected-sample analyses under the F4 design assumptions, not certified national prevalence estimates. `oedema="n"` is an operational assumption, not clinically verified. OWOBNEW_SES_MCA_v1 is a new material-asset index, not a recovered historical SES variable. See [LIMITATIONS.md](LIMITATIONS.md).

INEC source files, the investigator pivot, personal crosswalks, adjudicated dates/measurements, private files and manuscripts are not distributed. Public access at INEC does not establish permission for this repository to rehost those files. [DATA_LICENSE.md](DATA_LICENSE.md) preserves third-party terms.

## Citation, authors and licenses

Confirmed manuscript authors: Náthaly Mercedes Román-Galeano; Melanie Scarlet Sánchez-Ramos; Alejandro Rodriguez. No ORCID was supplied. The GitHub account owner is not added as a scientific author. Cite [CITATION.cff](CITATION.cff), version 1.0.1 and the exact release/commit.

Own code: MIT. Own documentation and aggregate results: CC BY 4.0. Third-party software retains its licenses; INEC/WHO materials are not relicensed. See [LICENSE](LICENSE) and [DATA_LICENSE.md](DATA_LICENSE.md).

Contact: [repository issues](https://github.com/vmoprojs/owob-ohp-ensanut2018/issues).

Zenodo: **GitHub integration enabled on 2026-10-19; v1.0.1 archiving pending verification**. The v1.0.0 tag is retained unchanged. No DOI is claimed before a real record is verified. See [docs/zenodo_handoff.md](docs/zenodo_handoff.md).

