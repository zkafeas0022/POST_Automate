***Settings****
Library    WhiteLibrary
Library    Screenshot
Library    String
Library    C:/Users/THANATHIP N/TestCase/Custom/FileManager.py
Library    C:/Users/THANATHIP N/TestCase/Custom/ExcelManager.py


***Test Cases***
Test POSTApp
    Post Setup
    login POST Application
    Verify that all function of Fare card sale page    ${InitialPurse}    ${IssuingFee}    ${CardDeposit}
    Add Value and cash Amount Received   ${Initial_Add_Value}    ${Cash_Amount_Received}    ${Cash_Amount_Received_Input}
    Verify Total payment and confrim transaction 
    Close Application

***Keywords***
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
Verify that all function of Fare card sale page
    [Arguments]    ${InitialPurse}    ${IssuingFee}    ${CardDeposit}
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
    Verify Text In Textbox	id:ControlCSCInformationC_InitialPurse_TextBox    ${zero_baht}
    Verify Text In Textbox	id:ControlCSCInformationC_IssuingFee_TextBox    ${zero_baht}
    Verify Text In Textbox	id:ControlCSCInformationC_CardDeposit_TextBox    ${CardDeposit}
    Verify Text In Textbox	id:ControlCSCInformationC_ProductSalePrice_TextBox    ${zero_baht}
#Bonus Information		
    Verify Text In Textbox	id:ControlBonusInformationB_BonusMode_TextBox	${Not_Available}
    Verify Text In Textbox	id:ControlBonusInformationB_BonusBeforeCardSale_textbox	${zero_baht}
    Verify Text In Textbox	id:ControlBonusInformationB_BonusAdded_textbox	${zero_baht}
    Verify Text In Textbox	id:ControlBonusInformationB_BonusAfterCardSale_textbox	${zero_baht}
#Payment		
    Verify Text In Textbox	id:ControlPayment_TotalAmountReceived_TextBox	${EMPTY}
    Verify Text In Textbox	id:ControlPayment_TotalPayment_TextBox	${EMPTY}
    Verify Text In Textbox	id:ControlPayment_ChangeDue_TextBox	${EMPTY}

Add Value and cash Amount Received
    [Arguments]    ${Initial_Add_Value}    ${Cash_Amount_Received}    ${Cash_Amount_Received_Input}
    Attach Window	id:MainWindow	
    Item Should Be Enabled	text:100	
    Item Should Be Enabled	text:200	
    Item Should Be Enabled	text:300	
    Item Should Be Enabled	text:500
    sleep    3s
    Run keyword If    '${Initial_Add_Value}'=='100'    Click Button	text:100    ELSE IF    '${Initial_Add_Value}'=='200'    Click Button	text:200    ELSE IF    '${Initial_Add_Value}'=='300'    Click Button    text:300    ELSE IF    '${Initial_Add_Value}'=='500'    Click Button	text:500    ELSE    Input Text To Textbox    id:ControlInitialAddValue_Addvalue_textbox    ${Initial_Add_Value}        
    sleep    3s
    Select Combobox Value	id:ControlPaymentMode_Payment_combobox	${Payment_Mode}
    Item Should Be Enabled	id:ControlCashAmountReceive_btn100_button	
    Item Should Be Enabled	id:ControlCashAmountReceive_btn200_button	
    Item Should Be Enabled	id:ControlCashAmountReceive_btn300_button	
    Item Should Be Enabled	id:ControlCashAmountReceive_btn500_button	
    Item Should Be Disabled	id:ControlCashAmountReceive_btnBlank_button	
    Item Should Be Enabled	id:ControlCashAmountReceive_CashReceived_textbox
    ${Amount1}    Run keyword And Return Status    Button Text Should Contain	id:ControlCashAmountReceive_btn100_button	${Cash_Amount_Received}
    Run keyword If    '${Amount1}'=='True'    Click Button    id:ControlCashAmountReceive_btn100_button  
    ${Amount2}    Run keyword And Return Status    Button Text Should Contain	id:ControlCashAmountReceive_btn200_button	${Cash_Amount_Received}
    Run keyword If    '${Amount2}'=='True'    Click Button    id:ControlCashAmountReceive_btn200_button 
    ${Amount3}    Run keyword And Return Status    Button Text Should Contain	id:ControlCashAmountReceive_btn300_button	${Cash_Amount_Received}
    Run keyword If    '${Amount3}'=='True'    Click Button    id:ControlCashAmountReceive_btn300_button 
    ${Amount4}    Run keyword And Return Status    Button Text Should Contain    id:ControlCashAmountReceive_btn500_button    ${Cash_Amount_Received}
    Run keyword If    '${Amount4}'=='True'    Click Button    id:ControlCashAmountReceive_btn500_button
    ${Amount5}    Run keyword And Return Status    Button Text Should Be    id:ControlCashAmountReceive_btnBlank_button    ${Cash_Amount_Received}
    Run keyword If    '${Amount5}'=='True'    Click Button    id:ControlCashAmountReceive_btnBlank_button
    Run keyword If    '${Cash_Amount_Received_Input}'!='${EMPTY}'    Input Text To Textbox    id:ControlCashAmountReceive_CashReceived_textbox    ${Cash_Amount_Received_Input}  
    
