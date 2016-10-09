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
set pag to "http://bquestoes.estacio.br/entrada.asp?p0=224309250&p1=201207070254&p10="
set jsCode to "window.frames[1].document.getElementsByClassName('linha_text_normal_000000').item(0).textContent;"
set codDisciplina to ""
set matricula to ""
set pagLoop to ""

try
set {year:y, month:m, day:d} to (current date)
	repeat with numParticipacao from 1932350 to 4132651
		repeat with matricula from 
		
		tell (current date) to get its day as integer
		set day to day * 8972370 
		set msg to ""
		set pagLoop to pag & numParticipacao
		tell application "Safari"
			set URL of first document to pagLoop
			delay 2
			
			set pagLoop to numParticipacao
			
			set tempo to 0
			repeat
				delay 1 -- wait a second before checking again
				set tempo to tempo + 1
				set botaoCarga to do JavaScript "window.frames[1].document.getElementsByClassName('button').length;" in first document
				if tempo > 30 then exit repeat
				if botaoCarga > 0 then exit repeat
			end repeat
			#repeat
			#	delay 1 -- wait a second before checking again
			#	if (do JavaScript "document.readyState" in first document) is "complete" then exit repeat
			#end repeat
			set codDisciplina to (do JavaScript jsCode in first document)
			delay 1
			do JavaScript "window.frames[1].document.forms['form']['codigo'].value = '" & codDisciplina & "';" in first document
			delay 1
			do JavaScript "window.frames[1].document.forms['form']['Enviar'].click();" in first document
			
			delay 2
			(*set URL of first document to "about:blank"
			repeat
				delay 1 -- wait a second before checking again
				if (do JavaScript "document.readyState" in first document) is "complete" then exit repeat
			end repeat*)
			#display dialog selectedText buttons {"OK"}
		end tell
		
		tell application "System Events" to tell process "Safari"
			tell front window
				if value of attribute "AXSubRole" is "AXDialog" then -- dialog opened.
					tell UI element 3
						set msg to value of attribute "AXValue"
					end tell
					perform action "AXPress" of button "OK" -- close the dialog
				end if
			end tell
		end tell
		
		tell application "Safari"
			set codDisciplina to (do JavaScript "window.frames[1].document.getElementsByName('num_questoes').length;" in first document)
		end tell
		
		if msg = "" and codDisciplina = 1 then
			do shell script "echo \"FOUND: " & pag & pagLoop & "\" >> /Users/educyn/Desktop/pagina.txt"
		else
			do shell script "echo \"ERROR: " & msg & " | " & pagLoop & "\" >> /Users/educyn/Desktop/pagina.txt"
		end if
	end repeat
	
on error errMsg number errNum
	set msg to errNum & "_" & errMsg
	do shell script "echo \"ERROR: " & msg & " | " & pagLoop & "\" >> /Users/educyn/Desktop/pagina.txt"
end try

display dialog "Script finalizado." buttons {"OK"} ¬
	default button "OK" giving up after 3
