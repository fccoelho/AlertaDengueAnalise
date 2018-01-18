# =============================================================================
# Arquivo de execução do Alerta Dengue: Estado do Ceará
# =============================================================================
setwd("~/")

source("AlertaDengueAnalise/config/config.R") # arquivo de configuracao do alerta (parametros)

# ---- Calcula alerta: 
con <- DenguedbConnect()

# ----- data do relatorio:
data_relatorio = 201801

# Dengue
aleCE <- update.alerta(region = names(pars.CE), state="Ceará", pars = pars.CE, crit = CE.criteria, 
                       datasource = con, sefinal=data_relatorio, writedb = FALSE, adjustdelay = TRUE) 


bolCE <- configRelatorioEstadual(uf="Ceará", sigla = "CE", data=data_relatorio, varcli = "umid_max", tsdur=300,
                                    alert=aleCE, pars = pars.CE, shape=CE.shape, varid=CE.shapeID,
                                    dir=CE.out, datasource=con, geraPDF=TRUE)

publicarAlerta(ale = aleCE, pdf = bolCE, dir = "Relatorio/CE/Estado")



# ----------------- Fortaleza

# Dengue
aleFort <- update.alerta(city = 2304400, pars = pars.CE[["Fortaleza"]], cid10="A90",crit = CE.criteria, 
                         datasource = con, sefinal=data_relatorio, writedb = FALSE, adjustdelay = TRUE)

res = write.alerta(obj = aleFort, write = "db")
#bolFort <- configRelatorioMunicipal(alert = aleFort, tipo = "simples", varcli = "umid_max", siglaUF = "CE", 
#                                    data = data_relatorio, pars = pars.CE,
#                                    dir.out = CE.Fortaleza.out, geraPDF = TRUE)

# Chik 
aleFortC <- update.alerta(city = 2304400, pars = pars.CE.chik[["Fortaleza"]], cid10="A92.0", crit = CE.criteria, 
                         datasource = con, sefinal=data_relatorio, writedb = FALSE, adjustdelay = TRUE, delaymethod = "bayesian")

#Zika
aleFortZ <- update.alerta(city = 2304400, pars = pars.CE.zika[["Fortaleza"]], cid10="A92.8", crit = CE.criteria, 
                          datasource = con, sefinal=data_relatorio, writedb = FALSE, adjustdelay = TRUE, delaymethod="bayesian")

# Boletim Arbo
bolFort <- configRelatorioMunicipal(alert = aleFort, alechik = aleFortC, alezika = aleFortZ, tipo = "simples", varcli = "umid_max", siglaUF = "CE", 
                                   data = data_relatorio, pars = pars.CE,
                                   dir.out = CE.Fortaleza.out, geraPDF = TRUE)


publicarAlerta(ale = aleFort, pdf = bolFort, dir = "Relatorio/CE/Municípios/Fortaleza")

# ----- Fechando o banco de dados
dbDisconnect(con)
