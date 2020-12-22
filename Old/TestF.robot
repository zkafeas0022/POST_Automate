***Settings****
Library    WhiteLibrary
Library    Screenshot
Library    String
Library    C:/Users/THANATHIP N/Custom/FileManager.py
Library    C:/Users/THANATHIP N/Custom/ExcelManager.py


***Test Cases***
Test POSTApp
    Post Setup
    log    ${cash_payment}
    login POST Application
    AND Verify that all function except add value should be unable to use
    When Add Value with cash Total Amount Received<Total Payment
    
 
***Keywords***
login POST Application
    #[Arguments]    ${POSTAPP_PATH}    {POST_USER}    ${POST_PASS}
    Launch Application    ${POSTAPP_PATH}
    Attach Window    ${MainWindow}
    sleep    3s
    Attach Window    ${Warning_Dialog} 
    Click Button    ${Warning_OKButton}
    Attach Window    ${MainWindow}
    Input Text To Textbox    ${Path_userid}    ${POST_USER}
    log    ${POST_USER}
    sleep    3s
    Input Text To Textbox    ${Path_Password}    ${POST_PASS}
    log    ${POST_PASS}
    Click Button    ${Path_LoginButton}
    Attach Window    ${MainWindow}
    sleep    2s
    Verify Label    ${Path_UserIDValue}  ${POST_USER}
    Verify Label    ${Path_RoleNameValue}    ${Role}
   
    sleep    2s

AND Verify that all function except add value should be unable to use
    Attach Window	id:MainWindow
    ${current_title} =	get window title
    log    ${current_title}
#Add Value	
    Item Should Be Enabled	id:ControlInitialAddValue_bt1_button
    Item Should Be Enabled	id:ControlInitialAddValue_bt2_button
    Item Should Be Enabled	id:ControlInitialAddValue_bt3_button
    Item Should Be Enabled	id:ControlInitialAddValue_bt4_button
    Item Should Be Disabled	id:ControlInitialAddValue_bt5_button
    Item Should Be Enabled	id:ControlInitialAddValue_Addvalue_textbox
 #Payment Mode		
    Item Should Be Disabled	id:ControlPaymentMode_Payment_combobox	
    Verify Text In Textbox	id:ControlPaymentMode_Cash_textbox	${EMPTY}
    Verify Text In Textbox	id:ControlPaymentMode_CreditCard_textbox	${EMPTY}
    Verify Text In Textbox	id:ControlPaymentMode_CreditCardNo_textbox	${EMPTY}
    Verify Text In Textbox	id:ControlPaymentMode_Voucher_textbox	${EMPTY}
    Verify Text In Textbox	id:ControlPaymentMode_VoucherNo_textbox	${EMPTY}
#Cash Amount Received		
    Item Should Be Disabled	id:ControlCashAmountReceive_btn100_button	
    Item Should Be Disabled	id:ControlCashAmountReceive_btn200_button	
    Item Should Be Disabled	id:ControlCashAmountReceive_btn300_button	
    Item Should Be Disabled	id:ControlCashAmountReceive_btn500_button	
    Item Should Be Disabled	id:ControlCashAmountReceive_btnBlank_button	
    Item Should Be Disabled	id:ControlCashAmountReceive_CashReceived_textbox	
#CSC Information
    Verify Text In Textbox	id:ControlCSCInformationC_InitialPurse_TextBox    ${fiveH_baht}
    Verify Text In Textbox	id:ControlCSCInformationC_IssuingFee_TextBox    ${zero_baht}
    Verify Text In Textbox	id:ControlCSCInformationC_CardDeposit_TextBox    ${fiffy_baht}
#Bonus Information		
    Verify Text In Textbox	id:ControlBonusInformationB_BonusMode_TextBox	${notAv}
    Verify Text In Textbox	id:ControlBonusInformationB_BonusBeforeCardSale_textbox	${zero_baht}
    Verify Text In Textbox	id:ControlBonusInformationB_BonusAdded_textbox	${zero_baht}
    Verify Text In Textbox	id:ControlBonusInformationB_BonusAfterCardSale_textbox	${zero_baht}
#Pass information panel		
#Verify Label	id:ControlPassInformation_PassInfo_label	${no_pass_ava}
#Payment		
    Verify Text In Textbox	id:ControlPayment_TotalAmountReceived_TextBox	${EMPTY}
    Verify Text In Textbox	id:ControlPayment_TotalPayment_TextBox	${EMPTY}
    Verify Text In Textbox	id:ControlPayment_ChangeDue_TextBox	${EMPTY}
