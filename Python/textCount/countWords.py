#! /usr/bin/env python
# -*- coding: utf-8 -*-

import operator, sys
from os import listdir
from os.path import join
from itertools import tee
from re import sub

DATA_DIR = "./txts"
singleCounts = {}
doubleCounts = {}
tripleCounts = {}
doubleSimilarities = {}
tripleSimilarities = {}

def triowise(iterable):
  a, b, c = tee(iterable, 3)
  next(b, None)
  next(c, None)
  next(c, None)
  return zip(a, b, c)

def printCounts(mCounts, limit):
  for filename,words in mCounts.iteritems():
    print filename
    sorted_words = sorted(words.items(), key=operator.itemgetter(1), reverse=True)

    for i,(w,c) in enumerate(sorted_words):
      if len(w) > 1:
        print ("  "+w+": "+str(c)).decode('utf8')
      if i >= limit:
        break

def countSimilarities(mCounts, mSimilarities):
  for title,counts in mCounts.iteritems():
    for word,count in counts.iteritems():
      if word in mSimilarities:
        mSimilarities[word].append(title[:16])
      else:
        mSimilarities[word] = [title[:16]]

def printSimilarities(mSimilarities, threshold):
  print("similarities")
  sorted_similarities = sorted(mSimilarities, key=lambda k:len(mSimilarities[k]), reverse=True)
  for i,k in enumerate(sorted_similarities):
    if len(mSimilarities[k]) > threshold:
      print ("  "+k+": "+str(mSimilarities[k]))

if __name__ == "__main__":
  for filename in [f for f in sorted(listdir(DATA_DIR)) if f.endswith(".txt")]:
    singleCounts[filename] = {}
    doubleCounts[filename] = {}
    tripleCounts[filename] = {}
    fullPath = join(DATA_DIR, filename)

    with open(fullPath) as txt:
      for line in txt.read().splitlines():
        line = sub(r'[.!?@()+-]+', '', line)

        for (w0,w1,w2) in triowise(line.split()):
          singlet = w0.lower()
          doublet = singlet+" "+w1.lower()
          triplet = doublet+" "+w2.lower()
          
          if singlet in singleCounts[filename]:
            singleCounts[filename][singlet] += 1
          else:
            singleCounts[filename][singlet] = 1

          if doublet in doubleCounts[filename]:
            doubleCounts[filename][doublet] += 1
          else:
            doubleCounts[filename][doublet] = 1

          if triplet in tripleCounts[filename]:
            tripleCounts[filename][triplet] += 1
          else:
            tripleCounts[filename][triplet] = 1

    txt.close()

  countSimilarities(doubleCounts, doubleSimilarities)
  countSimilarities(tripleCounts, tripleSimilarities)

  #printCounts(singleCounts, 40)
  #printCounts(doubleCounts, 10)
  #printCounts(tripleCounts, 10)
  printSimilarities(doubleSimilarities, 2)
  printSimilarities(tripleSimilarities, 1)
