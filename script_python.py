import re
import pandas as pd

FILEPATH = r"C:/MontBlancData/DATA_REGEX_XLSX.xlsx"

LABEL_COL = "Label projet" 

# Motif : PR-YYYY-XXX
pattern = re.compile(r"PR-\d{4}-\d{3}(?=$|\s)")

df = pd.read_excel(FILEPATH)

for label in df[LABEL_COL]:
    label = "" if pd.isna(label) else str(label)
    m = pattern.search(label)
    motif = m.group(0) if m else "Référence projet non identifiée"
    print(f"{label} -> {motif}")
