library(RSelenium)
library(seleniumPipes)
library(dplyr)
library(rvest)
library(stringr)
library(gtools)

path <- 'https://www.otomoto.pl/osobowe/?search%5Border%5D=created_at%3Adesc&page='

remDr <- remoteDr(remoteServerAddr = 'http://localhost',
                  port = 4444,
                  browserName = 'chrome',
                  newSession = T
)

remDr %>% go('https://www.otomoto.pl/osobowe/')

linksVector <- c()

for (i in 1:2) {
  carsUrl <- paste0(path, i)
  print(carsUrl)
  remDr %>% go(carsUrl)
  elements <- remDr %>% findElements(using = 'class name', 'offer-title__link')
  
  for (j in 1:length(elements)) {
    print(elements[[j]] %>% getElementTagName())
    x <- findElementsFromElement(elements[[j]], using = 'tag name', 'a')
    print(x)
    #link <- x[[1]] %>% getElementAttribute('href')
    #print(link)
  }
}

