---
title: "Banko Paskolų Duomenų Eksploratyvinė Analizė"
author: "EM"
date: "16/01/2024"
output:
  html_document:
    keep_md: true
---

## Įvadas

Ši ataskaita skirta eksploratyvinei banko paskolų duomenų analizei. Mes įvertinsime pagrindines duomenų tendencijas, atliksime kintamųjų apžvalgą ir vizualizuosime svarbiausius duomenų aspektus.

## Duomenų Paruošimas ir Įkėlimas

Reikalingų bibliotekų įkėlimas:

```r
library(tidyverse)
library(knitr)
library(tibble)
library(ggplot2)
library(scales)
library(DT)
library(dplyr)
library(plotly)
```

Duomenų įkėlimas (naudojamas cache=TRUE efektyvumui užtikrinti):

```r
df <- read.csv("../../../project/1-data/1-sample_data.csv")
```

## Duomenų Rinkinio Apžvalga

Duomenų failo dimensijos:

```
## [1] 1000000       9
```
Duomenų failas turi __1000000 eilučių__ ir __9 stulpelius__, toliau apžvelgiame kintamuosius:

|   |      id        |      y     |amount_current_loan |    term         |credit_score     |loan_purpose     |yearly_income     |home_ownership   | bankruptcies  |
|:--|:---------------|:-----------|:-------------------|:----------------|:----------------|:----------------|:-----------------|:----------------|:--------------|
|   |Min.   :      1 |Min.   :0.0 |Min.   : 10802      |Length:1000000   |Length:1000000   |Length:1000000   |Min.   :    76627 |Length:1000000   |Min.   :0.0000 |
|   |1st Qu.: 250001 |1st Qu.:0.0 |1st Qu.:174394      |Class :character |Class :character |Class :character |1st Qu.:   825797 |Class :character |1st Qu.:0.0000 |
|   |Median : 500001 |Median :0.5 |Median :269676      |Mode  :character |Mode  :character |Mode  :character |Median :  1148550 |Mode  :character |Median :0.0000 |
|   |Mean   : 500001 |Mean   :0.5 |Mean   :316659      |NA               |NA               |NA               |Mean   :  1344805 |NA               |Mean   :0.1192 |
|   |3rd Qu.: 750000 |3rd Qu.:1.0 |3rd Qu.:435160      |NA               |NA               |NA               |3rd Qu.:  1605899 |NA               |3rd Qu.:0.0000 |
|   |Max.   :1000000 |Max.   :1.0 |Max.   :789250      |NA               |NA               |NA               |Max.   :165557393 |NA               |Max.   :7.0000 |
|   |NA              |NA          |NA                  |NA               |NA               |NA               |NA's   :219439    |NA               |NA's   :1805   |
Minėti 9 stulpeliai:

- __`id`__: naudojamas kaip atitinkamos eilutės identifikatorius.
- __`y`__: dvejetainis kintamasis, naudojamas nurodyti, ar suteikti paskolą (1), ar ne (0).
- __`amount_current_loan`__: dabartinės paskolos dydis.
- __`term`__: paskolos išsimokėjimo terminas.
- __`credit_score`__: kreditingumo reitingas.
- __`loan_purpose`__: kokiam tikslui bandoma gauti paskolą.
- __`yearly_income`__: paskolos gavėjo metinio uždarbio dydis.
- __`home_ownership`__: paskolos gavėjo būsto tipas (savininkas, nuomininkas, t.t.).
- __`bankruptcies`__: paskolos gavėjo bankrotų skaičius.

Matome, jog __y__ reikšmės yra rodiklis, ar paskola bus patvirtinta, todėl modeliavime tai bus mūsų pagrindinis kategorinis kintamasis.


# Išsami Duomenų Analizė

Kintamųjų tipų keitimas ir __N/A__ reikšmių analizė:

- Pakeičiame kintamuosius __y__ ir __loan_purpose__ į faktoriaus tipo kintamuosius;
- Apžvelgiame pagrindinius paskolos tikslus;
- Nustatome, kiek __N/A__ reikšmių yra dokumente bei stulpeliuose;

Pagrindinių paskolos tikslų apžvalga:



