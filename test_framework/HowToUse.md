# Creating Test Cases for CM Using AutoHotkey Testing Framework

This document provides guidance for CM developers on how to create automated test cases using our AutoHotkey v2 testing framework.

## Getting Started

1. **Install Prerequisites**
   - Install AutoHotkey v2 from [https://www.autohotkey.com/](https://www.autohotkey.com/)
   - Ensure you have access to the main CMTestingFramework.ahk file

2. **File Structure**
   - Place your test case scripts in the `tests` folder of the `test_framework` directory in the repo
   - Name your test scripts descriptively (e.g., `ObliteratedCustomStart.ahk`, `MenuChecks.ahk`)

3. **Game Settings**
    - The test runner assumes you are running in **Windowed 720p** in order for pixels to line up.
    - Go to your %LocalAppData%\ChapterMaster folder and open `saves.ini` and look for the [Settings] section
    - If it says "fullscreen", run ChapterMaster and turn off Fullscreen in the options
    - Close ChapterMaster and open `saves.ini` again. You should see 4 numbers separated by `|` pipes. Edit the last 2 to be `1280|720`. The first 2 are just the x,y coordinates of the top left corner of the window on your monitor.

4. **Running Tests individually**
    - Open the repo, go to `test_framework/tests` and open the desired test
    - Easy Method:
        - Ensure you have installed the VSCode extension [AHK++ (AutoHotkey Plus Plus)](https://marketplace.visualstudio.com/items/?itemName=mark-wiemer.vscode-autohotkey-plus-plus)
        - Open the test case file in VSCode (not the framework)
        - Right-click anywhere in the file, select `AHK++ > Run AHK Script`
        - Using this method keeps you in the editor while you're working on your test case
    - AHK native method
        - In the file explorer, right-click your test case .ahk file and select "Run Script" (should be first option)
        - Better for running tests if you're not editing them

## Creating a Basic Test Case

Each test script follows this structure:

```autohotkey
; Test Name: [Test Name]
; Description: [Brief description of what this test does]
; Author: [Your Name]
; Date: [Creation/Last Modified Date]

#Requires AutoHotkey v2.0
#Include ..\CMTestingFramework.ahk

TestMyFeature() {
    ; Initialize framework
    framework := CMTestingFramework()
    
    ; Start test
    framework.StartTest("MyFeatureName")
    
    ; Launch CM application
    if (!framework.LaunchApp()) {
        MsgBox("Failed to launch application")
        return
    }
    
    ; [Your test steps here]
    
    ; End test and save results
    framework.EndTest()
}

; Run the test
TestMyFeature()
```

## Key Framework Methods

Here are the core methods to use in your test cases:

### Setup and Cleanup
- `framework.StartTest("TestName")` - Initialize a test with a name
- `framework.LaunchApp()` - Launch the CM application
- `framework.EndTest()` - Complete the test and save results

### Mouse Interaction
- `framework.Click(x, y)` - Click at specific coordinates
- `framework.DoubleClick(x, y)` - Double-click at coordinates
- `framework.MoveMouse(x, y)` - Move mouse to coordinates
- `framework.DragMouse(x1, y1, x2, y2)` - Click and drag from one point to another

### Keyboard Interaction
- `framework.SendText("text")` - Type text
- `framework.SendCombo("{Ctrl down}{s}{Ctrl up}")` - Send key combinations
- `framework.KeyDown("key")` and `framework.KeyUp("key")` - Press and release keys

### Wait and Timing
- `framework.Wait(milliseconds)` - Pause execution for specified time

### Documentation
- `framework.TakeScreenshot("description")` - Capture the current screen state
- `framework.LogStep("description")` - Record a test step with description

### Error Handling
- `framework.CheckForCrash()` - Detect if application crashed
- `framework.RestartApp()` - Restart the application after a crash

## Finding UI Element Coordinates

To interact with CM's UI elements, you'll need their screen coordinates:

1. Use AutoHotkey's built-in Window Spy tool (right-click the AutoHotkey icon in the system tray and select "Window Spy")
2. Hover your mouse over the UI element you want to interact with
3. Note the "Mouse Position" coordinates shown in Window Spy. Use the `client` value which should say `default` next to it.


## Example Test Case

Here's a complete example test case for Opening CM, starting a new game as Dark Angels and landing on the main game screen before finishing:

```autohotkey
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
```

## Best Practices

1. **Start Simple**: Begin with basic workflows before attempting complex scenarios

2. **Add Delays**: Include sufficient wait times between actions (use `framework.Wait()`)

3. **Document with Screenshots**: Take screenshots at key points in your test 

4. **Handle Errors**: Always check for and handle possible application crashes

5. **Organize by Workflow**: Create separate test files for different functional areas

6. **Comment Your Code**: Include clear comments explaining the purpose of each step

7. **Use Consistent Naming**: Name your tests and files with clear, descriptive names

8. **Test One Thing**: Each test should focus on a single feature or workflow

## Troubleshooting

- **Coordinate Issues**: If clicks aren't hitting the right spots, verify coordinates in Window Spy
- **Timing Problems**: Increase wait times if actions seem to execute before the app is ready
- **Application Not Found**: Check the application path in CMTestingFramework.ahk

## Getting Help

If you encounter issues creating test cases, contact the testing team for assistance.
