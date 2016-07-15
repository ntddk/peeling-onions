#!/usr/bin/env python2
import sys
from os import path
from wordcloud import WordCloud

d = path.dirname(__file__)
argvs = sys.argv
text = open(path.join(d, argvs[1])).read()
wordcloud = WordCloud(max_font_size=600,width=2560,height=1440).generate(text)
wordcloud.to_file(path.join(d, argvs[1]+".png"))
