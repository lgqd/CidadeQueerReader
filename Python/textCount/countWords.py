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

  printCounts(singleCounts, 40)
  printCounts(doubleCounts, 10)
  printCounts(tripleCounts, 10)
