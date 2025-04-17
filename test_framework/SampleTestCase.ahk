; CM Application Test Case: Create New Customer Record
; This test case demonstrates how to use the CMTestingFramework

#Requires AutoHotkey v2.0
#Include CMTestingFramework.ahk

TestCreateNewCustomer() {
    ; Initialize testing framework
    framework := CMTestingFramework()
    framework.appPath := "notepad.exe"

    ; Start test
    framework.StartTest("CreateNewCustomer")

    ; Launch CM application
    if (!framework.LaunchApp()) {
        MsgBox("Failed to launch application")
        return
    }

    ; Wait for application to fully load
    framework.Wait(3000)

    ; Navigate to customer module
    framework.Click(45, 120)  ; Click on "Customers" in the main menu
    .Wait(1000)

    ; Click on "New Customer" button
    framework.Click(150, 80)
    .Wait(1500)
    .TakeScreenshot("new_customer_form")

    ; Fill out customer form
    framework.Click(200, 150)  ; Click on "First Name" field
    .Wait(300)
    .SendText("John")
    .Wait(200)
    .SendCombo("{Tab}")  ; Move to "Last Name" field
    .Wait(200)
    .SendText("Smith")
    .Wait(200)
    .SendCombo("{Tab}")  ; Move to "Email" field
    .Wait(200)
    .SendText("john.smith@example.com")
    .Wait(200)
    .SendCombo("{Tab}")  ; Move to "Phone" field
    .Wait(200)
    .SendText("555-123-4567")
    .Wait(200)
    .TakeScreenshot("customer_form_filled")

    ; Save the new customer record
    framework.Click(300, 400)  ; Click "Save" button
    .Wait(2000)

    ; Check for confirmation message or crash
    if (framework.CheckForCrash()) {
        framework.LogError("Application crashed during customer creation")
        framework.RestartApp()
        framework.EndTest()
        return
    }

    ; Verify the new customer appears in the list
    framework.TakeScreenshot("customer_list_after_save")

    ; End test and save results
    framework.EndTest()

    MsgBox("Test completed. Results saved to: " . framework.config.resultDir)
}

; Run the test
TestCreateNewCustomer()
