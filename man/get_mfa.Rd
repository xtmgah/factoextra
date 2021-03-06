% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_mfa.R
\name{get_mfa}
\alias{get_mfa}
\alias{get_mfa_ind}
\alias{get_mfa_var}
\alias{get_mfa_partial_axes}
\title{Extract the results for individuals/variables/group/partial axes - MFA}
\usage{
get_mfa(res.mfa, element = c("ind", "quanti.var", "quali.var", "group",
  "partial.axes"))

get_mfa_ind(res.mfa)

get_mfa_var(res.mfa, element = c("quanti.var", "quali.var", "group"))

get_mfa_partial_axes(res.mfa)
}
\arguments{
\item{res.mfa}{an object of class MFA [FactoMineR].}

\item{element}{the element to subset from the output. Possible values are "ind", "quanti.var", "quali.var", "group" or "partial.axes".}
}
\value{
a list of matrices containing the results for the active 
individuals/quantitative variable categories/qualitative variable categories/groups/partial axes including : 
\item{coord}{coordinates for the individuals/quantitative variable categories/qualitative variable categories/groups/partial axes}
\item{cos2}{cos2 for the individuals/quantitative variable categories/qualitative variable categories/groups/partial axes}
\item{contrib}{contributions of the individuals/quantitative variable categories/qualitative variable categories/groups/partial axes}
\item{inertia}{inertia of the individuals/quantitative variable categories/qualitative variable categories/groups/partial axes}
}
\description{
Extract all the results (coordinates, squared cosine and contributions) 
for the active individuals/quantitative variables/qualitative variable categories/groups/partial axes from Multiple Factor Analysis (MFA) outputs.\cr\cr
\itemize{
\item get_mfa(): Extract the results for variables and individuals
\item get_mfa_ind(): Extract the results for individuals only
\item get_mfa_var(): Extract the results for variables (quantitatives, qualitatives and groups)
\item get_mfa_partial_axes(): Extract the results for partial axes only
}
}
\examples{
# Multiple Factor Analysis
# ++++++++++++++++++++++++
# Install and load FactoMineR to compute MFA
# install.packages("FactoMineR")
library("FactoMineR")
data(poison)
res.mfa <- MFA(poison, group=c(2,2,5,6), type=c("s","n","n","n"),
name.group=c("desc","desc2","symptom","eat"), num.group.sup=1:2,
graph = FALSE)
 
 # Extract the results for qualitative variable categories
 var <- get_mfa_var(res.mfa, "quali.var")
 print(var)
 head(var$coord) # coordinates of qualitative variables
 head(var$cos2) # cos2 of qualitative variables
 head(var$contrib) # contributions of qualitative variables
 
 # Extract the results for individuals
 ind <- get_mfa_ind(res.mfa)
 print(ind)
 head(ind$coord) # coordinates of individuals
 head(ind$cos2) # cos2 of individuals
 head(ind$contrib) # contributions of individuals
 
 # You can also use the function get_mfa()
 get_mfa(res.mfa, "ind") # Results for individuals
 get_mfa(res.mfa, "quali.var") # Results for qualitative variable categories
 
}
\author{
Alboukadel Kassambara \email{alboukadel.kassambara@gmail.com}

Fabian Mundt \email{f.mundt@inventionate.de}
}
