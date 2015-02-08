import sys
import json
import re
import time

userActivity  = {}

def main():

  output = open('stat2.txt','w')
  output.write( "postId," + "userId," + "Lat," + "Log," + "PostLength," + "DateTime," + "Text" + "\n")
#  output.write( "postId," + "userId," + "PostLength," + "DateTime\n")

  # load each tweet as json
  for line in open(sys.argv[1]):
    tweet_json = json.loads(line)

    emoji_dict = open('emoji.json','r')
    emoji_json = json.loads(emoji_dict.readline())

    emoji_list = {}
    for emo in emoji_json.items():
       emoji_list[ emo[1][0] ] = ":"+emo[1][1][0]+":"

    # only accept records with a 'user' field
    if tweet_json.get('user'):
      postId   = tweet_json['id']
      userId   = tweet_json['user']['id']
      userName = tweet_json['user']['name'].encode('utf8')
      location = tweet_json['user']['location'].encode('utf8')
      time_at  = re.sub(r'\+0000 ','', tweet_json['created_at'] )
      text     = tweet_json['text'].encode('utf8')
      text     = re.sub(r'"','``', text )
      plainTxt = text.decode('utf8')

      # decode emojis
      for c in text.decode('utf8'):
         if c in emoji_list :
            plainTxt = re.sub(c, emoji_list[c], plainTxt)

      # purge remaining unknown emojis
      myre = re.compile(u'['
         u'\U0001F300-\U0001F64F'
         u'\U0001F680-\U0001F6FF'
         u'\u2600-\u26FF\u2700-\u27BF'
         u'\U000FE4EC]+', 
         re.UNICODE)
      #\ud83c\udf88\udbb9\udcec

      text = myre.sub(':emoji:',plainTxt).encode('utf-8')

      place    = tweet_json['place']['name'].encode('utf8')
      placeId  = tweet_json['place']['id']
      post_time = time.strptime(time_at)
      geoCoord = []
      if tweet_json['geo'] :
        geoCoord.append( tweet_json['geo']['coordinates'][0] )
        geoCoord.append( tweet_json['geo']['coordinates'][1] )
      else :
        continue

      # Novosibirsk: 'place:679cf8e8e64889c3'
      # Moscow:      'place:4303d1afc1e98c37'
      # Ukraine:     'place:084d0d0155787e9d'
      if placeId != "084d0d0155787e9d" :
#      if placeId != "084d0d0155787e9d" or geoCoord[0]>50.6 or geoCoord[0]<50. or geoCoord[1]<30. or geoCoord[1]>30.8 :
        continue

##      output.write( str(postId) + "," + str(userId) +  "," + str(len(text.decode("utf-8")))+ "," + str(time.strftime('%Y-%m-%d %H:%M:%S',post_time)) + "\n" )
      output.write( str(postId) + "," + str(userId) + "," + str(geoCoord[0]) + "," + str(geoCoord[1])  + "," + str(len(text.decode("utf8")))+ "," + str(time.strftime('%Y-%m-%d %H:%M:%S',post_time)) + ",\"" + text + "\"\n" )
#      output.write(time.strftime('%Y-%m-%d %H:%M:%S\n',post_time))

      if userName not in userActivity:
        userActivity[userName] = []

      userActivity[userName].append(text)

  output.close() 

  words = {}
  nPosts = 0
  nWords = 0

  for pair in sorted(userActivity.iteritems(), key=lambda (user,posts): len(posts), reverse=True) : #[0:10]
    (user,posts) = pair
    for post in posts :
      nPosts += 1

      for word in post.split() :
        nWords += 1

        w = word.decode("utf8").lower()

        if w in words :
          words[w] = words[w] + 1
        else:      
          words[w] = 1

  print "nPosts = ", nPosts, " nWords = ", nWords

  for density in sorted(words.iteritems(), key=lambda (word,rate): rate, reverse=True) : #[0:300] :
    (word,rate) = density
    if not re.match("^@", word) and not re.match("^http", word) and not re.match("^#", word) :
      print word.encode('utf8'), "\t",rate," {:.2%}".format(rate/float(nPosts)), "\t {:.2%}".format(rate/float(nWords))

if __name__ == '__main__':
  main()
