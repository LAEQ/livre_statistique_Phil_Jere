library(pdftools)


pdf_subset('D:/Articles et colloque/Livre en cours/AnalysesQuanti/Livre/livre_statistique_Phil_Jere/_book/livre_statistique_Phil_Jere_clean.pdf',
           pages = c(29,30,307:374),
           output = "D:/Temp/Chapitre9.pdf")

pdf_subset('D:/Articles et colloque/Livre en cours/AnalysesQuanti/Livre/livre_statistique_Phil_Jere/_book/livre_statistique_Phil_Jere_clean.pdf',
           pages = 557:575,
           output = "D:/Temp/Chapitre12.pdf")
