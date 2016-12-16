#!/usr/bin/python

from __future__ import print_function
import xml.etree.ElementTree as ET
import sys
import time

def main():
    if len(sys.argv) < 2:
        print("No file has been passed in to parse!")
        sys.exit
    elif len(sys.argv) > 2:
        print("You have passed in too many arguments, please only pass in a single file to be parsed.")
        sys.exit
    elif len(sys.argv) == 2:
        openLog(sys.argv[1])
    else:
        print("I have no idea what you did, but it was wrong, please pass in the file to be parsed.")
        sys.exit

def openLog(file):
    tailer = tail( open(file) )
    block = []
    startCap = False
    for line in tailer:
        if "<output>" in line:
            startCap = True
        if startCap == True:
            block.append(line)
        if "</output>" in line:
            startCap = False
            parseXML('\n'.join(block))
            block = []

def parseXML(block):
    root = ET.fromstring(block)
    print(root.tag, root.attrib)
    for child in root:
        print(child.tag, child.attrib)

def tail(file):
    file.seek(0, 2)

    while True:
        line = file.readline()

        if not line:
            time.sleep(0.1)
            continue

        yield line.strip()

if __name__ == '__main__':
    main()
