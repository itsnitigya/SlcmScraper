import mechanize
from sys import argv
from bs4 import BeautifulSoup
from pprint import pprint
import json
import logging
from flask import Flask, request , Response

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
URL = "http://slcm.manipal.edu/{}"

def login(regno, password):
    """
    Logs the user in and returns the driver.
    Handles wrong credentials, etc. (Returns none in that case)
    """
    driver = mechanize.Browser()
    response = driver.open(URL.format('loginform.aspx'))
    logger.info("Opened login form in driver")

    driver.select_form("form1")
    logger.info("Selected form")

    driver.form["txtUserid"] = regno
    driver.form["txtpassword"] = password
    driver.method = "POST"

    response = driver.submit()
    logger.info("Submitted form")

    try:
        driver.open(URL.format('Academics.aspx'))
        logger.info("User authenticated")
    except Exception: ## User has given wrong credentials
        logger.warn("User credentials were wrong")
        return None 

    return driver


def construct(driver, regno):

    if driver is None:
        return "{ error : 'Invalid credentials' }"

    try:
        logger.info("Opening academics page")
        response = driver.open(URL.format('Academics.aspx')) ## Get marks, attendance ##
        source = response.read()
        logger.info("Opened academics page")

        logger.info("Getting Internal Marks")
        m = marks(source)
        logger.info("Got Internal Marks")

    except Exception as e:
        logger.error("Failed to open academics page", exc_info=True)
        return "{ error : 'Could not fetch attendance and internal marks.'}"

    response = {"Regno" : regno, "marks":m}

    return response

def marks(source):

    response = {}
    soup = BeautifulSoup(source, 'html.parser')
    for i in range(8):
        divs = soup.find('div' , {'class' : 'panel-group internalMarks'})
        div = divs.find('div' , {'id': "ContentPlaceHolder1_RepeaterPrintInternal_pnlAssignment_{}".format(i)})
        divlab = divs.find('div' , {'id': "ContentPlaceHolder1_RepeaterPrintInternal_pnlAssignmentLab_{}".format(i)})
        if div:
            divt = divs.find_all('div' , {'class': 'panel-heading'})
            sub = divt[i].find('a')
            line = str(sub.text).rstrip()
            line = line.strip()
            table = div.find('table')
            all_tr = table.find_all('tr')
            all_tr = all_tr[1:] 
            for tr in all_tr:
                tds = tr.find_all('td')
                row = str(tds[0].text)
                total = str(tds[1].text)
                obtain = str(tds[2].text)
                add = {
                    "enter": "true",
                    "row" : row,
                    "total": total,
                    "obtain": obtain,
                    "subject": line
                }
                response["{}".format(i)] = add
        elif divlab:
            divt = divs.find_all('div' , {'class': 'panel-heading'})
            sub = divt[i].find('a')
            line = str(sub.text).rstrip()
            line = line.strip()
            table = divlab.find('table')
            all_tr = table.find_all('tr')
            all_tr = all_tr[1:] 
            for tr in all_tr:
                tds = tr.find_all('td')
                row = str(tds[0].text)
                total = str(tds[1].text)
                obtain = str(tds[2].text)
                add = {
                    "enter": "true",
                    "row" : row,
                    "total": total,
                    "obtain": obtain,
                    "subject": line
                }
                response["{}".format(i)] = add
        else:
            divt = divs.find_all('div' , {'class': 'panel-heading'})
            sub = divt[i].find('a')
            line = str(sub.text).rstrip()
            line = line.strip()
            add = {
                    "enter": "false",
                    "subject": line
                }
            response["{}".format(i)] = add

    return response

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello from Flask!'

@app.route('/getdata' , methods=['POST'])
def homepage():
    content = request.json
    if "event_id" in content:
        response = {}
        event_id = int(content["event_id"])
        reg = content["reg"]
        password = content["password"]
        driver = login(reg, password)
        response = construct(driver, reg)
        response["success"] = True
        return Response( json.dumps(response) , status = 200 , mimetype='application/json')
    else:
        return Response( "{\"success\":\"false\"}" , status = 200 , mimetype='application/json')

if __name__ == '__main__':
    app.run()



