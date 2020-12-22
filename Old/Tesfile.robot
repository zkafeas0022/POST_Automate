***Settings****
Library    WhiteLibrary
#Library    Screenshot
Library    Collections
Library    OperatingSystem
Library    String
Library    C:/Users/THANATHIP N/TestCase/Custom/FileManager.py
Library    C:/Users/THANATHIP N/TestCase/Custom/ExcelManager.py

***Test Cases***
Test
    open text File



***Keywords***
open text File
    ${datalist_Simulastcard}	Create List
    ${datalist_Simulastcard}    Get File    C:/AFC/POST/POSTApplication/ConfigINI/SimulateCardReader.ini
    ${datalist_Simulastcard}	Encode String To Bytes	${datalist_Simulastcard}	UTF-8				
    ${datalist_Simulastcard}	Decode Bytes To String	${datalist_Simulastcard}	UTF-8	
    Append To List	${datalist_Simulastcard}
    log list    ${datalist_Simulastcard}
    log    ${datalist_Simulastcard}
    log    ${datalist_Simulastcard[46]}
    #${datalist_Simulastcard[46]}    Set Variable    9
    #Append To list    ${datalist_Simulastcard[46]}
    log    ${datalist_Simulastcard[46]}
    ${amount}    Get Length    ${datalist_Simulastcard}
    Append To File    C:/AFC/POST/POSTApplication/ConfigINI/SimulateCardReader.ini    Milk = 22
    Remove Environment Variable    Test = 9 
    
        


***Keywords***