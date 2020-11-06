#
# refaire avec lme4 avec la fonction lmer
# https://rpubs.com/rslbliss/r_mlm_ws#:~:text=To%20run%20a%20multilevel%20linear,we%20have%20used%20thus%20far.&text=Note%20that%20R%20uses%20restricted%20maximum%20likelihood%20to%20fit%20the%20model.
#
# glmer pour les autres distributions
# https://errickson.net/stats-notes/vizrandomeffects.html


# CHARGEMENT DES LIBRARIES -----------------------------------------------------
library(car)
library(lme4)
library(ggplot2)
library(performance)
library(MuMIn)

rm(list=ls())
setwd("D:/Articles et colloque/Livre en cours/AnalysesQuanti/Livre/livre_statistique_Phil_Jere/temp")

# CHARGEMENT DES DONNÉES ------------------------------------------------------
# Importation d'un fichier SAS avec le paquet sas7bdat
load("Multiniveau.Rdata")

# MODÈLE 1 : modèle vide (sans prédicteurs) ------------------------------------------------------
# PCTArb : variable dépendante (% de végétation dans le tronçon de rues i situé dans le secteur de recensement j)
# SRNOM : code du niveau 2, soit le secteur de recensement
# Écrire Y ~ 1 signifie que le modèle est vide
Modele1 <- lmer(PCTArb ~ 1 + (1| SRNOM), data = Multiniveau)

# Résultats du modèle
summary(Modele1)

# Qualité d'ajustement du modèle
cat("\nStatistiques d'ajustement du modèle",
    "\n-2 Log L = ", -2*logLik(Modele1),
    "\nAIC =", AIC(Modele1), "\nBIC =", BIC(Modele1))

# Calcul de l'ICC (coefficient intra-classe)
performance::icc(Modele1)
performance::r2(Modele1)
ICC1 <- performance::icc(Modele1)
cat("\nPart de la variance de la variable dépendante ",
   "\nimputable au niveau 2 : ", round(ICC1$ICC_adjusted*100,2), "%", sep="")

r.squaredGLMM(Modele1)


# MODÈLE 2 : modèle avec les prédicteurs au niveau 1 (rues) ------------------------------------------------------
#   Width Length           						Largeur et longueur de la rue
#   AgeMed AgeMed2                    Age médian des bâtiment
#   ResiPCT CommPCT InduPCT Parc01    Occupations du sol
#   DupPCT TripPCT UniPCT             Types de bâtiments
#   Setback									          Espacement entre le bâtiment et la rue
#   CBDkm									            Distance au centre-ville

Modele2 <- lmer(PCTArb ~ 1 +
                   Width+Length+AgeMed+AgeMed2+ResiPCT+CommPCT+InduPCT+Parc01+DupPCT+TripPCT+UniPCT+Setback+CBDkm+
                   (1| SRNOM), data = Multiniveau)

# Résultats du modèle
summary(Modele2)

# Qualité d'ajustement du modèle
cat("\nStatistiques d'ajustement du modèle",
    "\n-2 Log L = ", -2*logLik(Modele2),
    "\nAIC =", AIC(Modele2), "\nBIC =", BIC(Modele2))

# Calcul de l'ICC (coefficient intra-classe)
performance::icc(Modele2)
ICC2 <- performance::icc(Modele2)
cat("\nPart de la variance de la variable dépendante ",
    "\nimputable au niveau 2 : ", round(ICC2$ICC_adjusted*100,2), "%", sep="")

# MODELE 3 : modèle avec les prédicteurs au niveaux 1 et 2 (rues et secteurs de recensement) ------------------------------------------------------
Modele3 <- lmer(PCTArb ~ 1 +
                  Width+Length+AgeMed+AgeMed2+ResiPCT+CommPCT+InduPCT+Parc01+DupPCT+TripPCT+UniPCT+Setback+CBDkm+
                  (1| SRNOM)+
                  PCT_MV+PCTFRAVI+P65PCT+LocaPCT+UDipPCT+ValLog,
                  data = Multiniveau)


rm(list=ls())
load("Multiniveau.Rdata")
VarsNiv <- c("Width","Length","AgeMed","AgeMed2","ResiPCT","CommPCT","InduPCT","Parc01","DupPCT","TripPCT","UniPCT","Setback","CBDkm")
for (e in VarsNiv){
  varcentre <- paste(e,"_Moy0", sep="")
  Multiniveau[[varcentre]] <- Multiniveau[[e]] - mean(Multiniveau[[e]])
}


Modele3 <- lmer(PCTArb ~ 1 +
                  Width_Moy0+Length_Moy0+AgeMed_Moy0+AgeMed2_Moy0+ResiPCT_Moy0+CommPCT_Moy0+
                  InduPCT_Moy0+Parc01_Moy0+DupPCT_Moy0+TripPCT_Moy0+UniPCT_Moy0+Setback_Moy0+CBDkm_Moy0+
                  (1| SRNOM)+
                  PCT_MV+PCTFRAVI+P65PCT+LocaPCT+UDipPCT+ValLog,
                data = Multiniveau)


# Résultats du modèle
summary(Modele3)

# Qualité d'ajustement du modèle
cat("\nStatistiques d'ajustement du modèle",
    "\n-2 Log L = ", -2*logLik(Modele3),
    "\nAIC =", AIC(Modele3), "\nBIC =", BIC(Modele3))

# Calcul de l'ICC (coefficient intra-classe)
performance::icc(Modele3)
ICC3 <- performance::icc(Modele3)
cat("\nPart de la variance de la variable dépendante ",
    "\nimputable au niveau 2 : ", round(ICC3$ICC_adjusted*100,2), "%", sep="")

# COMPARAISON DES MODÈLES ------------------------------------------------------
c_logLik <- c(-2*logLik(Modele1),-2*logLik(Modele2),-2*logLik(Modele3))
ICC <- c(performance::icc(Modele1)$ICC_adjusted,
         performance::icc(Modele2)$ICC_adjusted,
         performance::icc(Modele3)$ICC_adjusted)

print(data.frame(
            Modele = c("Modèle 1 (vide)", "Modèle 2 (VI : niv. 1)", "Modèle 3 (VI : niv. 1 et 2)"),
            Moins2LogLik = c_logLik,
            dl = AIC(Modele1, Modele2, Modele3)$df,
            AIC = AIC(Modele1, Modele2, Modele3)$AIC,
            ICCpct = round(ICC*100,2)
))
