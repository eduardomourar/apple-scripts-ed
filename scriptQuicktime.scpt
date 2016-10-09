on run {input, parameters}
	
	tell application "System Preferences" to activate
	tell application "System Preferences"
		reveal anchor "output" of pane id "com.apple.preference.sound"
	end tell
	tell application "System Events" to tell process "System Preferences"
		set theRows to every row of table 1 of scroll area 1 of tab group 1 of window 1
		repeat with aRow in theRows
			if (value of text field 1 of aRow as text) is equal to "Dispositivo com Saída Múltipla" then
				set selected of aRow to true
				exit repeat
			end if
		end repeat
	end tell
	
	tell application "System Preferences"
		reveal anchor "input" of pane id "com.apple.preference.sound"
	end tell
	tell application "System Events" to tell process "System Preferences"
		set theRows to every row of table 1 of scroll area 1 of tab group 1 of window 1
		repeat with aRow in theRows
			if (value of text field 1 of aRow as text) is equal to "Dispositivo Agregado" then
				set selected of aRow to true
				exit repeat
			end if
		end repeat
	end tell
	quit application "System Preferences"
	
	return true
end run


	--- Abre QuickTime pra começar gravação
	tell application "QuickTime Player"
		set newScreenRecording to new screen recording
		tell application "System Events" to tell process "QuickTime Player"
			key code 49
		end tell
		tell newScreenRecording
			start
			delay 10
			stop
		end tell
		tell last item of documents
			save in ("" & (path to desktop) & "video.mov")
			close
		end tell
	end tell
	quit application "QuickTime Player"

	tell application "QuickTime Player"
		activate
		set newScreenRecording to new screen recording
		activate
		tell application "System Events" to tell process "QuickTime Player"
			key code 49
		end tell
		tell newScreenRecording
			start
			delay 20
			stop
			save in "/Users/educyn/Desktop/output.mov"
			close
		end tell
	end tell

on run {input, parameters}
	
	set myProcesses to {"QuickTime Player"} -- The ones to quit.
	
	delay 10
	tell application "System Events"
		repeat with myProcess in myProcesses
			set theID to (unix id of processes whose name is myProcess)
			try
				-- Should stop the application with no dialogs and no items saved.
				do shell script "kill -9 " & theID
			end try
		end repeat
	end tell
	
	return true
end run
