library(dplyr)
library(rvest)
library(stringr)
library(gtools)
library(xml2)
library(progress)

carsList <- c("alfa-romeo", "audi", "bmw", "cadillac", "chevrolet", "chrysler", "citroen", "dacia", "daewoo", "daihatsu", 
              "dodge", "fiat", "ford", "honda", "hyundai", "infiniti", "jaguar", "jeep", "kia", "lancia", "land-rover",
              "lexus", "maserati", "mazda", "mercedes-benz", "mini", "mitsubishi", "nissan", "opel", "peugeot", "porsche", 
              "renault", "saab", "seat", "skoda", "smart", "ssangyong", "subaru", "suzuki", "toyota", "volkswagen", "volvo")

length(carsList)

# collecting links for each car

NCars <- length(carsList)

links <- NULL
pb <- progress_bar$new(total = NCars)
for (car in 1:NCars) {
  for (i in 1:2) {
    newPage <- paste0(paste0(paste0(paste0("https://www.otomoto.pl/osobowe/"), carsList[car]), "/?search%5Border%5D=created_at%3Adesc&search%5Bbrand_program_id%5D%5B0%5D=&search%5Bcountry%5D=&page="), i)
    linksSet <- read_html(newPage) %>% html_nodes(xpath = "//a[@class='offer-title__link']") %>% xml_attr('href')
    links <- c(links, linksSet)
  }
  pb$tick()
}

length(links)

linksUnique <- links %>% unique()
length(linksUnique)

# make function to collecting data from every link

makeRow <- function(x, linksUnique) {
  page <- read_html(linksUnique[x])
  
  cena <- html_node(page, xpath = "//div[@class='offer-price']") %>% xml_attr('data-price')
  
  labelsList <- xml_find_all(page, "//span[@class='offer-params__label']") %>% html_text()
  
  valuesList <- xml_find_all(page, "//div[@class='offer-params__value']") %>% html_text()
  valuesList <- trimws(valuesList)
  
  df1 <- data.frame(matrix(valuesList, nrow = 1, ncol = length(valuesList)))
  
  names(df1) <- labelsList
  
  df1 <- cbind(cena, df1)
}


carsDataFrame <- NULL

NLinks <- length(linksUnique)

pb <- progress_bar$new(total = NLinks)

for (x in 1:NLinks) {
  skip <- FALSE
  tryCatch(
    df1 <- makeRow(x, linksUnique), error = function(e) {skip <<- TRUE}
  )
  if(skip){next}
  if(is.null(carsDataFrame)) {
    carsDataFrame <- df1
  } else {
    carsDataFrame <- smartbind(carsDataFrame, df1)
  }
  pb$tick()
}

View(carsDataFrame)

write.csv(carsDataFrame, 'cars_otomoto.csv')


