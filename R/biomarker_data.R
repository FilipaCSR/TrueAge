# =============================================================================
# BIOMARKER INFORMATION DATABASE
# =============================================================================
# Detailed information about each biomarker for education and recommendations
# =============================================================================

biomarker_info <- list(
  albumin = list(
    name = "Albumin",
    unit = "g/dL",
    description = "A protein made by the liver. It keeps fluid in your bloodstream and carries hormones, vitamins, and enzymes throughout your body.",
    optimal_range = "3.5 - 5.5 g/dL",
    higher_means = "Adequate protein intake, good liver function, low chronic inflammation, and good hydration status",
    lower_means = "Low protein intake, chronic inflammation, excessive alcohol consumption, poor sleep, or significant physical stress",
    how_to_improve = list(
      "Eat adequate protein (fish, eggs, lean meat, legumes)",
      "Stay well hydrated",
      "Limit alcohol consumption",
      "Reduce chronic inflammation through diet and exercise",
      "Ensure adequate sleep for liver recovery"
    ),
    aging_effect = "Decreases with age; higher values are associated with better nutrition, lower inflammation, and a younger biological age"
  ),

  alp = list(
    name = "Alkaline Phosphatase (ALP)",
    unit = "U/L",
    description = "An enzyme found in the liver, bones, kidneys, and digestive system. Reflects liver and bone metabolic activity.",
    optimal_range = "44 - 147 U/L (adults)",
    higher_means = "Alcohol consumption, high-fat diet, excess body weight, certain medications, or high bone turnover from sedentary lifestyle",
    lower_means = "Low zinc intake, very low calorie intake, or hypothyroidism — in otherwise healthy people, low-normal ALP often reflects good liver health and low inflammation",
    how_to_improve = list(
      "Maintain healthy weight to reduce liver stress",
      "Limit alcohol and processed foods",
      "Get adequate vitamin D and zinc",
      "Exercise regularly for bone health",
      "Avoid unnecessary medications that stress the liver"
    ),
    aging_effect = "Increases with age; lower values within the normal range are associated with better liver and bone health and a younger biological age"
  ),

  creatinine = list(
    name = "Creatinine",
    unit = "mg/dL",
    description = "A waste product from normal muscle metabolism. Your kidneys filter it out of your blood — it reflects both muscle mass and kidney filtration efficiency.",
    optimal_range = "0.6 - 1.2 mg/dL (varies by muscle mass and sex)",
    higher_means = "Dehydration, very high protein or red meat intake, intense recent exercise, or reduced kidney filtration efficiency",
    lower_means = "Low muscle mass, low meat intake, or creatine supplementation (which paradoxically reduces creatinine by improving muscle creatine retention)",
    how_to_improve = list(
      "Stay well hydrated",
      "Avoid NSAIDs (ibuprofen, etc.) when possible",
      "Control blood pressure and blood sugar to protect kidney function",
      "Maintain healthy muscle mass through resistance exercise",
      "Moderate red meat intake if values are high"
    ),
    aging_effect = "Tends to increase with age as kidney filtration efficiency declines; lower values within normal range generally reflect better kidney function"
  ),

  hba1c = list(
    name = "HbA1c (Glycated Hemoglobin)",
    unit = "%",
    description = "Measures your average blood sugar over the past 2-3 months. Reflects how well your body is regulating glucose over time.",
    optimal_range = "Below 5.7%",
    higher_means = "High refined carbohydrate or sugar intake, sedentary lifestyle, poor sleep, chronic stress, or excess body weight — all of which reduce insulin sensitivity",
    lower_means = "Good long-term blood sugar control driven by regular exercise, balanced diet, healthy weight, and good sleep quality",
    how_to_improve = list(
      "Reduce refined carbohydrates and sugar intake",
      "Exercise regularly — both cardio and strength training improve insulin sensitivity",
      "Maintain healthy weight",
      "Eat more fiber (vegetables, whole grains, legumes)",
      "Manage stress (cortisol raises blood sugar)",
      "Get adequate sleep (7-9 hours)"
    ),
    aging_effect = "Increases with age as insulin sensitivity naturally declines; used here as a proxy for long-term glucose control"
  ),

  crp = list(
    name = "C-Reactive Protein (CRP)",
    unit = "mg/L",
    description = "A marker of inflammation produced by the liver. Reflects the level of chronic low-grade inflammation in your body.",
    optimal_range = "Below 1.0 mg/L",
    higher_means = "Excess body fat, processed food diet, high sugar intake, poor sleep, chronic stress, smoking, sedentary lifestyle, or recent intense exercise",
    lower_means = "Regular physical activity, anti-inflammatory diet rich in omega-3s and polyphenols, healthy body weight, good sleep quality, and low stress",
    how_to_improve = list(
      "Exercise regularly — chronic exercise is one of the most effective CRP reducers",
      "Eat anti-inflammatory foods (fatty fish, olive oil, berries, leafy greens)",
      "Avoid processed foods, sugar, and trans fats",
      "Achieve and maintain a healthy body weight",
      "Get 7-9 hours of quality sleep",
      "Manage chronic stress through meditation, breathing, or other techniques",
      "Consider omega-3 supplementation (2-3g EPA/DHA daily)"
    ),
    aging_effect = "Increases with age due to accumulating inflammatory burden; one of the most heavily weighted biomarkers in the biological age formula"
  ),

  wbc = list(
    name = "White Blood Cell Count (WBC)",
    unit = "10³/µL",
    description = "Measures the total number of immune cells circulating in your blood. Reflects your immune system's baseline activation level.",
    optimal_range = "4.5 - 11.0 × 10³/µL",
    higher_means = "Chronic inflammation, smoking, obesity, high stress, sedentary lifestyle, or poor sleep — all of which keep the immune system in a persistently activated state",
    lower_means = "Regular exercise, low chronic inflammation, healthy body weight, good sleep, and non-smoking status — low-normal WBC in healthy people reflects a calm, efficient immune system",
    how_to_improve = list(
      "Exercise regularly — one of the strongest drivers of lower baseline WBC",
      "Avoid smoking",
      "Manage chronic stress",
      "Get adequate sleep",
      "Maintain healthy weight",
      "Eat a diet rich in vegetables, fiber, and fermented foods to support gut microbiome"
    ),
    aging_effect = "Tends to increase with age as chronic inflammation accumulates; lower values within the normal range are associated with less inflammation and a younger biological age"
  ),

  mcv = list(
    name = "Mean Corpuscular Volume (MCV)",
    unit = "fL",
    description = "Measures the average size of your red blood cells. Reflects the quality and consistency of red blood cell production in your bone marrow.",
    optimal_range = "80 - 100 fL",
    higher_means = "Excess alcohol consumption, low B12 intake (common in vegetarians/vegans), low folate intake, or poor nutrient absorption",
    lower_means = "Low iron intake, poor iron absorption, or very high endurance training volume which increases iron demand",
    how_to_improve = list(
      "If trending high: reduce alcohol, ensure adequate B12 and folate through diet or supplementation",
      "If trending low: increase iron-rich foods (red meat, legumes, leafy greens) and pair with vitamin C for absorption",
      "Eat a nutrient-dense, varied diet",
      "If vegetarian or vegan, consider B12 supplementation",
      "Get tested for B12, folate, and iron if MCV is outside range"
    ),
    aging_effect = "Increases slightly with age as bone marrow function and nutrient absorption gradually decline"
  ),

  rdw = list(
    name = "Red Cell Distribution Width (RDW)",
    unit = "%",
    description = "Measures the variation in size among your red blood cells. Lower variation means your bone marrow is producing consistent, healthy red blood cells.",
    optimal_range = "11.5 - 14.5%",
    higher_means = "Nutritional deficiencies (iron, B12, folate), oxidative stress, poor sleep, chronic inflammation, or excessive alcohol — all of which impair consistent red blood cell production",
    lower_means = "Good nutritional status, low oxidative stress, low inflammation, and efficient bone marrow function",
    how_to_improve = list(
      "Check and address iron, B12, and folate levels — the most common drivers",
      "Reduce chronic inflammation (see CRP recommendations)",
      "Optimize sleep quality — most red blood cell repair happens during deep sleep",
      "Consider omega-3 supplementation to reduce oxidative stress on cell membranes",
      "Limit alcohol",
      "Ensure adequate vitamin D levels"
    ),
    aging_effect = "Increases with age and is one of the most heavily weighted biomarkers in the biological age formula; strongly associated with mortality risk across multiple large studies"
  ),

  lymph = list(
    name = "Lymphocyte Percentage",
    unit = "%",
    description = "Lymphocytes are the immune cells responsible for fighting viral infections and producing antibodies. This measures their share of your total white blood cell count.",
    optimal_range = "20 - 40% (athletes may naturally run 40-50%)",
    higher_means = "Regular exercise — which chronically elevates lymphocyte percentage as a sign of healthy immune activity. In active individuals, values of 40-50% are common and reflect good immune fitness",
    lower_means = "Chronic stress, poor sleep, sedentary lifestyle, smoking, or aging-related immune decline — all of which suppress lymphocyte production and activity",
    how_to_improve = list(
      "Exercise regularly — one of the most effective ways to maintain lymphocyte levels",
      "Get adequate sleep (critical for lymphocyte production and activity)",
      "Manage chronic stress — cortisol directly suppresses lymphocytes",
      "Eat immune-supporting nutrients: zinc, vitamin C, vitamin D",
      "Avoid smoking and excessive alcohol"
    ),
    aging_effect = "Decreases with age due to thymic involution — the gradual shrinking of the thymus gland which produces T-cells. Higher lymphocyte percentage is associated with better immune health and a younger biological age"
  )
)
