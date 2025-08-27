let
    Source = Excel.Workbook(
        File.Contents("C:\MontBlancData\DATA_REGEX_XLSX.xlsx"),
        null,
        true
    ),
    Feuil1_Sheet = Source{[Item="Feuil1", Kind="Sheet"]}[Data],
    #"En-têtes promus" = Table.PromoteHeaders(Feuil1_Sheet, [PromoteAllScalars = true]),
    #"Type modifié" = Table.TransformColumnTypes(
        #"En-têtes promus",
        {
            {"Label projet", type text},
            {"Référence à extraire", type text},
            {"Statut", type text}
        }
    ),
    #"Extraction Référence Projet (PBI)" =
        Table.AddColumn(
            #"Type modifié",
            "Référence projet extraite nativement (PBI)",
            each
                let
                    texte = Text.From([Label projet]),
                    taille = Text.Length(texte),

                    motifLongueur = 11,

                    liste_des_chiffres = {"0".."9"},
                    
                    positionsPossibles =
                        if taille >= motifLongueur
                        then {0 .. (taille - motifLongueur)}
                        else {},

                    // -------------------------------------------------------------------------
                    // List.Select permet une itération sur toutes les positions de départ possibles
                    // Pour chaque position de départ possible, on extrait une chaîne de 11 caractères (= longueur du motif PR-YYYY-XXXX) qu'on stocke dans la variable bloc
                    // On teste ensuite avec des fonctions de texte la conformité au pattern PR-YYYY-XXX où YYYY et XXX sont des chiffres
                    // On vérifie la possible existence/présence d'un 12ème caractère pour invalider les motifs PR-YYYY-XXXx
                    // La variable matches contient la liste de toutes les correspondances : on choisit arbitrairement de renvoyer la première
                    // -------------------------------------------------------------------------

                    matches =
                        List.Select(
                            positionsPossibles,     
                            (startIndex as number) =>
                                let
                                    bloc = Text.Middle(texte, startIndex, motifLongueur),

                                    is_prefix_OK = Text.Start(bloc, 3) = "PR-",
                                    extraction_annee = Text.Range(bloc, 3, 4),
                                    is_extraction_annee_OK = Text.Select(extraction_annee, liste_des_chiffres) = extraction_annee,

                                    is_second_tiret_OK = Text.At(bloc, 7) = "-",

                                    extraction_id_projet = Text.Range(bloc, 8, 3),
                                    is_extraction_id_projet = Text.Select(extraction_id_projet, liste_des_chiffres) = extraction_id_projet,

                                    is_pattern_OK = is_prefix_OK and is_extraction_annee_OK and is_second_tiret_OK and is_extraction_id_projet,
                                    
                                    existe_12e_char = startIndex + motifLongueur < taille,
                                    char12 =
                                        if  existe_12e_char
                                        then Text.At(texte, startIndex + motifLongueur)
                                        else null,
                                    is_char_12_OK = (char12 = null or char12 = " ")

                                in
                                    is_pattern_OK and is_char_12_OK
                        ),

                    result =
                        if List.Count(matches) > 0
                        then
                            Text.Middle(texte, matches{0}, motifLongueur)
                        else
                            "Référence non identifiée"
                in
                    result
        )
in
    #"Extraction Référence Projet (PBI)"