# -*- coding: utf-8 -*-
"""
Created on Wed Feb 24 16:23:23 2016

@author: papiyasen
"""

import csv
import re
import os

os.chdir('/Users/papiyasen/Desktop/MS-DS/ColU/Spring2016/Stat4701/HW2')


yearToPrint = '12'

outFileName = 'country_flood_severity_displaced_year' + yearToPrint + ".csv"
outFile = open(outFileName, 'w')
outFile.write('Country,Severity,Displaced\n')

header = ['Country', 'Began', 'Duration in Days', 'Dead', 'Displaced', 'Main cause', 'Severity']
country_names_unicode = ['Yemen', 'Peru', 'Indonesia', 'Brazil', 'Tajikistan']

inData = open('psen_input_tab_unix.csv')
countryDict = {}

for line in inData:
  tokens = line.strip('"').split('\t')
  if tokens[0] != '' and  tokens[0] != 'Country' and tokens[0] != '#N/A':
    # Remove extra " and ',' in country name
    tokens[0] = tokens[0].translate(None, '.","')
    # Remove '/xca' from country name
    tokens[0] = re.sub('\\\xca$', '', tokens[0])
    # Remove '\xe6' from country name
    tokens[0] = re.sub('\\\xe6$', '', tokens[0])
    # Remove leading whitespace from country name, e.g. ' India' will be converted to 'India'
    tokens[0] = tokens[0].lstrip()
    # Some country names have a strange '?' character that does not correspond to ascii code: 063.
    # For these names, we do a partial match against country_names_unicode and replace country name
    #   from the entry in country_names_unicode. Not a clean way of doing this.
    for name in country_names_unicode:
      if name in tokens[0]:
        tokens[0] = name
        exit 
    country = tokens[0]
    # Parse year(last 2 digits from 'Began' column) and column 'Severity'
    year = tokens[1].split('-')[2]
    severity = float(tokens[6])
    if year == yearToPrint:
      toWrite = tokens[0] + ',' + year + ',' + str(severity)
      print toWrite
      # Parse displaced
      displaced = float(tokens[4])
      # Create a dictionary of country and a List[aximum severity, maximum Displaced]
      #    encountered for yearToPrint.
      if country in countryDict:
        currSeverityDisplaced = countryDict[country]
        if currSeverityDisplaced[0] < severity:
          countryDict[country][0] = severity
        if currSeverityDisplaced[1] < displaced:
          countryDict[country][1] = displaced
      else:
        countryDict[country] = [severity, displaced]

# Write out country, severity values for year: yearToPrint in outFile
for country in countryDict.keys():
  toWrite = country + ',' + str(countryDict[country][0]) + ',' + str(countryDict[country][1]) + '\n'
  outFile.write(toWrite)
