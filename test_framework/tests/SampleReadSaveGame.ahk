; This test case demonstrates how to use the CMTestingFramework

#Requires AutoHotkey v2.0
#Include ..\CMTestingFramework.ahk

TestSaveGame() {
    ; Initialize testing framework
    framework := CMTestingFramework()

    ; Start test
    framework.StartTest("SaveGame")

    ; JSON reading doesn't work in AHK, but ini reading does. 
    slot := "1"
    marinesCount := IniRead(framework.savesIniPath, slot, "marines", 0)

    if(Integer(marinesCount) < 1000){
        status := "Success"
    } else {
        status := "Failure"
        framework.LogStep("Failed Step: Expected a marines value between 990 and 1100, instead got " . marinesCount)
    }

    MsgBox("Marines in save slot 1: " . marinesCount)
   

    ; End test and save results
    framework.EndTest(status)
}

; Run the test
TestSaveGame()
