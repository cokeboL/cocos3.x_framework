#!/usr/bin/python
# -*- coding: utf-8 -*-
# Author : maojingkai(oammix@gmail.com)

import sys
import csv
import xlrd
import codecs
import os
from types import *

def write_head(module, outFile):
	print("module: " + module)
	outFile.write("local " + module + " = {}\n\n")

def to_lua_list(parts):
	item = "{"
	for idx, v in enumerate(parts):
		item += "\"" + str(idx+1)+"\"" + ":" + parse_item(v.strip(" \t\n\r")) + ","
	item = item[:-1]
	item += "}"
	return item

def parse_item(item):
	if isinstance(item, str):
		parts = item.split("+")
		if len(parts) > 1:
			return to_lua_list(parts)
		parts = item.split("|")
		if len(parts) > 1:
			return to_lua_list(parts)
		parts = item.split(",")
		if len(parts) > 1:
			return to_lua_list(parts)
		if item == "null" or item == "":
			return "nil"
		return "\""+item+"\""
	elif isinstance(item, int) or isinstance(item, float):
		return str(item)
	elif isinstance(item, unicode):
		parts = item.split("+")
		if len(parts) > 1:
			return to_lua_list(parts)
		parts = item.split("|")
		if len(parts) > 1:
			return to_lua_list(parts)
		parts = item.split(",")
		if len(parts) > 1:
			return to_lua_list(parts)
		if item == "null" or item == "":
			return "nil"
		return "\""+item+"\""

def write_item(keys, row, module, outFile):
	item = module + "[\""+row[0]+"\"] = {"
	for idx, v in enumerate(row):
		item += keys[idx] + "=" + parse_item(v) + ","
		print("item: " + item)
	item = item[:-1]
	item += "}\n\n"
	outFile.write(item)


def write_tail(pattern, to):
	to.write("return "+pattern+"\n")

if __name__ == '__main__':
	if len(sys.argv) != 2:
		print("Usage: ./xls2lua.py #srcFile#.csv #coord#")
		sys.exit(2)

	srcFile = str(sys.argv[1])
	parts = os.path.split(srcFile)
	if len(parts) != 2:
		print("Invalid File Format!")
		sys.exit(2)

	sub = "dst"
	if not os.path.isdir(sub):
		os.mkdir(sub)

	with xlrd.open_workbook(srcFile) as workbook:
		sheets = workbook.sheet_names();
		for name in sheets:
			try:
				sheet = workbook.sheet_by_name(name)
				module = sheet.row_values(0)[0]
				
				#pattern = name.split("(")[1].rsplit(")")[0]
				luaFile = os.path.join(sub, module + ".lua")
				print("luaFile: " + module + luaFile)
				keys = sheet.row_values(1)
				print("keys: " + keys[0] + " " + keys[1] + " " + keys[2])
				with codecs.open(luaFile, "w", "utf-8") as outFile:
					write_head(module, outFile)
					
					table = {}
					for idx in range(2, sheet.nrows):
						row = sheet.row_values(idx)
						if row[0] == "":
							continue
						if table.has_key(row[0]):
							print("WARNING: same id "+row[0])
						else:
							table[row[0]] = True
							write_item(keys, row, module, outFile)
					write_tail(module, outFile)
					print("[SUCCESS] -> " + name)
					outFile.close()
			except:
				print("[FAILED] -> " + name)

	sys.exit(0)
