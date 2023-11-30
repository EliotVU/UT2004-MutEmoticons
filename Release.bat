for %%* in (.) do set project_name=%%~n*
set project_dir=%~dp0
set project_version=2
set project_name_release=%project_name%_V%project_version%

cd..
cd system

ren "%project_name%.u" "%project_name_release%.u"

UCC.exe rebuild "%project_name_release%.u"
copy /b /y "%project_name_release%.u" /b /y "..\%project_name%\Release\System\%project_name_release%.u"
del /q "%project_name_release%.u"

UCC.exe ExportCache "%project_name_release%.u"
copy /b /y "%project_name_release%.ucl" /b /y "..\%project_name%\Release\System\%project_name_release%.ucl"
del /q "%project_name_release%.ucl"