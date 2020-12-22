***Settings****
Library    WhiteLibrary     
Library    Collections
Library    OperatingSystem
Library    String
Library    C:/Users/THANATHIP N/TestCase/Custom/ExcelManager.py
 
***Test Cases***
test
    test


***Keywords***

test
    Launch Application    C:/AFC/SCS/SCSApplication/SCSApplication.exe
    Attach window    id:Information_Dialog
    Click Button    id:Information_OKButton
    sleep    30s
    #Attach window    id:MainWindow
    Attach window    id:MainScreenControl_ControlLogin_Border
    Close Application



***Variables***