rm(list = ls())

author <- "PA"

# DEFINITION DES CHEMINS VERS LES DEUX DOSSIERS PRINCIPAUX
book_dir <- "C:/Users/GelbJ/Desktop/Projets/Philippe/__Livre_statistique/livre_statistique_Phil_Jere"
website_dir <- "C:/Users/GelbJ/Desktop/Projets/Philippe/__Livre_statistique/WebSite/LivreStatistique_website"

#------------------------------------------
# COMPILATION DU LIVRE EN HTML ET PDF (UN PEU LONG)
#------------------------------------------
setwd(book_dir)
bookdown::clean_book()
rmarkdown::render_site(output_format = 'bookdown::pdf_book', encoding = 'UTF-8')
rmarkdown::render_site(output_format = 'bookdown::gitbook', encoding = 'UTF-8')

#------------------------------------------
# Passer dans le dossier des fichiers html
# Remplacer References par R?f?rences
#  Cette partie  fonctionne!
#------------------------------------------

dossier <- getwd()
FilesHTML <- list.files(pattern = "*.html",recursive=TRUE)
lapply(FilesHTML, function(e){
  print(e)
  in.file  <- readLines(e)
  out.file <- gsub("<h3>References</h3>","<h3>R&eacute;f&eacute;rences</h3>", in.file)
  write(out.file, file = e)
})

#------------------------------------------
# COPIE DE TOUS LES FICHIERS DU LIVRE
#------------------------------------------
folder1 <- paste0(book_dir,"/_book")
commande <- paste0('Xcopy "',folder1,'" "',website_dir,'" /E')
system(commande)

#------------------------------------------
# STAGE AND COMMIT ALL CHANGE IN GIT
#------------------------------------------
setwd(website_dir)
message <- paste0("Upload of the book the : ",Sys.Date(),", by : ",author)
shell(paste0('cd "',website_dir,'" & git add -A & git commit -m "',message,'"'))

#------------------------------------------
# PUSH IT ONLINE
#------------------------------------------
shell(paste0('cd "',website_dir,'" git push origin'))

