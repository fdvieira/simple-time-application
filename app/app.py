from flask import Flask,jsonify,request,render_template,Response
from datetime import datetime
import os
import pytz

app = Flask(__name__)

def datetimezone(timezone):
    JST = pytz.timezone(timezone)

    hours_timezone = datetime.now(JST)
    format_timezene = hours_timezone.strftime('%Y:%m:%d %H:%M:%S %Z %z')
    return format_timezene

@app.route("/")
def homepage():
    timezones = ["Tokyo local datetime: " + datetimezone("Asia/Tokyo"), 
    "Berlin local datetime: " + datetimezone("Europe/Berlin"),
    "New york local datetime: " + datetimezone("America/New_York")]

    return render_template('index.html', timezones=timezones)

@app.route('/health', methods = ['GET'])
def health():
    return jsonify(
        statusCode=200
    ), 200

if __name__=='__main__':
	app.run(debug=True, host='0.0.0.0', port=8080)
