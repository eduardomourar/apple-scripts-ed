tell application "Safari"
	activate
	delay 1
	#set doc to first document
	(*
	set URL of first document to "https://sia.estacio.br/entrada.asp?p2=&txtUsuario=201207070254&cod_instituicao=374"
	repeat
		-- use Safari's 'do JavaScript' to check a page's status
		if (do JavaScript "document.readyState" in document 1) is "complete" then exit repeat
		delay 0.5 -- wait a second before checking again
	end repeat
	delay 5
	do JavaScript ("window.frames[0].document.forms['form_logar']['txtPassWord'].value = 'password';") in front document
	delay 2
	do JavaScript ("window.frames[0].document.forms['form_logar'].submit;") in front document
	delay 2
	*)
end tell

#https://sia.estacio.br/portal/prt0010a.asp?p1=1660484&p2=6185
set pag to "http://bquestoes.estacio.br/entrada_frame.asp?p0=206364510&p1=201207070254&p2=1498645&p3=CCT0266&p4=101555&p5=AV&p6=09/11/2013&p7=&p8=&p9=&p10=4132651&digito_area=-1"
set jsCode to "document.getElementsByName('hdnCodDisciplina')[0].getAttribute('value');"
set codDisciplina to ""
set pagLoop to ""
set msg to ""

try
	repeat with numParticipacao from 31466 to 31466 --4999999
		repeat with codSimulado from 354 to 99999
			
			set pagLoop to pag & numParticipacao & "&p2=" & codSimulado
			tell application "Safari"
				set URL of first document to pagLoop
				delay 2
			end tell
			
			tell application "System Events"
				tell process "Safari"
					keystroke return
				end tell
			end tell
			
			tell application "Safari"
				set tempo to 0
				repeat
					delay 1 -- wait a second before checking again
					set tempo to tempo + 1
					set botaoCarga to do JavaScript "document.getElementsByClassName('botao').length;" in first document
					if tempo > 30 then exit repeat
					if botaoCarga > 0 then exit repeat
				end repeat
				#repeat
				#	delay 1 -- wait a second before checking again
				#	if (do JavaScript "document.readyState" in first document) is "complete" then exit repeat
				#end repeat
				set codDisciplina to (do JavaScript jsCode in first document)
				delay 1
				set URL of first document to "about:blank"
				repeat
					delay 1 -- wait a second before checking again
					if (do JavaScript "document.readyState" in first document) is "complete" then exit repeat
				end repeat
				#display dialog selectedText buttons {"OK"}
			end tell
			if codDisciplina ≠ "" then exit repeat
		end repeat
		if codDisciplina ≠ "" then
			do shell script "echo \"FOUND: " & pagLoop & "\" >> /Users/educyn/Desktop/pagina.txt"
		else
			do shell script "echo \"ERROR: " & pagLoop & "\" >> /Users/educyn/Desktop/pagina.txt"
		end if
	end repeat
on error errMsg number errNum
	set msg to errNum & "_" & errMsg
end try

if msg ≠ "" then
	do shell script "echo \"MSG: " & msg & "\" >> /Users/educyn/Desktop/pagina.txt"
end if

display dialog "Script finalizado." buttons {"OK"} ¬
	default button "OK" giving up after 3
