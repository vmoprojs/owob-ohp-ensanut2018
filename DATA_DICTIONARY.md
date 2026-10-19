# Dictionary

The public files contain aggregate rows, never participants. Domains: total, children (completed visit age 5–11), adolescents (12–17), adolescent_male, adolescent_female. Original model covariate edadanios uses completed visit years; exact measurement-age months are used for S2. F4 reported age does not silently replace either definition.

OHRP6: any yes among f4_s2_204_a:f; all no yields zero; otherwise missing. OHRP7 additionally includes g. BRUSH_LT2 and DENTAL_NONATTEND retain the D recodes in functions_prepare.R. No third-party questionnaire text is bundled.

WHO2007_S2: F1 T7 closest eligible pair, chronological measurement age in days/30.4375, sex-specific interpolated WHO 2007 LMS over verified 61–228 months, modified tails outside ±3. No preclassification rounding. Underweight z<−2; Healthy −2≤z≤1; Overweight 1<z≤2; Obesity z>2. Healthy is the reference. oedema=n assumed operationally, not clinically verified. Original SAV nutrition reference is code 5; 4 underweight, 2 overweight, 1 obesity.

OWOBNEW_SES_MCA_v1: 13 frozen binary household assets, one household one weight, ade4 MCA axis 1 oriented to more assets, type-1 tertiles with ties retained, High reference. It is a new index; no historical SES provenance is asserted. The actual variable list is config/SES_ITEMS.csv.

upm = PSU; estrato = stratum; fexp = original weight. F4 design declared on all 23,621 before domain restriction, nest=TRUE, no invented FPC. Those are schema variable names, not released identifiers. Public aggregate model files report model/domain/outcome/term, log odds beta, SE, OR/95%CI/p, n, design/residual df, variance policy and source status. Historical frozen L exposure_status labels describe the provisional state at phase L; D04 subsequently approved S2. Numeric values are not altered to relabel that historical provenance.

Percentages use valid domain denominators and original weights. Suppressed S16 cells remain suppressed; no reconstruction from complementary counts is published. Public regenerated tables retain editorial rounding; checkpoint comparisons use full precision and stated tolerances.

