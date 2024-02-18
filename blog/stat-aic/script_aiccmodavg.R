library(AICcmodavg)

## Mazerolle (2006) frog water loss example
data(dry.frog)
head(dry.frog)

##setup a subset of models of Table 1
Cand.models <- list( )
Cand.models[[1]] <- lm(log_Mass_lost ~ Shade + Substrate +
                           cent_Initial_mass + Initial_mass2,
                       data = dry.frog)
Cand.models[[2]] <- lm(log_Mass_lost ~ Shade + Substrate +
                           cent_Initial_mass + Initial_mass2 +
                           Shade:Substrate, data = dry.frog)
Cand.models[[3]] <- lm(log_Mass_lost ~ cent_Initial_mass +
                           Initial_mass2, data = dry.frog)
Cand.models[[4]] <- lm(log_Mass_lost ~ Shade + cent_Initial_mass +
                           Initial_mass2, data = dry.frog)
Cand.models[[5]] <- lm(log_Mass_lost ~ Substrate + cent_Initial_mass +
                           Initial_mass2, data = dry.frog)

Cand.models

##create a vector of names to trace back models in set
Modnames <- paste("mod", 1:length(Cand.models), sep = " ")
Modnames

##generate AICc table with bootstrapped relative
##frequencies of model selection
boot.wt(cand.set = Cand.models, modnames = Modnames, sort = TRUE, nsim = 100) #number of iterations should be much higher

##Burnham and Anderson (2002) flour beetle data
## Not run: 
data(beetle)
beetle

##models as suggested by Burnham and Anderson p. 198          
Cand.set <- list( )
Cand.set[[1]] <- glm(Mortality_rate ~ Dose, family =
                         binomial(link = "logit"), weights = Number_tested,
                     data = beetle)
Cand.set[[2]] <- glm(Mortality_rate ~ Dose, family =
                         binomial(link = "probit"), weights = Number_tested,
                     data = beetle)
Cand.set[[3]] <- glm(Mortality_rate ~ Dose, family =
                         binomial(link ="cloglog"), weights = Number_tested,
                     data = beetle)

##create a vector of names to trace back models in set
Modnames <- paste("Mod", 1:length(Cand.set), sep = " ")
Modnames

##model selection table with bootstrapped
##relative frequencies
boot.wt(cand.set = Cand.set, modnames = Modnames, nsim = 100, sort = TRUE)
