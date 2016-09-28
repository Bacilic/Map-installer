#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Left4Dead2Mapinstaller.ico
#AutoIt3Wrapper_Outfile_x64=Left4Dead2Mapinstaller.exe
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <FileConstants.au3>
; *** End added by AutoIt3Wrapper ***
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.14.0
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3> ; _GUICtrlComboBox_DeleteString,_GUICtrlComboBox_FindString
#include <File.au3> ; _FileListToArray (Lists files and\or folders in a specified folder)

Opt("GUIOnEventMode", 1)

#Region ### START Koda GUI section ### Form=X:\Updates\AutoIt3\Scripts\Left4Dead 2 Map installer\form_Left4Dead2MapInstaller.kxf
$form_Left4Dead2MapInstaller = GUICreate("Left4Dead 2 Map Installer", 517, 476, 210, 135)
$picture_MapPreview = GUICtrlCreatePic("", 8, 8, 497, 297)
$label_MapDescription = GUICtrlCreateLabel("Για να μην πρίζεται το Θωμα!", 8, 352, 151, 17)
$button_Previous = GUICtrlCreateButton("< Previous", 8, 312, 185, 25)
$button_Next = GUICtrlCreateButton("Next >", 320, 312, 185, 25)
$button_InstallMap = GUICtrlCreateButton("Install Map", 320, 440, 185, 25)
$combo_SelectMap = GUICtrlCreateCombo("Select map... ή φωνάχτε το Θωμα!", 8, 440, 289, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$label_More = GUICtrlCreateLabel("More...", 464, 416, 37, 17)
#EndRegion ### END Koda GUI section ###

$aMapName = IniReadSection(@ScriptDir & "\Maps.ini", "Maps") ; $aMapName[0][0] is the plenty of Map Names
; The $aMapName[$i][0] read the Key of ini and $aMapName[$i][1]) read the Value
$aMapPictures = "" ; Aray to store file names of pictures, $aMapPictures[0] = number of files
$sMapsNames = "" ; String of all maps names separate with symbol "|"
$sMapNameSelected = "" ; Map to selecteted
$sMapNameValue = "" ; The name of map as value (a string without spaces)
$sMapPath = "" ; The path of file to install
$sMapLink = "" ; The link of map
$sMapPicturesPath = "" ; Folder of map's pictures
$sMapDescription = "" ; The Description of map
$i = 0 ; Counter


_GUILeft4DeadMapInstaller()

Func _GUILeft4DeadMapInstaller()
	; Form
	$form_Left4Dead2MapInstaller = GUICreate("Left4Dead 2 Map Installer", 517, 476, 210, 135)
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")

	;Buttons
	$button_Previous = GUICtrlCreateButton("< Previous", 8, 312, 185, 25)
	GUICtrlSetOnEvent(-1, "On_Button")
	GUICtrlSetState($button_Previous, $GUI_DISABLE)
	$button_Next = GUICtrlCreateButton("Next >", 320, 312, 185, 25)
	GUICtrlSetOnEvent(-1, "On_Button")
	GUICtrlSetState($button_Next, $GUI_DISABLE)
	$button_InstallMap = GUICtrlCreateButton("Install Map", 320, 440, 185, 25)
	GUICtrlSetOnEvent(-1, "On_Button")
	GUICtrlSetState($button_InstallMap, $GUI_DISABLE)

	;Combo
	$combo_SelectMap = GUICtrlCreateCombo("Select map... ή φωνάχτε το Θωμα!", 8, 440, 289, 25, BitOR($CBS_DROPDOWN, $CBS_SORT, $CBS_AUTOHSCROLL))
	For $i = 1 To $aMapName[0][0] ; $aMissionsNormal[0][0] is the plenty of Normal Missions
		; The $aMissionsNormal[$i][0] read the Key of ini and $aMissionsNormal[$i][1]) read the Value
		$sMapsNames = $sMapsNames & $aMapName[$i][0] & "|"
	Next
	GUICtrlSetData($combo_SelectMap, $sMapsNames)
	GUICtrlSetOnEvent(-1, "On_Combo")

	;Labels
	$label_MapDescription = GUICtrlCreateLabel("Για να μην πρίζεται το Θωμα!", 8, 352, 501, 67)
	$label_More = GUICtrlCreateLabel("More...", 464, 419, 37, 17)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetOnEvent(-1, "On_Label")

	;Picture
	$picture_MapPreview = GUICtrlCreatePic("", 8, 8, 497, 297)

	GUISetState() ;@SW_SHOW)
	While 1
		Sleep(100)
	WEnd
