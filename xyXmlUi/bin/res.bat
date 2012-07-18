echo off
set path=D:\Program Files\Java\jdk1.6.0_25\bin\;%path%
java -jar %~dp0\Swift.jar xml2lib %~dp0\resources.xml %~dp0\resources.swf
java -jar %~dp0\Swift.jar xml2lib %~dp0\resources.xml %~dp0\resources.swc
pause