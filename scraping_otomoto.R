library(dplyr)
library(rvest)
library(stringr)
library(gtools)
library(xml2)


links <- NULL
for (i in 1:3) {
  newPage <- paste0("https://www.otomoto.pl/osobowe/?search%5Border%5D=created_at%3Adesc&page=", i)
  linksSet <- read_html(newPage) %>% html_nodes(xpath = "//a[@class='offer-title__link']") %>% xml_attr('href')
  links <- c(links, linksSet)
}

linksUnique <- links %>% unique()
linksUnique
