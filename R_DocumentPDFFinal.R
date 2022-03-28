library(pdftools)

#------------------------------------------
# Passer dans le dossier des fichiers html
# Remplacer References par Références
#  Cette partie  fonctionne!
#------------------------------------------
rm(list = ls())
setwd("C:/Temp/_book")
dossier <- getwd()
FilesHTML <- list.files(pattern = "*.html",recursive=TRUE)
lapply(FilesHTML, function(e){
   print(e)
   in.file  <- readLines(e)
   out.file <- gsub("<h3>References</h3>","<h3>R&eacute;f&eacute;rences</h3>", in.file)
   write(out.file, file = e)
 })

#------------------------------------------
# Changer la couverture dans le PDF
#  Cette partie ne fonctionne pas
#------------------------------------------
# Conversion du document word en PDF
fichierWord <- system.file("C:/Temp/CouverturePDF.docx")

# A écrire et le faire manuellement

# Fusion des deux fichiers pdf
CouverturePDF <- "C:/Temp/CouverturePDF.pdf"
LivrePDF <- "C:/Temp/_book/MethodesQuantitScSocialesBolR.pdf"
Npages <- pdf_info(LivrePDF, opw = "", upw = "")$pages

# Extration des pages
pdf_subset(LivrePDF,
           pages = 2:Npages,
           output = "C:/Temp/Titi.pdf")

# Grrr, putain quand on fusionne, on perd les signets...
pdf_combine(c(CouverturePDF, 
              LivrePDF), 
            output = "joined.pdf")

#------------------------------------------
# Envoyer le tout sur le site web
#------------------------------------------