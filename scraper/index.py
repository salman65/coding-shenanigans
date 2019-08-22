import requests
from bs4 import BeautifulSoup

# change home URL
home = 'https://web.archive.org/web/20121007172955/https://www.nga.gov/collection/anZ1.htm'

page = requests.get(home)
soup = BeautifulSoup(page.text, 'html.parser')

# change class to required table or table class
links_table = soup.find(class_="BodyText")

links = links_table.find_all('a', href=True)

# loop for all links
goto = 'https://web.archive.org' + links[0]['href']

profile = requests.get(goto)
soup_prof = BeautifulSoup(profile.text, 'html.parser')

links_tab = soup_prof.find(class_="BodyText")

links2 = links_tab.find_all('b')

file = open('data.txt', 'w+')

for i in links2:
	file.write(str(i) + '\n')
