library(dplyr)
library(rvest)
library(stringr)
library(gtools)
library(xml2)

carsList <- c("acura", "alfa-romeo", "aston-martin", "audi", "austin", "bentley", "bmw", "buick", "cadillac", "chevrolet", "chrysler", "citroen", "dacia", "daewoo", "daihatsu", "dodge",
              "ferrari", "fiat", "ford", "gaz", "gmc", "honda", "hummer", "hyundai", "infiniti", "isuzu", "iveco", "jaguar", "jeep", "kia", "lada", "lamborghini", "lancia", "land-rover",
              "lexus", "lincoln", "maserati", "mazda", "mercedes-benz", "mg", "mini", "mitsubishi", "nissan", "opel", "peugeot", "pontiac", "porsche", "renault", "rolls-royce", "rover", 
              "saab", "seat", "skoda", "smart", "ssangyong", "subaru", "suzuki", "toyota", "trabant", "volkswagen", "volvo", "tesla", "cupra", "ds-automobiles")

length(carsList)

# collecting links for each car

links <- NULL
for (i in 1:2) {
  newPage <- paste0("https://www.otomoto.pl/osobowe/?search%5Border%5D=created_at%3Adesc&page=", i)
  linksSet <- read_html(newPage) %>% html_nodes(xpath = "//a[@class='offer-title__link']") %>% xml_attr('href')
  links <- c(links, linksSet)
}

linksUnique <- links %>% unique()
linksUnique

# collecting data for each car and put in into data frame
carsDataFrame <- NULL

for (x in 1:length(linksUnique)) {
  page <- read_html(linksUnique[x])
  
  price <- html_node(page, xpath = "//div[@class='offer-price']") %>% xml_attr('data-price')
  
  labelsList <- xml_find_all(page, "//span[@class='offer-params__label']") %>% html_text()
  
  valuesList <- xml_find_all(page, "//div[@class='offer-params__value']") %>% html_text()
  valuesList <- trimws(valuesList)
  
  df1 <- data.frame(matrix(valuesList, nrow = 1, ncol = length(valuesList)))
  
  names(df1) <- labelsList
  
  df1 <- cbind(price, df1)
  
  if(is.null(carsDataFrame)) {
    carsDataFrame <- df1
  } else {
    carsDataFrame <- smartbind(carsDataFrame, df1)
  }
}

View(carsDataFrame)


