import urllib2 as urllib
import json
import oauth2 as oauth
from optparse import OptionParser

access_token_key = ""
access_token_secret = ""

consumer_key = ""
consumer_secret = ""

oauth_token    = oauth.Token(key=access_token_key,secret=access_token_secret)
oauth_consumer = oauth.Consumer(key=consumer_key,secret=consumer_secret)

signature_method_hmac_sha1 = oauth.SignatureMethod_HMAC_SHA1()

http_method = "GET"
_debug = 0

http_handler  = urllib.HTTPHandler(debuglevel=_debug)
https_handler = urllib.HTTPSHandler(debuglevel=_debug)

'''
Construct, sign, and open a twitter request
using the hard-coded credentials above.
'''

def twitterreq(url, method, parameters):
  req = oauth.Request.from_consumer_and_token(oauth_consumer,
                                              token=oauth_token,
                                              http_method=http_method,
                                              http_url=url,
                                              parameters=parameters)

  req.sign_request(signature_method_hmac_sha1, oauth_consumer, oauth_token)

  headers = req.to_header()

  if http_method == "POST":
    encoded_post_data = req.to_postdata()
  else:
    encoded_post_data = None
    url = req.to_url()


  opener = urllib.OpenerDirector()
  opener.add_handler(http_handler)
  opener.add_handler(https_handler)

  response = opener.open(url, encoded_post_data)

  return response

def fetchsamples(location):
#  url = "https://stream.twitter.com/1/statuses/sample.json"
#  url = "https://stream.twitter.com/1.1/statuses/filter.json?locations=-74,40,-73,41" # NY
#  url = "https://stream.twitter.com/1.1/statuses/filter.json?locations=37.5,48.8,37.7,48.9" # Slaviansk
#  url = "https://stream.twitter.com/1.1/statuses/filter.json?locations=82.8,54.1,83.1,54.8" # Novosibirsk
  url = {
     'm': "https://stream.twitter.com/1.1/statuses/filter.json?locations=37.4,55.5,37.9,55.9", # Moscow
     'k': "https://stream.twitter.com/1.1/statuses/filter.json?locations=30.4,50.3,30.8,50.6", # Kiev
     'n': "https://stream.twitter.com/1.1/statuses/filter.json?locations=82.8,54.1,83.1,54.8" # Novosibirsk
  }[location]

  parameters = []
  response = twitterreq(url, "GET", parameters)
  for line in response:
    print line.strip()

if __name__ == '__main__':
  parser = OptionParser()
  parser.add_option("-l", "--loc", dest="location", help="Moscow/Kiev")
  options, arguments = parser.parse_args()
  fetchsamples(options.location)

##response = urllib.urlopen("http://search.twitter.com/search.json?q=crimea")
#print json.load(response)

