; CM Testing Framework (AutoHotkey v2)
; This framework provides the foundation for automated testing of the CM application

#Requires AutoHotkey v2.0
#SingleInstance Force

class CMTestingFramework {
    ; Configuration

    __New() {
        this.appPath := "D:\Documents\ChapterMaster\ChapterMaster.exe"
        this.screenshotDir := A_ScriptDir "\screenshots\"
        this.logDir := A_ScriptDir "\logs\"
        this.resultDir := A_ScriptDir "\results\"
        this.mouseSpeed := 2  ; 1-10, with 10 being slowest (more human-like)
        this.errorLogPath := A_AppData "..\Local\ChapterMaster\Logs\last_messages.log"

        ; State tracking
        this.currentTest := ""
        this.testSteps := []
        this.testResult := ""
        this.testStartTime := 0
        this.testEndTime := 0
        ; Ensure directories exist
        DirCreate(this.screenshotDir)
        DirCreate(this.logDir)
        DirCreate(this.resultDir)

        ; Initialize error handling
        OnError(ObjBindMethod(this, "ErrorHandler"))
    }

    ; Start CM application
    LaunchApp() {
        try {
            Run(this.appPath)
            WinWait("ahk_exe " . this.appPath)
            this.LogStep("Application launched successfully")
            return true
        } catch as e {
            this.LogError("Failed to launch application: " . e.Message)
            return false
        }
    }

    ; Start a new test
    StartTest(testName) {
        this.currentTest := testName
        this.testSteps := []
        this.testResult := ""
        this.testStartTime := A_Now

        this.LogStep("Starting test: " . testName)
        return this
    }

    ; End current test and save results
    EndTest() {
        this.testEndTime := A_Now
        duration := DateDiff(this.testEndTime, this.testStartTime, "Seconds")

        this.LogStep("Test completed in " . duration . " seconds")

        ; Create test result report
        result := "# Test Report: " . this.currentTest . "`n"
        result .= "* Date: " . FormatTime(A_Now, "yyyy-MM-dd") . "`n"
        result .= "* Time: " . FormatTime(A_Now, "HH:mm:ss") . "`n"
        result .= "* Duration: " . duration . " seconds`n`n"
        result .= "## Test Steps:`n"

        for step in this.testSteps {
            result .= "* " . step . "`n"
        }

        ; Save test result to file
        fileName := this.resultDir . FormatTime(A_Now, "yyyyMMdd_HHmmss") . "_" . this.currentTest . ".md"
        try {
            f := FileOpen(fileName, "w").Write(result)
            f.Close()
            this.testResult := result
            return true
        } catch as e {
            this.LogError("Failed to save test results: " . e.Message)
            return false
        }

    }

