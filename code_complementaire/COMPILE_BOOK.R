rm(list = ls())

# Ne oublier de changer l'auteur avant de lancer le program "PA" ou "JG"
author <- "JG"

# DEFINITION DES CHEMINS VERS LES DEUX DOSSIERS PRINCIPAUX
if(author == "PA"){
  email <- ""
  username <- "appariciop"
  book_dir <- "D:/Articles et colloque/Livre en cours/AnalysesQuanti/Livre/livre_statistique_Phil_Jere"
  website_dir <- "D:/Articles et colloque/Livre en cours/AnalysesQuanti/Livre/WebSite/LivreStatistique_website/LivreMethoQuantBolR"
}else{
  email <- "gelbjeremy22@gmail.com"
  username <- "JeremyGelb"
  book_dir <- "E:/Livres/Livre_stat_PAJG/livre_statistique_Phil_Jere"
  website_dir <- "E:/Livres/Livre_stat_PAJG/LivreMethoQuantBolR"
}

#------------------------------------------
# COMPILATION DU LIVRE EN HTML ET PDF (UN PEU LONG)
#------------------------------------------
setwd(book_dir)
options(bookdown.clean_book = TRUE)
bookdown::clean_book()
rmarkdown::render_site(output_format = 'bookdown::gitbook', encoding = 'UTF-8')

rm(list = ls())
# Ne oublier de changer l'auteur avant de lancer le program "PA" ou "JG"
author <- "JG"

if(author == "PA"){
  email <- ""
  username <- "appariciop"
  book_dir <- "D:/Articles et colloque/Livre en cours/AnalysesQuanti/Livre/livre_statistique_Phil_Jere"
  website_dir <- "D:/Articles et colloque/Livre en cours/AnalysesQuanti/Livre/WebSite/LivreStatistique_website/LivreMethoQuantBolR"
}else{
  email <- "gelbjeremy22@gmail.com"
  username <- "JeremyGelb"
  book_dir <- "E:/Livres/Livre_stat_PAJG/livre_statistique_Phil_Jere"
  website_dir <- "E:/Livres/Livre_stat_PAJG/LivreMethoQuantBolR"
}
setwd(book_dir)
rmarkdown::render_site(output_format = 'bookdown::pdf_book', encoding = 'UTF-8')

#------------------------------------------
# Passer dans le dossier des fichiers html
# Remplacer References par R?f?rences
#  Cette partie fonctionne!
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
# Nettoyer les fichiers actuels
#------------------------------------------
current_site <- list.files(website_dir, full.names = TRUE, recursive = TRUE)
for (file in current_site){
  file.remove(file)
}
current_site <- list.dirs(website_dir)
for (dir in current_site){
  if(dir != website_dir){
    if(grepl(".git", dir, fixed = TRUE) == FALSE){
      print(dir)
      unlink(dir, force = TRUE, recursive = TRUE)
    }
  }

}

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
shell(paste0('cd "',website_dir,'"& git config --global user.email ',email,' & git config --global user.name ',username,' & git add -A & git commit -m "',message,'"'))

#------------------------------------------
# PUSH IT ONLINE
#------------------------------------------
disk_letter <- substr(website_dir,1,1)
shell(paste0('cd "',website_dir,'" & ',disk_letter,': & git push origin'))

