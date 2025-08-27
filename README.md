# Extraction de références projets dans Power BI sans Regex native

Power BI est un outil puissant et complet pour la data visualisation et le traitement des données.  
Toutefois, il lui manque une fonctionnalité importante que l’on retrouve dans la plupart des langages : **les expressions régulières (regex)**.  

Ce dépôt propose deux approches complémentaires pour résoudre ce manque lorsqu’il s’agit d’extraire des motifs connus dans des labels (par exemple des références projets du type `PR-YYYY-XXX`, où `YYYY` est une année et `XXX` un identifiant à trois chiffres).

---

## 📌 Contexte

Dans un modèle de données, il est fréquent d’avoir besoin d’isoler une **référence projet** incluse dans un champ texte (exemple : `"Projet Finance PR-2023-045 Europe"`).  

Sans regex native dans Power BI, deux solutions s’offrent à vous :  

1. **Python**  
   - Utilisation du module standard `re`.  
   - Permet une écriture claire et concise du motif.  
   - Exemple de pattern :  
     ```python
     pattern = re.compile(r'PR-\d{4}-\d{3}(?=$|\s)')
     ```  
   - Limite : l’intégration Python n’est pas supportée de manière transparente dans **Power BI Service** (rafraîchissement planifié non supporté sans passerelle personnelle).

2. **Power Query (M)**  
   - Utilisation des fonctions de liste (`List.Select`) et de texte (`Text.Middle`, `Text.Range`, etc.).  
   - Le script parcourt les chaînes pour identifier les sous-chaînes valides au format attendu.  
   - Avantage : **100% compatible avec Power BI Service** sans dépendance externe.  
   - Limite : syntaxe plus verbeuse et moins intuitive qu’une regex Python.

---

## 📂 Contenu du dépôt

- `ExtractionProjetRegex.pq` → script Power Query M pour ajouter une colonne calculée et extraire la référence projet.  
- `script_python.py` → script Python autonome lisant un fichier Excel et affichant pour chaque ligne du dataset le label projet et la référence extraite.  
- `DATA_REGEX_XLSX.xlsx` → fichier de données source à exploiter.

---

## 📖 Ressources utiles
- [Documentation Power Query M – List functions](https://learn.microsoft.com/fr-fr/powerquery-m/list-functions)  
- [Documentation Python – re (Regular expressions)](https://docs.python.org/3/library/re.html)  

---

## ✅ Conclusion

Même si Power BI n’intègre pas encore les regex nativement, il est possible de contourner cette limitation :  
- avec **Python** pour la simplicité d’écriture (mais limité dans Service),  
- avec **Power Query** pour une compatibilité totale.  

Ce dépôt met à disposition deux implémentations pratiques pour que vous puissiez les réutiliser dans vos propres projets.  
