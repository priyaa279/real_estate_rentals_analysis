from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import pandas as pd
import time

# List of ZIP codes to scrape
zip_codes = [
    "77002", "77003", "77004", "77005", "77006", "77007", "77008", "77009", "77010", "77011",
    "77012", "77013", "77014", "77015", "77016", "77017", "77018", "77019", "77020", "77021",
    "77022", "77023", "77024", "77025", "77026", "77027", "77028", "77029", "77030", "77031",
    "77032", "77033", "77034", "77035", "77036", "77037", "77038", "77039", "77040", "77041",
    "77042", "77043", "77044", "77045", "77046", "77047", "77048", "77049", "77050", "77051",
    "77053", "77054", "77055", "77056", "77057", "77058", "77059", "77060", "77061", "77062",
    "77063", "77064", "77065", "77066", "77067", "77068", "77069", "77070", "77071", "77072",
    "77073", "77074", "77075", "77076", "77077", "77078", "77079", "77080", "77081", "77082",
    "77083", "77084", "77085", "77086", "77087", "77088", "77089", "77090", "77091", "77092",
    "77093", "77094", "77095", "77096", "77098", "77099"
]

# Setup Chrome
options = Options()
options.add_argument("--start-maximized")  # comment out if using headless
# options.add_argument("--headless")       # uncomment for silent execution

# Start driver
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
all_data = []

for zip_code in zip_codes:
    print(f"\nScraping ZIP: {zip_code}")
    page = 1
    while True:
        url = f"https://www.redfin.com/zipcode/{zip_code}/page-{page}"
        print(f"Scraping {url}")
        driver.get(url)

        try:
            WebDriverWait(driver, 10).until(
                EC.presence_of_all_elements_located((By.CLASS_NAME, "HomeCardContainer"))
            )
        except:
            print("Listings did not load or no listings found.")
            break

        listings = driver.find_elements(By.CLASS_NAME, "HomeCardContainer")
        print(f"Found {len(listings)} listings on this page.")

        if not listings:
            break

        for listing in listings:
            try:
                price = listing.find_element(By.CLASS_NAME, "bp-Homecard__Price--value").text
                address = listing.find_element(By.CLASS_NAME, "bp-Homecard__Address").text
                beds = listing.find_element(By.CLASS_NAME, "bp-Homecard__Stats--beds").text
                baths = listing.find_element(By.CLASS_NAME, "bp-Homecard__Stats--baths").text
                sqft = listing.find_element(By.CLASS_NAME, "bp-Homecard__LockedStat--value").text

                all_data.append({
                    "zipcode": zip_code,
                    "price": price,
                    "address": address,
                    "beds": beds.strip(),
                    "baths": baths.strip(),
                    "sqft": sqft.strip()
                })
            except Exception:
                continue

        # Try to go to the next page
        try:
            next_page_href = f"/zipcode/{zip_code}/page-{page + 1}"
            driver.find_element(By.CSS_SELECTOR, f'a[href="{next_page_href}"]')
            page += 1
            time.sleep(1.5)
        except:
            print("⏹ No next page found.")
            break

# Done
print(f"\nScraping complete. Total listings: {len(all_data)}")
driver.quit()

# Save to CSV
df = pd.DataFrame(all_data)
df.to_csv("PropertyListings.csv", index=False)
print("\nData saved to PropertyListings.csv")