Verify Total payment and confrim transaction 
    Item Should Be Disabled    text:100
    Item Should Be Disabled   text:200
    Item Should Be Disabled    text:300
    Item Should Be Disabled    text:500
    Item Should Be Disabled    id:ControlInitialAddValue_Addvalue_textbox
    #Payment Mode
    ${Cash}    Evaluate    ${Initial_Add_Value}+${CardDeposit}
    ${Cash}    evaluate    ('{:,.2f}'.format(${${Cash}))
    Item Should Be Disabled    id:ControlPaymentMode_Payment_combobox
    Verify Text In Textbox    id:ControlPaymentMode_Cash_textbox    ${Cash}
    Verify Text In Textbox    id:ControlPaymentMode_CreditCard_textbox    ${zero_baht}
    Verify Text In Textbox    id:ControlPaymentMode_CreditCardNo_textbox    ${EMPTY}
    Verify Text In Textbox    id:ControlPaymentMode_Voucher_textbox    ${EMPTY}
    Verify Text In Textbox    id:ControlPaymentMode_VoucherNo_textbox    ${EMPTY}
    #Cash Amount Recevied
    Item Should Be Disabled    id:ControlCashAmountReceive_btn100_button
    Item Should Be Disabled    id:ControlCashAmountReceive_btn200_button
    Item Should Be Disabled    id:ControlCashAmountReceive_btn300_button
    Item Should Be Disabled   id:ControlCashAmountReceive_btn500_button
    Item Should Be Disabled    id:ControlCashAmountReceive_btnBlank_button
    Item Should Be Disabled    id:ControlCashAmountReceive_CashReceived_textbox
    #CSC information
    ${Initial_Add_Value}    evaluate    ('{:,.2f}'.format(${Initial_Add_Value}))
    Verify Text In Textbox	id:ControlCSCInformationC_InitialPurse_TextBox    ${Initial_Add_Value}
    Verify Text In Textbox	id:ControlCSCInformationC_IssuingFee_TextBox    ${IssuingFee}
    Verify Text In Textbox	id:ControlCSCInformationC_CardDeposit_TextBox    ${CardDeposit}
    Verify Text In Textbox	id:ControlCSCInformationC_ProductSalePrice_TextBox    ${zero_baht}
    #Bonus Information
    Verify Text In Textbox    id:ControlBonusInformationB_BonusMode_TextBox    ${Not_Available}
    Verify Text In Textbox    id:ControlBonusInformationB_BonusBeforeCardSale_textbox    ${zero_baht}
    Verify Text In Textbox    id:ControlBonusInformationB_BonusAdded_textbox    ${zero_baht}
    Verify Text In Textbox    id:ControlBonusInformationB_BonusAfterCardSale_textbox    ${zero_baht}
    #Payment
    ${Cash_Amount_Received}    evaluate    ('{:,.2f}'.format(${Cash_Amount_Received}))
    Verify Text In Textbox    id:ControlPayment_TotalAmountReceived_TextBox    ${Cash_Amount_Received}
    Verify Text In Textbox    id:ControlPayment_TotalPayment_TextBox    ${Cash}
    ${Chang_Due}    Evaluate    ${Cash_Amount_Received}-${Cash}
    ${Chang_Due}    evaluate    ('{:,.2f}'.format(${Chang_Due}))
    Verify Text In Textbox    id:ControlPayment_ChangeDue_TextBox    ${Chang_Due}
    #Button
    Item Should Be Disabled   id:ControlMainCardOperation_Confirm_button
    Item Should Be Enabled     id:ControlMainCardOperation_PrintReceipt_button
    #Click Button    id:ControlMainCardOperation_Confirm_button


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
${zero_baht}    0.00
${fiveH_baht}    500.00
${fiffy_baht}    50.00
${Not_Available}    Not Available
${no_pass_ava}    No Pass Available
${Project_Name}    Devlop
${Excelname}    Data_Add_Value_Cash_Payment_with_Change_due.xlsx