    ; Log a test step
    LogStep(description) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        step := timestamp . " - " . description
        this.testSteps.Push(step)
        FileAppend(step . "`n", this.logDir . "test_log.txt")
        return this
    }

    ; Log an error
    LogError(errorMsg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        errorStep := timestamp . " - ERROR: " . errorMsg
        this.testSteps.Push(errorStep)
        FileAppend(errorStep . "`n", this.logDir . "error_log.txt")
        return this
    }

    ; Mouse Simulation Functions

    ; Move mouse in a human-like manner
    MoveMouse(x, y) {
        MouseMove(x, y, this.mouseSpeed)
        this.LogStep("Mouse moved to coordinates: " . x . ", " . y)
        return this
    }

    ; Click at current position or specified coordinates
    Click(x := "", y := "", button := "left") {
        if (x != "" && y != "") {
            this.MoveMouse(x, y)
        }

        ; GameMaker behaves a lil funky with the instant clicks of AHK and sometimes they dont register
        Click(button, , , 1 ,'D')
        this.Wait(10)
        Click(button, , , 1, 'U')
        this.LogStep("Mouse " . button . "-clicked at current position")

        if (!this.CheckForCrash())
            return this

    }

    ; Double-click at current position or specified coordinates
    DoubleClick(x := "", y := "", button := "left") {
        if (x != "" && y != "") {
            this.MoveMouse(x, y)
        }

        Click(button " Double")
        this.LogStep("Mouse double-" . button . "-clicked at current position")

        if (!this.CheckForCrash())
            return this
    }

    ; Drag mouse from one position to another
    DragMouse(x1, y1, x2, y2, button := "left") {
        this.MoveMouse(x1, y1)
        MouseClickDrag(button, x1, y1, x2, y2, this.mouseSpeed)
        this.LogStep("Mouse dragged from " . x1 . ", " . y1 . " to " . x2 . ", " . y2)

        if (!this.CheckForCrash())
            return this
    }

    ; Keyboard Simulation Functions

    ; Send text (typing)
    SendText(text) {
        Send(text)
        this.LogStep("Text sent: " . text)

        if (!this.CheckForCrash())
           return this
    }

    ; Send keyboard combo (like Ctrl+S)
    SendCombo(keys) {
        Send(keys)
        this.LogStep("Key combination sent: " . keys)

        if (!this.CheckForCrash()) 
            return this
    }

    ; Press and hold a key
    KeyDown(key) {
        Send("{" . key . " down}")
        this.LogStep("Key down: " . key)
        if (!this.CheckForCrash())
            return this
    }

    ; Release a key
    KeyUp(key) {
        Send("{" . key . " up}")
        this.LogStep("Key up: " . key)
        if (!this.CheckForCrash())
            return this
    }

    ; Wait for specified milliseconds
    Wait(ms) {
        Sleep(ms)
        this.LogStep("Waited for " . ms . " ms")
        if (!this.CheckForCrash())
            return this
    }

    ; Screenshot Functions

    ; Take a screenshot of the current window
    TakeScreenshot(description := "") {
        if (description == "")
            description := "screenshot"

        ; Create filename with timestamp
        filename := FormatTime(A_Now, "yyyyMMdd_HHmmss") . "_" . this.currentTest . "_" . description . ".png"
        path := this.screenshotDir . filename

        try {
            ; Capture active window
            WinGetPos(&x, &y, &w, &h, "A")
            screenshot := Gui()
            screenshot.Add("Picture", "w" . w . " h" . h, path)
            WinCapture(x, y, w, h, path)

            this.LogStep("Screenshot saved: " . filename)
            return path
        } catch as e {
            this.LogError("Failed to take screenshot: " . e.Message)
            return ""
        }
    }

    ; Error Handling Functions

    ; Check if application is still running
    IsAppRunning() {
        return WinExist("ahk_exe " . this.appPath)
    }

    ; Check for application crash
    CheckForCrash() {
        if (!this.IsAppRunning()) {
            this.LogError("Application crashed during " . this.currentTest)
            this.TakeScreenshot("crash")
            this.ReadErrorLogs()
            this.EndTest()
            return true
        }
        return false
    }

    ; Read error logs after crash
    ReadErrorLogs() {
        try {
            ; Find the most recent error log
            errorLogFiles := []
            loop files, this.errorLogPath . "\*.log" {
                errorLogFiles.Push({ path: A_LoopFileFullPath, time: A_LoopFileTimeModified })
            }

            ; Sort by modification time (newest first)
            errorLogFiles := Sort(errorLogFiles, (a, b) => b.time - a.time)

            if (errorLogFiles.Length > 0) {
                latestLog := errorLogFiles[1].path
                logContent := FileRead(latestLog)

                ; Extract relevant information
                this.LogStep("Error log found: " . latestLog)
                this.LogError("Error log content: " . SubStr(logContent, 1, 500) . (StrLen(logContent) > 500 ? "..." :
                    ""))

                ; Save error log with test results
                FileCopy(latestLog, this.resultDir . FormatTime(A_Now, "yyyyMMdd_HHmmss") . "_error.log")
            } else {
                this.LogError("No error logs found in " . this.errorLogPath)
            }
        } catch as e {
            this.LogError("Failed to read error logs: " . e.Message)
        }
    }

    ; General error handler
    ErrorHandler(exception, mode) {
        this.LogError("Framework error: " . exception.Message)
        this.TakeScreenshot("framework_error")
        return true  ; Continue running
    }

    ; Restart the application
    RestartApp() {
        if (this.IsAppRunning()) {
            WinClose("ahk_exe " . this.appPath)
            WinWaitClose("ahk_exe " . this.appPath, , 5)
        }

        return this.LaunchApp()
    }

    ; Helper function to find image on screen
    FindImage(imagePath, variation := 50) {
        try {
            ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*" . variation . " " . imagePath)
            if (foundX && foundY) {
                this.LogStep("Image found at: " . foundX . ", " . foundY)
                return { x: foundX, y: foundY, found: true }
            } else {
                this.LogStep("Image not found: " . imagePath)
                return { found: false }
            }
        } catch as e {
            this.LogError("Error searching for image: " . e.Message)
            return { found: false }
        }
    }

    ; Click on an image if found
    ClickOnImage(imagePath, variation := 50) {
        result := this.FindImage(imagePath, variation)
        if (result.found) {
            this.Click(result.x, result.y)
            return true
        }
        return false
    }
}

; Helper function for capturing screenshots
WinCapture(x, y, w, h, filename) {
    ; Create bitmap
    hdc := DllCall("GetDC", "Ptr", 0)
    hdcMem := DllCall("CreateCompatibleDC", "Ptr", hdc)
    hBitmap := DllCall("CreateCompatibleBitmap", "Ptr", hdc, "Int", w, "Int", h)
    DllCall("SelectObject", "Ptr", hdcMem, "Ptr", hBitmap)

    ; Copy screen to bitmap
    DllCall("BitBlt", "Ptr", hdcMem, "Int", 0, "Int", 0, "Int", w, "Int", h, "Ptr", hdc, "Int", x, "Int", y, "UInt",
        0x00CC0020) ; SRCCOPY

    ; Save bitmap to file
    DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", hBitmap, "Ptr", 0, "Ptr*", &pBitmap := 0)
    DllCall("gdiplus\GdipSaveImageToFile", "Ptr", pBitmap, "Str", filename, "Ptr", 0, "Ptr", 0)

    ; Cleanup
    DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
    DllCall("DeleteObject", "Ptr", hBitmap)
    DllCall("DeleteDC", "Ptr", hdcMem)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hdc)
}