#Button		
    Item Should Be Disabled	id:ControlMainCardOperation_Confirm_button	
    Item Should Be Disabled	id:ControlMainCardOperation_PrintReceipt_button	

When Add Value with cash Total Amount Received<Total Payment
    Attach Window	id:MainWindow	
    Item Should Be Enabled	text:100	
    Item Should Be Enabled	text:200	
    Item Should Be Enabled	text:300	
    Item Should Be Enabled	text:500
    Click Button	text:300
    sleep    3s
    Select Combobox Value	id:ControlPaymentMode_Payment_combobox	${cash_payment}
    sleep    3s	
    Button Text Should Contain	id:ControlCashAmountReceive_btn100_button	350
    Button Text Should Contain	id:ControlCashAmountReceive_btn200_button	400
    Button Text Should Contain	id:ControlCashAmountReceive_btn300_button	500
    Item Should Be Enabled	id:ControlCashAmountReceive_btn100_button	
    Item Should Be Enabled	id:ControlCashAmountReceive_btn200_button	
    Item Should Be Enabled	id:ControlCashAmountReceive_btn300_button	
    Item Should Be Enabled	id:ControlCashAmountReceive_btn500_button	
    Item Should Be Disabled	id:ControlCashAmountReceive_btnBlank_button	
    Item Should Be Enabled	id:ControlCashAmountReceive_CashReceived_textbox
    Click Button    id:ControlCashAmountReceive_btn100_button		
    #Input Text To Textbox	id:ControlCashAmountReceive_CashReceived_textbox	500

Then After add value Total amount received<Total Pyament confrim button should be disable
    Item Should Be Disabled	id:ControlMainCardOperation_Confirm_button
    Item Should Be Disabled	id:ControlMainCardOperation_PrintReceipt_button

Logout POSTApplication
    Click Button    id:ControlMainCardOperation_Home_button
    Attach Window	id:MainWindow
    Click Button	id:ControlMainMenu_Logout_button
    Attach Window	id:Confirmation_Dialog
    Item Should Be Enabled	id:ConfirmationPreferNo_NoButton
    Sleep	3	
    Click Button	id:ConfirmationPreferNo_YesButton	
    Wait until item does not exist	id:Confirmation_Dialog	timeout=60s
    Wait until item does not exist	id:ControlMainMenu_Logout_button	timeout=60s

Post Setup
    Fetch Configuration From Excel    ${Project_Name}    ${Excelname}    Environment
    Fetch Configuration From Excel    ${Project_Name}    ${Excelname}    BUS request

Fetch Configuration From Excel
    [Arguments]    ${Project_Name}    ${Excelname}    ${SheetName}
    Log	Test Data for Excel Name : ${ExcelName}			
    ${test_dir}=	Get Current Test Directory	${ProjectName}		
    Open Excel File	${test_dir}\\Test Data\\${ExcelName}			
    ${rowcount}	Get Row Count	${SheetName}		
    @{name}	Get Cell Value By Column	${SheetName}	1	
    @{value}	Get Cell Value By Column	${SheetName}	2	
    :FOR	${INDEX}	IN RANGE	0	${rowcount-1}
    \    Set Global Variable	${name[${INDEX}]}	${value[${INDEX}]}

Get Current Test Directory	
    [Arguments]    ${ProjectName}
    ${cur_dir}=	Split String	${CURDIR}	\\					
    ${dir_length}=	Get Length	${cur_dir}						
    :FOR	${i}	IN RANGE	0	${dir_length}				
    \    ${dir_resource}=	Run Keyword If	${i} == 0	Set Variable	${cur_dir[${i}]}	ELSE	Set Variable	${dir_resource}\\${cur_dir[${i}]}	
    \    Exit For Loop If	'${cur_dir[${i}]}' == '${ProjectName}'							
    Return From Keyword	${dir_resource}	



***Variables***

#login POST Application
${MainWindow}    id:MainWindow
${Warning_Dialog}    id:Warning_Dialog
${Warning_OKButton}    id:Warning_OKButton
${Path_userid}    id:LogIn_UserIDInputTextBox
${Path_Password}    id:LogIn_PasswordInputTextBox
${Path_LoginButton}    id:LogIn_LoginButton
${Path_UserIDValue}    id:StatusBar_UserIDValue
${Path_RoleNameValue}    id:StatusBar_RoleNameValue
#AND Verify that all function except add value should be unable to use
${fiveH_baht}    500.00
${zero_baht}    0.00
${fiffy_baht}    50.00
${notAv}    Not Available
${no_pass_ava}    No Pass Available
${cash_payment}    Cash
${Project_Name}    Devlop
${Excelname}    Post.xlsx