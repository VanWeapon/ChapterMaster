; CM Application Test Case: Create New Customer Record
; This test case demonstrates how to use the CMTestingFramework

#Requires AutoHotkey v2.0
#Include ..\CMTestingFramework.ahk

TestStartGame() {
    ; Initialize testing framework
    framework := CMTestingFramework()

    ; Start test
    framework.StartTest("StartGame")

    ; Launch CM application
    if (!framework.LaunchApp()) {
        MsgBox("Failed to launch application")
        return
    }

    ; Wait for application to fully load
    framework.Wait(7000)
    .TakeScreenshot("Main_Menu")
    
    framework.Click(693, 520)  ; Click on "New Game" in the main menu
    .Wait(8000)
    .TakeScreenshot("Creation")

    framework.Click(404, 223) ; Click Dark Angels
    .Wait(3000)
    .Click(835, 751) ; Next button
    .Wait(2000)
    .Click(835, 751) ; Next button
    .Wait(2000)
    .Click(835, 751) ; Next button
    .Wait(2000)
    .Click(835, 751) ; Next button
    .Wait(2000)
    .Click(835, 751) ; Next button
    .Wait(2000)
    .Click(835, 751) ; Next button
    .Wait(2000)
    .TakeScreenshot("Game_Started")

    ; End test and save results
    framework.EndTest()

    MsgBox("Test completed. Results saved to: " . framework.resultDir)
}

; Run the test
TestStartGame()