EndFunc   ;==>_GUILeft4DeadMapInstaller

Func On_Close()
	Switch @GUI_WinHandle ; See which GUI sent the CLOSE message
		Case $form_Left4Dead2MapInstaller
			Exit ; If it was this GUI - we exit <<<<<<<<<<<<<<<
	EndSwitch
EndFunc   ;==>On_Close

Func On_Button()
	Switch @GUI_CtrlId
		Case $button_InstallMap
			ShellExecute($sMapPath)
		Case $button_Next
			$i = $i + 1 ; Set pointer to next picture
			If $i <= $aMapPictures[0] Then ; If exist next picture
				GUICtrlSetImage($picture_MapPreview, $sMapPicturesPath & $aMapPictures[$i])
				GUICtrlSetState($button_Previous, $GUI_ENABLE) ; Enable Previous button
			Else
				GUICtrlSetState($button_Next, $GUI_DISABLE)
			EndIf
		Case $button_Previous
			$i = $i - 1 ; Set pointer to previous picture
			If $i >= 1 Then ; If exist previous picture
				GUICtrlSetImage($picture_MapPreview, $sMapPicturesPath & $aMapPictures[$i])
				GUICtrlSetState($button_Next, $GUI_ENABLE) ; Enable Next button
			Else
				GUICtrlSetState($button_Previous, $GUI_DISABLE)
			EndIf
	EndSwitch
EndFunc   ;==>On_Button

Func On_Combo()
	Switch @GUI_CtrlId
		Case $combo_SelectMap
			; Delete sting "Select map..." ware find in potition _GUICtrlComboBox_FindString on combo $combo_SelectMap
			_GUICtrlComboBox_DeleteString($combo_SelectMap, _GUICtrlComboBox_FindString($combo_SelectMap, "Select map"))
			$sMapNameSelected = GUICtrlRead($combo_SelectMap) ; Map to selecteted
			$sMapNameValue = IniRead(@ScriptDir & "\Maps.ini", "Maps", $sMapNameSelected, "") ; The name of map as value (a string without spaces)
			$sMapPath = IniRead(@ScriptDir & "\Maps.ini", $sMapNameValue, "Path", "") ; The path of file to install
			If FileExists($sMapPath) Then
				GUICtrlSetState($button_InstallMap, $GUI_ENABLE) ; Enable Install button
			Else
				GUICtrlSetTip($button_InstallMap, "Not exist file of map") ; Show a tooltip if not exist map file
			EndIf
			$sMapLink = IniRead(@ScriptDir & "\Maps.ini", $sMapNameValue, "Link", "") ; The link of map

			$sMapPicturesPath = IniRead(@ScriptDir & "\Maps.ini", $sMapNameValue, "PicturesPath", "") ; The folder of map's picture
			$aMapPictures = _FileListToArray($sMapPicturesPath, "*.jpg", $FLTA_FILES)
			If @error = 1 Or @error = 4 Then
				GUICtrlSetImage($picture_MapPreview, @ScriptDir & "\FileNotFound.jpg")
			Else
				If $aMapPictures[0] > 1 Then
					GUICtrlSetState($button_Next, $GUI_ENABLE) ; Enable Next button if thare is more one picture
					$i = 1 ; Set pointer to current picture
				EndIf
				GUICtrlSetImage($picture_MapPreview, $sMapPicturesPath & $aMapPictures[1])
				ConsoleWrite("Pictures found: " & $aMapPictures[0] & @CRLF)
				ConsoleWrite("Picture: " & $sMapPicturesPath & $aMapPictures[1] & @CRLF)
			EndIf
			$sMapDescription = IniRead(@ScriptDir & "\Maps.ini", $sMapNameValue, "Description", "") ; The Description of map
			GUICtrlSetData($label_MapDescription, $sMapDescription) ; Udate map description
			ConsoleWrite($sMapNameValue & @CRLF & $sMapPath & @CRLF & "Link: " & $sMapLink & @CRLF & $sMapPicturesPath & @CRLF & $sMapDescription & @CRLF)
	EndSwitch
EndFunc   ;==>On_Combo

Func On_Label()
	Switch @GUI_CtrlId
		Case $label_More
			If StringInStr($sMapLink, "www.") Then
				ShellExecute($sMapLink)
			Else
				GUICtrlSetTip($label_More, "Not exist link") ; Show a tooltip if not exist link
			EndIf
	EndSwitch
EndFunc   ;==>On_Label
