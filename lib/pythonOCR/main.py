import os

import re
import pytesseract
import cv2

# Connects to the pytesseract dependency
tesseract_path = os.path.join(os.getcwd(), 'Dependencies', 'Tesseract-OCR', 'tesseract.exe')
pytesseract.pytesseract.tesseract_cmd = tesseract_path

# Loads text file containing a list of common buisness names
def load_businesses(file_path):
    with open(file_path, 'r') as file:
        businesses = [line.strip() for line in file if line.strip()]
    return businesses

# Searches in the buisness list text file for a common name in the receipt
def find_establishment_name(words, business_list):
    for word in words:
        for business in business_list:
            if word.lower() == business.lower():
                return business
    return "Unknown Location"

# Uses pytesseract and re to search for common expressions inside of the receipts text
def readReceipt(image_path):
    # Extracts text from the image and then splits it into word segments
    image = cv2.imread(image_path)
    extracted_text = pytesseract.image_to_string(image)
    words = extracted_text.split()

    establishment_name = find_establishment_name(words, load_businesses("lib/pythonOCR/buisness_list.txt"))
    
    date_pattern = r'(\d{1,2}/\d{1,2}/\d{2,4})'
    date_match = re.search(date_pattern, extracted_text)
    date = date_match.group(0) if date_match else "Unknown Date"

    amount_pattern = r"(?i)(?<!Sub)(Total)\s*[:$]?\s*(\d+[\.,]?\d{0,2})(?!.*Subtotal)"
    amount_matches = re.findall(amount_pattern, extracted_text)
    if amount_matches:
        amount = amount_matches[0][1]
    else:
        amount = "0.00"

    return {
        'establishment': establishment_name,
        'date': date,
        'amount': amount
    }