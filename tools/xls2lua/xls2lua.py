#!/usr/bin/python
# -*- coding: utf-8 -*-
# Author : maojingkai(oammix@gmail.com)

import sys
import csv
import xlrd
import codecs
import os
from types import *

def write_header(pattern, to):
	to.write("local "+pattern+" = {}\n\n")

def write_lua_row(keys, row, pattern, to):
	item = pattern+"[\""+row[0]+"\"] = {"
	for ind, val in enumerate(row):
		item += keys[ind]+"="+parse_item(val)+","
	item = item[:-1]
	item += "}\n\n"
	to.write(item)

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


def to_lua_list(parts):
	item = "{"
	for ind, one in enumerate(parts):
		item += "\""+str(ind+1)+"\"" +":"+parse_item(one.strip(" \t\n\r"))+","
	item = item[:-1]
	item += "}"
	return item

def write_footer(pattern, to):
	to.write("return "+pattern+"\n")

if __name__ == '__main__':
	if len(sys.argv) != 3:
		print("Usage: ./xls2lua.py #from_file#.csv #coord#")
		sys.exit(2)

	from_file = str(sys.argv[1])
	parts = os.path.split(from_file)
	if len(parts) != 2:
		print("Invalid File Format!")
		sys.exit(2)

	sub = str(sys.argv[2])
	if not os.path.isdir(sub):
		os.mkdir(sub)

	with xlrd.open_workbook(from_file) as workbook:
		sheets = workbook.sheet_names();
		for name in sheets:
			try:
				sheet = workbook.sheet_by_name(name)

				pattern = name.split("(")[1].rsplit(")")[0]
				to_file = os.path.join(sub, pattern+".lua")
				with codecs.open(to_file, "w", "utf-8") as luafile:
					write_header(pattern, luafile)
					keys = sheet.row_values(1)
					table = {}
					for ind in range(2, sheet.nrows):
						row = sheet.row_values(ind)
						if row[0] == "":
							continue
						if table.has_key(row[0]):
							print("WARNING: same id "+row[0])
						else:
							table[row[0]] = True
							write_lua_row(keys, row, pattern, luafile)
					write_footer(pattern, luafile)
					print("[SUCCESS] -> "+name)
					luafile.close()
			except:
				print("[FAILED] -> "+name)

	sys.exit(0)