```{=html}
<div class="datatables html-widget html-fill-item" id="htmlwidget-fa194b10273f1b16c3d7" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-fa194b10273f1b16c3d7">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"],["debt_consolidation","other","home_improvements","business_loan","buy_a_car","medical_bills","buy_house","take_a_trip","major_purchase","small_business","moving","vacation","wedding","educational_expenses","renewable_energy"],[785428,91481,57517,17756,11855,11521,6897,5632,3727,3242,1548,1166,1129,992,109]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>loan_purpose<\/th>\n      <th>n<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":2},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"loan_purpose","targets":1},{"name":"n","targets":2}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```
Didžioji dalis paskolą bando gauti siekiant __padengti jau turimą paskolą__ (arti 80%), kiti tikslai po didžiajai daliai buitiniai (__namų remontas, mašinos pirkimas, kt.__) bei laisvalaikio (__išvykos, poilsis, t.t.__).

  
__N/A__ reikšmių apžvalga:

```{=html}
<div class="datatables html-widget html-fill-item" id="htmlwidget-0daad5504c322d8c8510" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-0daad5504c322d8c8510">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9"],["credit_score","yearly_income","bankruptcies","id","y","amount_current_loan","term","loan_purpose","home_ownership"],[314333,219439,1805,0,0,0,0,0,0]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Stulpelis<\/th>\n      <th>Na_skaicius<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":2},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"Stulpelis","targets":1},{"name":"Na_skaicius","targets":2}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```
__N/A__ reikšmes turi tik trys kintamieji- __credit_score__, __yearly_income__ ir __bankruptcies__. Pagal __N/A__ reikšmių kiekius kintamuosiuose sprendžiame, jog kintamieji __credit_score__ (apie 30% reikšmių- __N/A__) bei __yearly_income__ (apie 20% reikšmių - __N/A__) nebus tokie reikšmingi paskolos suteikimo procese, kaip kad kiti kintamieji.

Atvaizduojame paskolos suteikimo duomenis pagal paskolos tikslą:

```{=html}
<div class="plotly html-widget html-fill-item" id="htmlwidget-7c9637a4d669a1910152" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-7c9637a4d669a1910152">{"x":{"visdat":{"b6506b9d7c8f":["function () ","plotlyVisDat"]},"cur_data":"b6506b9d7c8f","attrs":{"b6506b9d7c8f":{"x":{},"y":{},"color":{},"colors":["red","blue"],"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"bar"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"title":"Paskolos tikslas","type":"category","categoryorder":"array","categoryarray":["buy_a_car","buy_house","business_loan","debt_consolidation","educational_expenses","home_improvements","major_purchase","medical_bills","moving","other","renewable_energy","small_business","take_a_trip","vacation","wedding"]},"yaxis":{"domain":[0,1],"automargin":true,"title":"Paskolų kiekis"},"barmode":"stack","legend":{"title":{"text":"Paskolos statusas"},"labels":["Atmesta","Patvirtinta"]},"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":["buy_a_car","buy_house","business_loan","debt_consolidation","educational_expenses","home_improvements","major_purchase","medical_bills","moving","other","renewable_energy","small_business","take_a_trip","vacation","wedding"],"y":[6045,3245,7400,393553,474,30243,1607,5235,664,46593,42,1090,2762,513,534],"type":"bar","name":"0","marker":{"color":"rgba(255,0,0,1)","line":{"color":"rgba(255,0,0,1)"}},"textfont":{"color":"rgba(255,0,0,1)"},"error_y":{"color":"rgba(255,0,0,1)"},"error_x":{"color":"rgba(255,0,0,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":["buy_a_car","buy_house","business_loan","debt_consolidation","educational_expenses","home_improvements","major_purchase","medical_bills","moving","other","renewable_energy","small_business","take_a_trip","vacation","wedding"],"y":[5810,3652,10356,391875,518,27274,2120,6286,884,44888,67,2152,2870,653,595],"type":"bar","name":"1","marker":{"color":"rgba(0,0,255,1)","line":{"color":"rgba(0,0,255,1)"}},"textfont":{"color":"rgba(0,0,255,1)"},"error_y":{"color":"rgba(0,0,255,1)"},"error_x":{"color":"rgba(0,0,255,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```

