# Zenodo handoff — no DOI yet

The available browser redirected the GitHub integration page to Zenodo login. No authenticated Zenodo session was available; no API token was requested or used. Integration state is unverified, not assumed disconnected. GitHub release v1.0.0 is published independently after all gates. Do not claim it is archived until a real record is verified.

1. Sign in at https://zenodo.org/login/ using your own account.
2. Connect the GitHub account vmoprojs if needed, reviewing the permissions in Zenodo's Linked accounts settings.
3. Open https://zenodo.org/account/settings/github/ (profile → GitHub); click Sync now.
4. Find vmoprojs/owob-ohp-ensanut2018 and enable its repository slider; refresh to verify it is enabled.
5. Because v1.0.0 was released before integration could be verified, do not assume retroactive ingestion. Check the repository's Zenodo release list for v1.0.0. If absent, either upload the exact public v1.0.0 source archive manually as software with the prepared metadata, or create a subsequent patch release v1.0.1 after updating version fields, changelog and checksums. Do not move/delete the v1.0.0 tag or mislabel v1.0.1 as v1.0.0.
6. Wait for processing. Open the real Zenodo record and verify version, creators, files, version DOI, concept DOI and archival status. If metadata errors occur, correct the metadata and release a new version as instructed by Zenodo.
7. Record those real identifiers. Update README, CITATION.cff and REPRODUCIBILITY.md on main in a new post-DOI commit; retain the immutable release tag.

No dataset deposit or microdata upload is authorized. The compendium metadata uses MIT software license; own documentation/results remain CC BY 4.0. No article DOI has been supplied.

Official instructions: https://help.zenodo.org/docs/github/enable-repository/ and https://help.zenodo.org/docs/github/archive-software/github-upload/

