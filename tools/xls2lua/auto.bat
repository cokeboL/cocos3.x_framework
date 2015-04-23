for /R %%I in (*.xls) do (
	python xls2lua.py %%I export
)

for /R %%I in (*.xlsx) do (
	python xls2lua.py %%I export
)

pause