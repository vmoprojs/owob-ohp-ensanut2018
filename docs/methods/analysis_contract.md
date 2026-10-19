# Preserved analysis definitions

Read DATA_DICTIONARY.md, LIMITATIONS.md and config/MODEL_REGISTRY.csv. Core source algorithms retain D outcomes, household MCA, F4 survey structure and L formulas. K independent LMS engine is byte-identical. The public code contains variable names needed for schema validation but no actual personal identifiers.
Public aggregation never reconstructs suppressed transition cells. Full checks run before models and stop on input, schema, frame, exposure or sample mismatch.
