; define a variable to remember the gui show status
GuiShow = 0

; define a gui to show the listbox
MyListBox:
Gui, Submit, NoHide
if (A_GuiEvent = "DoubleClick") {
    if (MyListBox = "HearthstoneDeckTracker") {
        Run, C:\Users\xihu_\AppData\Local\HearthstoneDeckTracker\HearthstoneDeckTracker.exe ; 运行hearthstone deck tracker
    } else if (MyListBox = "Battle") {
        Run, "C:\Program Files (x86)\Battle.net\Battle.net.exe" ; 运行hearthstone
    } else if (MyListBox = "WinSCP") {
        Run, C:\tools\WinSCP\WinSCP.exe ; 运行winscp
    } else if (MyListBox = "Snipaste") {
        Run, C:\tools\Snipaste-2.8.8-Beta-x64\Snipaste.exe ; 运行snipaste
    } else if (MyListBox = "heidisql") {
        Run, C:\tools\HeidiSQL_12.6_64_Portable\heidisql.exe ; 运行heidisql
    } else if (MyListBox = "FSCapture") {
        Run, C:\tools\FSCapture103\FSCapture.exe ; 运行faststone capture
    }
    Gui, Destroy ; 关闭GUI
}

; define a function to show the gui
showGui() {
    global GuiShow
    if (%GuiShow% = 0) {
        Gui, Add, ListBox, vMyListBox gMyListBox h200, HearthstoneDeckTracker|Battle|WinSCP|Snipaste|heidisql|FSCapture ; 添加一个列表框，列出您的程序
        Gui, Show, , Select a program to run ; 显示GUI
        GuiShow = 1
    } else {
        Gui, Destroy ; 关闭GUI
        GuiShow = 0
    }
}

; define a hotkey to show the gui
#n:: ; win+n
showGui()
return

