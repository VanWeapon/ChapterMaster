; CM Application Test Case: Create New Customer Record
; This test case demonstrates how to use the CMTestingFramework

#Requires AutoHotkey v2.0
#Include ..\CMTestingFramework.ahk

DiscoverUIElementsRunner() {
    ; Initialize testing framework
    framework := CMTestingFramework()

    ; Start test
    ; framework.StartTest("StartGame")

    ; Launch CM application
    if (!framework.LaunchApp()) {
        MsgBox("Failed to launch application")
        return
    }

    ; Write steps here
    framework.DiscoverUIElements()

    ; End test and save results
    ; framework.EndTest()

    ; MsgBox("Test completed. Results saved to: " . framework.resultDir)
}

; Run the test
DiscoverUIElementsRunner()
