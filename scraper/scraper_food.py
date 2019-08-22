import requests
from bs4 import BeautifulSoup
from selenium import webdriver
import re
from string import digits


def get_categories(i):
	cat_sel_table = driver.find_element_by_id('recipeListing')
	cat_sel_list = cat_sel_table.find_elements_by_css_selector('li')

	cat_soup = BeautifulSoup(cat_page, 'html.parser')
	cat_soup_table = cat_soup.find("div", id="recipeListing")
	cat_soup_links = cat_soup_table.find_all('a', href=True)

	category_image = cat_soup_links[i].find("source")['srcset']
	category_link = cat_soup_links[i].find("h2", {"class": "recipe-image-header"})
	category_name = ''.join(category_link.findAll(text=True))

	return [category_name, category_image, cat_sel_list]

def get_foods(i, driver):
	food_sel_list = get_paginated_foods(driver)

	food_soup = BeautifulSoup(driver.page_source, 'html.parser')
	food_soup_table = food_soup.find("div", id="recipeListing")
	food_soup_links = food_soup_table.find_all('a', href=True)

	food_image = food_soup_links[i].find("source")['srcset']
	food_link = food_soup_links[i].find("h2", {"class": "recipe-image-header"})
	food_name = ''.join(food_link.findAll(text=True))

	return [food_name, food_image, food_sel_list]

def get_ingredients(ing_page):
	ing_soup = BeautifulSoup(ing_page, 'html.parser')
	ing_soup_table = ing_soup.find("div", {"class": "keyword_tag"})

	ing_text = ''
	if ing_soup_table:
		ing_text = ''.join(ing_soup_table.findAll(text=True))
		ing_text = re.sub(r' \([^)]*\)', '', ing_text)
		ind = ing_text.index(': ')
		ing_text = ing_text[ind+1: len(ing_text)]
		ing_text = ing_text.replace('/', ', ')
	else:
		ing_soup_table = ing_soup.find("div", {"class": "ingredients"})
		ing_soup_list = ing_soup_table.find_all("li")
		ing_text = ''
		for t in ing_soup_list:
			tex = ''.join(t.findAll(text=True))
			remove_digits = str.maketrans('', '', digits)
			tex = tex.translate(remove_digits)
			if 'of ' in tex:
				ind = tex.index('of ')
				tex = tex[ind+3: len(tex)]
			if ',' in tex:
				ind = tex.index(',')
				tex = tex[0: ind]
			tex = tex.strip()
			ing_text += f'{tex}, '
		ing_text = ing_text[0: len(ing_text) - 2]

	return ing_text


def get_paginated_foods(driver):
	pag_divs_sel = []
	food_links_soup = []
	pagination_sel = driver.find_element_by_id('pagination')
	while(True):
		food_soup = BeautifulSoup(driver.page_source, 'html.parser')
		food_table_soup = food_soup.find("div", id="recipeListing")
		food_links_soup = food_table_soup.find_all('li')
		is_empty_text = ''.join(food_links_soup[len(food_links_soup)-1].findAll(text=True))

		if is_empty_text.lower() == "no record found":
			food_sel_table = driver.find_element_by_id('recipeListing')
			pag_divs_sel = food_sel_table.find_elements_by_css_selector("li")
			break;
		else:
			aaa = {"behaviour": "instant"}
			driver.execute_script("arguments[0].scrollIntoView(arguments[1]);", pagination_sel, aaa)
			pagination_sel.click()
	return pag_divs_sel[0: len(food_links_soup) - 3]


if __name__ == '__main__':

	file = open('food_data.txt', 'w+')

	driver = webdriver.Chrome()
	driver.get('https://food.ndtv.com/recipes')

	cat_page = driver.page_source

	cat_sel_table = driver.find_element_by_id('recipeListing')
	cat_sel_list = cat_sel_table.find_elements_by_css_selector('li')

	for i in range(len(cat_sel_list)):
		count = 0
		cat_data = get_categories(i)
		cat_data[2][i].click()

		food_page = driver.page_source

		food_sel_list = get_paginated_foods(driver)

		for n in range(len(food_sel_list)):
			count += 1

			food_data = get_foods(n, driver)
			element = food_data[2][n]
			aaa = {"behaviour": "instant"}
			driver.execute_script("arguments[0].scrollIntoView(arguments[1]);", element, aaa) 
			element.click()

			ing_data = get_ingredients(driver.page_source)

			cat_row = f'{{\n\t\tname: {cat_data[0]},\n\t\tpicture: {cat_data[1]}\n\t}}'
			food_row = f'{food_data[0]}: {{\n\tname: {food_data[0]},\n\tpicture: {food_data[1]},\n\tcategory: {cat_row},\n\tingredients: {ing_data}\n}}\n'
			file.write(food_row)
			print(f'{count} --> {cat_data[0]} --> {food_data[0]}')

			driver.back()

		driver.back()

	driver.close()