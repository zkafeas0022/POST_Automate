***Settings****
Library    WhiteLibrary     
#Library    Screenshot
Library    Collections
Library    OperatingSystem
Library    String
#Library    C:/Users/THANATHIP N/TestCase/Custom/FileManager.py
Library    C:/Users/THANATHIP N/TestCase/Custom/ExcelManager.py

***Test Cases***
refund invalid
    Post Setup
    Copy File    ${dir_PD_Parameters_Flie}    ${dir_PD_Parameters_config}
    login POST Application
    :FOR	${iData}	IN    @{TestDataRequest}
    \    Setup Test Data
    \    ${ExecuteTestResult}	Run Keyword And Ignore Error    CSC Refund Information    ${iData}
    Close Application


***Keywords***
CSC Refund Information
    [Arguments]    ${iData}
    Post Setup
    ${Add_Value}    Get Value Of Test Data Request By Name	${iData}	Add_Value
    ${Cash_Amount_Received}    Get Value Of Test Data Request By Name	${iData}	Cash_Amount_Received
    ${Cash_Amount_Received_Input}    Get Value Of Test Data Request By Name	${iData}	Cash_Amount_Received_Input
    ${ErrorSummary_excel}    Get Value Of Test Data Response By Name    @{TestDataReponse}    errorSummary
    ${ErrorMessage_excel}    Get Value Of Test Data Response By Name	@{TestDataReponse}    errorMessage	
    Verify that all function of Refund page
    Verify refunded calculations    ${iData}    ${ErrorSummary_excel}    ${ErrorMessage_excel}
    


Post Setup
    Copy File  ${dir_sim_reader_card_sale}    ${dir_post_config_ini}
    Fetch Configuration From Excel    ${Project_Name}    ${Excelname}    Environment
    @{TestDataRequest}	Fetch BUS Data From Excel	${Project_Name}	${TEST_NAME}	${Excelname}	BUS request
    @{TestDataReponse}	Fetch BUS Data From Excel	${Project_Name}	${TEST_NAME}	${Excelname}	BUS response      #Add response
    Set Global Variable    @{TestDataRequest}
    Set Global Variable    @{TestDataReponse}
    
    


Fetch Configuration From Excel
    [Arguments]    ${Project_Name}    ${Excelname}    ${SheetName}
    Log	Test Data for Excel Name : ${ExcelName}			
    ${test_dir}    Set Variable    C:\\Users\\THANATHIP N\\TestCase		
    Open Excel File    ${test_dir}\\Test Data\\${ExcelName}			
    ${rowcount}	Get Row Count	${SheetName}		
    @{name}	Get Cell Value By Column	${SheetName}	1	
    @{value}	Get Cell Value By Column	${SheetName}	2	
    :FOR	${INDEX}	IN RANGE	0	${rowcount-1}
    \    Set Global Variable	${name[${INDEX}]}	${value[${INDEX}]}




Fetch BUS Data From Excel    
    [Arguments]    ${ProjectName}    ${Testcase}    ${ExcelName}    ${SheetName}
    Log	Test Data for Excel Name : ${ExcelName}							
    ${TestData}	Set Variable							
    ${test_dir}=	Get Current Test Directory	${ProjectName}
    ${test_dir}    Remove String    ${test_dir}    \    ${Foldername}				
    Open Excel File	${test_dir}\\Test Data\\${ExcelName}							              
    ${listdata_Excel}	Create List							
    ${colcount}	Get Column Count	${SheetName}						
    :FOR	${iCol}	IN RANGE	4	${colcount+1}				
    \    ${head_title}	Get Cell Value By Position	${SheetName}	1	${iCol}			
    \    ${check_request}	Run Keyword And Return Status	Should Contain	${head_title.strip().upper()}	REQUEST VALUE			
    \    ${check_response}	Run Keyword And Return Status	Should Contain	${head_title.strip().upper()}	RESPONSE VALUE
    \    ${check_title}	Set Variable If	${check_request} or ${check_response}	${True}	${False}		
    \    ${list_datatest}	Run Keyword If	${check_title}	Fetch BUS Data From Excel To List Level	${SheetName}	${Testcase}	${iCol}
    \    ${count_datalist}	Get Length	${list_datatest}				
    \    ${flag_empty}	Verify Test Data Is Empty	${list_datatest}				
    \    Run Keyword If	${count_datalist} != 0 and ${flag_empty} == ${False}	Append To List	${listdata_Excel}	${list_datatest}
    \    Log List	${listdata_Excel}					
    \    Return From Keyword	${listdata_Excel}						


Fetch BUS Data From Excel To List Level
    [Arguments]    ${SheetName}    ${Testcase}    ${Column}								
   	@{Fetch_testname}	Get Cell Value By Column	${SheetName}	2					
    @{Fetch_param}	Get Cell Value By Column	${SheetName}	3					
    @{data_request}	Get Cell Value By Column	${SheetName}	${Column}					
    ${rowcount}	Get Row Count	${SheetName}						
    ${datalist_main}	Create List							
    :FOR	${iRow}	IN RANGE	0	${rowcount}				
    \    ${datalist_sub}	Create List						
    \    ${check_datarow}	Run Keyword And Return Status	Variable Should Not Exist	${Fetch_testname[${iRow}]}				
    \    Continue For Loop If	${check_datarow}						
    \    ${data_testname}	Convert To String	${Fetch_testname[${iRow}]}					
    \    ${Testcase}	Convert To String	${Testcase}
    #\    ${data_testname}    Decode Bytes To String	${data_testname}    UTF-8
    #\    log    ${data_testname}				
    \    ${check_testname}	Run Keyword And Return Status	Should Be Equal	${data_testname.strip().upper()}	${Testcase.strip().upper()}			
    \    ${variable_name}	Set Variable If	${check_testname}	${Fetch_param[${iRow}]}				
    \    ${variable_name}	Encode String To Bytes	${variable_name}	UTF-8				
    \    ${variable_name}	Decode Bytes To String	${variable_name}	UTF-8				
    \    ${variable_value}	Set Variable If	${check_testname}	${data_request[${iRow}]}				
    \    ${variable_value}	Encode String To Bytes	${variable_value}	UTF-8				
    \    ${variable_value}	Decode Bytes To String	${variable_value}	UTF-8				
    \    Append To List	${datalist_sub}    ${variable_name}    ${variable_value}	
    \    Append To List	${datalist_main}	${datalist_sub}			
    Log List	${datalist_main}							
    Return From Keyword	${datalist_main}							


Verify Test Data Is Empty
    [Arguments]    ${data_test}
    ${count_empty}	Set Variable	0							
    ${count_notempty}	Set Variable	0							
    ${flag_testdes}	Set Variable	${False}							
    ${datalist_length}	Get Length	${data_test}							
    :FOR	${iList}	IN RANGE	0	${datalist_length}					
    \    ${list_variable}	Set Variable	${data_test[${iList}]}						
    \    ${variable_name}	Set Variable	${list_variable[0].strip()}						
    \    ${variable_value}	Set Variable	${list_variable[1].strip()}						
    \    ${check_testdes}	Run Keyword And Return Status	Should Be Equal	${variable_name.strip().upper()}	${TestDescription_Param}				
    \    ${flag_testdes}	Set Variable If	${check_testdes}	${True}	${flag_testdes}				
    \    Continue For Loop If	${check_testdes}							
    \    ${count_empty}	Run Keyword If	'${variable_value}' == '${EMPTY}' or '${variable_value}' == '${NULL}' or '${variable_value}' == '${SPACE}'	Evaluate	int(${count_empty})+1	ELSE	Set Variable	${count_empty}	
    \    ${count_notempty}	Run Keyword If	'${variable_value}' != '${EMPTY}' and '${variable_value}' != '${NULL}' and '${variable_value}' != '${SPACE}'	Evaluate	int(${count_notempty})+1	ELSE	Set Variable	${count_notempty}	
    ${data_total}	Run Keyword If	${flag_testdes}	Evaluate	int(${datalist_length})-1	ELSE	Set Variable	${datalist_length}		
    ${flag_checked}	Set Variable If	'${data_total}' == '${count_empty}'	${True}	${False}					
    Return From Keyword If	${flag_checked} == ${True}	${True}							
    Return From Keyword If	${flag_checked} == ${False}	${False}							
									
Get Value Of Test Data Request By Name
    [Arguments]    ${data_request}    ${data_name} 
    ${datalist_length}	Get Length	${data_request}			
    :FOR	${iList}	IN RANGE	0	${datalist_length}	
    \    ${list_variable}	Set Variable	${data_request[${iList}]}			
	\    ${variable_name}	Set Variable	${list_variable[0].strip()}			
    \    ${variable_value}	Set Variable	${list_variable[1].strip()}			
    \    ${Flag_Checked}	Run Keyword And Return Status	Should Be Equal	${variable_name.strip().upper()}	${data_name.strip().upper()}	
    \    Exit For Loop If	${Flag_Checked}				
    Return From Keyword	${variable_value}				

Get Value Of Test Data Response By Name     #Delect .string,.upper because library error.
    [Arguments]    ${data_response}    ${data_name}
    log    ${data_name}
    ${datalist_length}  Get Length  ${data_response}            
    :FOR    ${iList}    IN RANGE    0   ${datalist_length}  
    \    ${list_variable}   Set Variable    ${data_response[${iList}]}          
    \    ${variable_name}   Set Variable    ${list_variable[0]}         
    \    ${variable_value}  Set Variable    ${list_variable[1]}
    \    log    ${variable_name}
    \    log    ${data_name}          
    \    ${Flag_Checked}    Run Keyword And Return Status   Should Be Equal    ${variable_name}    ${data_name}    
    \    Exit For Loop If   ${Flag_Checked}             
   Return From Keyword  ${variable_value}


Get Value response
    [Arguments]    ${data_response}    ${data_name} 
    ${datalist_length}	Get Length	${data_response} 			
    :FOR	${iList}	IN RANGE	0	${datalist_length}	
    \    ${list_variable}	Set Variable	${data_response[${iList}]}			
	\    ${variable_name}	Set Variable	${list_variable[0].strip()}			
    \    ${variable_value}	Set Variable	${list_variable[1].strip()}			
    \    ${Flag_Checked}	Run Keyword And Return Status	Should Be Equal	${variable_name.strip().upper()}	${data_name.strip().upper()}	
    \    Exit For Loop If	${Flag_Checked}				
    Return From Keyword	${variable_value}
								
Get Current Test Directory	
    [Arguments]    ${foldername}
    ${cur_dir}=	Split String	${CURDIR}	\\					
    ${dir_length}=	Get Length	${cur_dir}						
    :FOR	${i}	IN RANGE	0	${dir_length}				
    \    ${dir_resource}=	Run Keyword If	${i} == 0	Set Variable	${cur_dir[${i}]}	ELSE	Set Variable	${dir_resource}\\${cur_dir[${i}]}	
    \    Exit For Loop If	'${cur_dir[${i}]}' == '${ProjectName}'							
    Return From Keyword	${dir_resource}	

Create Log Result
    [Arguments]    ${Project_Name}
    ${log_folder_dtstamp}	Evaluate	str(datetime.datetime.now()).replace("-", "").replace(":", "").replace(".", "").replace(" ", "")	modules=datetime	
    ${log_folder_dtstamp}	Evaluate	str("${log_folder_dtstamp}")[:-6]		
    ${test_dir}	Get Current Test Directory	${ProjectName}		
    Create Folder	${test_dir}\\Results	Results_${TEST_NAME}_${log_folder_dtstamp}		
    Create Folder	${test_dir}\\Results\\Results_${TEST_NAME}_${log_folder_dtstamp}	LogImg		
    ${log_filename_dtstamp}	Set Variable	Results_${TEST_NAME}_${log_folder_dtstamp}		
    ${log_folder_dtstamp}	Set Variable	${test_dir}\\Results\\Results_${TEST_NAME}_${log_folder_dtstamp}		
    ${log_folder_img_dtstamp}	Set Variable	${log_folder_dtstamp}\\LogImg		
    Set Global Variable	${log_filename_dtstamp}			
    Set Global Variable	${log_folder_dtstamp}			
    Set Global Variable	${log_folder_img_dtstamp}			
    Set Screenshot Directory	${log_folder_img_dtstamp}			
    OperatingSystem.Copy File	${test_dir}\\logo.png	${log_folder_dtstamp}\\LogImg\\logo.png	

					
						
					
Setup Test Data							
    ${MasterDataSources}	Create Dictionary			
    Set Global Variable	${MasterDataSources}			
    ${FlagExecute}	Set Variable	${True}		
    Set Global Variable	${FlagExecute}			
    #${DataIteration}	Evaluate	int(${DataIteration})+1
    #Set Global Variable	${DataIteration}			
    ${TestDescription}	Set Variable			
    Set Global Variable	${TestDescription}			
    ${postfix_dtstamp}	Evaluate	str(datetime.datetime.now()).replace("-", "").replace(":", "").replace(".", "").replace(" ", "")	modules=datetime	
    Set Global Variable	${postfix_dtstamp}			
    ${Log_Result}	Create List			
    Set Global Variable	${Log_Result}			
    ${DictByPass}	Create Dictionary			
    Set Global Variable	${DictByPass}			
    ${DataTestTimeStart}	Evaluate	datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")	modules=datetime	
    Set Global Variable	${DataTestTimeStart}			
    Log Variables				
                    
Log Test Step Result
    [Arguments]    ${teststep}    ${result}    ${log_text}=None    ${log_image}=None    ${description}=${EMPTY} 
    ${data_result}	Create List	${teststep}	${result}	${log_text}	${log_image}	${description}	
    Append to List    ${Log_Result}	${data_result}
    
Check Status Test Execution
    Log	Test Status : ${FlagTestSummary}		
    Run Keyword Unless	${FlagTestSummary}	Fail	msg=Automated Script : ${TEST_NAME} Test is Failed (Please, See More Detail on Log Test Path : ${log_folder_dtstamp})


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
    Verify Label    ${Path_UserIDValue}    ${POST_USER}
    Verify Label    ${Path_RoleNameValue}    ${Role}
    sleep    2s


Verify that all function of Add value page
    #[Arguments]
    Attach Window	id:MainWindow
    ${current_title} =	get window title
    log    ${current_title}	
    #sleep    10s
#Add Value	
    Item Should Be Enabled	id:ControlAddValue_bt1_button
    Item Should Be Enabled	id:ControlAddValue_bt2_button
    Item Should Be Enabled	id:ControlAddValue_bt3_button
    Item Should Be Enabled	id:ControlAddValue_bt4_button
    Item Should Be Disabled	id:ControlAddValue_bt5_button
    Item Should Be Enabled	id:ControlAddValue_Addvalue_textbox
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
    ${PurseBeforeAddValue}    Get Text From Textbox    id:ControlCSCInformationB_PurseBeforeAddValue_TextBox
    Verify Text In Textbox	id:ControlCSCInformationB_PurseBeforeAddValue_TextBox    ${PurseBeforeAddValue}
    Verify Text In Textbox	id:ControlCSCInformationB_ValueAddedtoPurse_TextBox    ${zero_baht}
    Verify Text In Textbox	id:ControlCSCInformationB_PurseAfterAddValue_TextBox	${PurseBeforeAddValue}

#Bonus Information		
    Verify Text In Textbox	id:ControlBonusInformationB_BonusMode_TextBox	${Not_Available}
    Verify Text In Textbox	id:ControlBonusInformationB_BonusBeforeCardSale_textbox	${zero_baht}
    Verify Text In Textbox	id:ControlBonusInformationB_BonusAdded_textbox	${zero_baht}
    Verify Text In Textbox	id:ControlBonusInformationB_BonusAfterCardSale_textbox	${zero_baht}
#Payment		
    Verify Text In Textbox	id:ControlPayment_TotalAmountReceived_TextBox	${EMPTY}
    Verify Text In Textbox	id:ControlPayment_TotalPayment_TextBox	${EMPTY}
    Verify Text In Textbox	id:ControlPayment_ChangeDue_TextBox	${EMPTY}
    return from keyword    ${PurseBeforeAddValue}

Add value and confrim transaction
    [Arguments]    ${Add_Value}    ${iData}    ${Cash_Amount_Received}    ${Cash_Amount_Received_Input}
    Attach Window	id:MainWindow	
    Item Should Be Enabled	text:100	
    Item Should Be Enabled	text:200	
    Item Should Be Enabled	text:300	
    Item Should Be Enabled	text:500
    sleep    3s
    log    ${Add_Value}
    Run keyword If    '${Add_Value}'=='100'    Click Button	text:100    ELSE IF    '${Add_Value}'=='200'    Click Button	text:200    ELSE IF    '${Add_Value}'=='300'    Click Button    text:300    ELSE IF    '${Add_Value}'=='500'    Click Button	text:500    ELSE    Input Text To Textbox    id:ControlAddValue_Addvalue_textbox    ${Add_Value}        
    ${Payment_Mode}    Get Value Of Test Data Request By Name	${iData}	Payment_Mode
    Select Payment Mode    ${Payment_Mode}
    #Select Combobox Value	id:ControlPaymentMode_Payment_combobox	${Payment_Mode}
    log    ${Cash_Amount_Received}
    ${Amount1}    Run keyword And Return Status    Button Text Should Be    id:ControlCashAmountReceive_btn100_button	${Cash_Amount_Received}
    Run keyword If    '${Amount1}'=='True'    Click Button    id:ControlCashAmountReceive_btn100_button  
    ${Amount2}    Run keyword And Return Status    Button Text Should Be    id:ControlCashAmountReceive_btn200_button	${Cash_Amount_Received}
    Run keyword If    '${Amount2}'=='True'    Click Button    id:ControlCashAmountReceive_btn200_button 
    ${Amount3}    Run keyword And Return Status    Button Text Should Be    id:ControlCashAmountReceive_btn300_button	${Cash_Amount_Received}
    Run keyword If    '${Amount3}'=='True'    Click Button    id:ControlCashAmountReceive_btn300_button 
    ${Amount4}    Run keyword And Return Status    Button Text Should Be    id:ControlCashAmountReceive_btn500_button    ${Cash_Amount_Received}
    Run keyword If    '${Amount4}'=='True'    Click Button    id:ControlCashAmountReceive_btn500_button
    ${Amount5}    Run keyword And Return Status    Button Text Should Be    id:ControlCashAmountReceive_btnBlank_button    ${Cash_Amount_Received}
    Run keyword If    '${Amount5}'=='True'    Click Button    id:ControlCashAmountReceive_btnBlank_button
    #Run keyword If    '${Cash_Amount_Received_Input}'!='${EMPTY}'    Input Text To Textbox    id:ControlCashAmountReceive_CashReceived_textbox    ${Cash_Amount_Received_Input} 
    Click Button    id:ControlMainCardOperation_Confirm_button

Cash Payment Verify Total payment
    [Arguments]    ${Add_Value}    ${PurseBeforeAddValue}    ${Cash_Amount_Received}
    log    ${PurseBeforeAddValue}
    Item Should Be Disabled    text:100
    Item Should Be Disabled   text:200
    Item Should Be Disabled    text:300
    Item Should Be Disabled    text:500
    Item Should Be Disabled    id:ControlAddValue_Addvalue_textbox
    #Payment Mode
    ${Add_Value}    evaluate    ('{:,.2f}'.format(${Add_Value}))
    Item Should Be Disabled    id:ControlPaymentMode_Payment_combobox
    Verify Text In Textbox    id:ControlPaymentMode_Cash_textbox    ${Add_Value}
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
    ${PurseBeforeAddValue}    Remove String    ${PurseBeforeAddValue}    ,
    ${Amount_BeforeAddValue}    evaluate    ${PurseBeforeAddValue}+${Add_Value}
    ${Amount_BeforeAddValue}    Evaluate    ('{:,.2f}'.format(${Amount_BeforeAddValue}))
    ${PurseBeforeAddValue}    Evaluate    ('{:,.2f}'.format(${PurseBeforeAddValue}))
    Verify Text In Textbox	id:ControlCSCInformationB_PurseBeforeAddValue_TextBox    ${PurseBeforeAddValue}
    Verify Text In Textbox	id:ControlCSCInformationB_ValueAddedtoPurse_TextBox    ${Add_Value}
    Verify Text In Textbox	id:ControlCSCInformationB_PurseAfterAddValue_TextBox	${Amount_BeforeAddValue}
    #Bonus Information
    Verify Text In Textbox    id:ControlBonusInformationB_BonusMode_TextBox    ${Not_Available}
    Verify Text In Textbox    id:ControlBonusInformationB_BonusBeforeCardSale_textbox    ${zero_baht}
    Verify Text In Textbox    id:ControlBonusInformationB_BonusAdded_textbox    ${zero_baht}
    Verify Text In Textbox    id:ControlBonusInformationB_BonusAfterCardSale_textbox    ${zero_baht}
    #Payment
    ${Cash_Amount_Received}    Evaluate    ('{:,.2f}'.format(${Cash_Amount_Received})) 
    Verify Text In Textbox    id:ControlPayment_TotalAmountReceived_TextBox    ${Cash_Amount_Received} 
    Verify Text In Textbox    id:ControlPayment_TotalPayment_TextBox    ${Add_Value}
    ${Amount_ChangeDue}    Evaluate    ${Cash_Amount_Received}-${Add_Value}
    ${Amount_ChangeDue}    Evaluate    ('{:,.2f}'.format(${Amount_ChangeDue}))
    Verify Text In Textbox    id:ControlPayment_ChangeDue_TextBox    ${Amount_ChangeDue}
    #Button
    Item Should Be Disabled   id:ControlMainCardOperation_Confirm_button
    Item Should Be Enabled     id:ControlMainCardOperation_PrintReceipt_button


Verify that all function of Refund page
    Click Button    id:ControlOption_RefundCSC_button
    Item Should Be Enabled    id:ControlCSCRefundInformation_PurseValue_textbox
    Item Should Be Enabled    id:ControlCSCRefundInformation_CardDeposit_textbox
    Item Should Be Enabled    id:ControlCSCRefundInformation_RefundAmoun_textbox
    Item Should Be Enabled    id:ControlCSCRefundInformation_RefundAdminFee_textbox
    Item Should Be Enabled    id:ControlCSCRefundInformation_RefundAmountPayable_textbox



Verify refunded calculations
    [Arguments]    ${iData}    ${ErrorSummary_excel}    ${ErrorMessage_excel}
    ${Check_PurseValue}    Run Keyword And Return Status    Wait Until Item Exists    id:ControlCSCRefundInformation_PurseValue_textbox   5s
    ${PurseValue}   Run keywordIf    '${Check_PurseValue}'=='True'    Get Text From Textbox    id:ControlCSCRefundInformation_PurseValue_textbox
    ${PurseValue}   Run keyword if    '${PurseValue}'!='${EMPTY}'    Remove String    ${PurseValue}    ,
    ${Card_Deposit}    Get Value Of Test Data Request By Name	${iData}	Card_Deposit
    ${Refund_Admin_Fee}    Get Value Of Test Data Request By Name	${iData}	Refund_Admin_Fee
    ${Refund_Amount}   Evaluate    ${PurseValue}+${Card_Deposit}
    ${Refund_Amount}   Evaluate    ('{:.0f}'.format(${Refund_Amount}))
    ${Refund_Admin_Fee}    Evaluate    ('{:.0f}'.format(${Refund_Admin_Fee}))
    ${Check_Purse_MoreThan}    Evaluate    ${Refund_Amount}>${Refund_Admin_Fee}
    ${Refund_Amount_Payable}    Run keyword If    '${Check_Purse_MoreThan}'=='True'    More Than Refund Admin Fee    ${Refund_Amount}   ${Refund_Admin_Fee}    ${PurseValue}    ${Card_Deposit}
    Run keyword If    '${Check_Purse_MoreThan}'=='False'    Less Than Refund Admin Fee    ${Refund_Amount}   ${Refund_Admin_Fee}    ${PurseValue}    ${Card_Deposit}    ${ErrorSummary_excel}    ${ErrorMessage_excel}
    ${datalist_refund}	Create Dictionary   
    Set To Dictionary    ${datalist_refund}    PurseValue=${PurseValue}    Card_Deposit=${Card_Deposit}    Refund_Amount=${Refund_Amount}     Refund_Admin_Fee=${Refund_Admin_Fee}    Refund_Amount_Payable=${Refund_Amount_Payable}
    Return from keyword    ${datalist_refund}	



More Than Refund Admin Fee
    [Arguments]    ${Refund_Amount}   ${Refund_Admin_Fee}    ${PurseValue}    ${Card_Deposit}
    ${Check_Purse_more_Fee}    Evaluate    ${Refund_Amount}>${Refund_Admin_Fee}
    #${Check_Purse_More_Zero}    Evaluate    ${PurseValue}>0
    ${Refund_Amount_Payable}    Run keyword If    '${Check_Purse_more_Fee}'=='True'    Evaluate    ${Refund_Amount}-${Refund_Admin_Fee}
    Run keyword If    '${Check_Purse_more_Fee}'=='True'    Log    Purse Value:${PurseValue} , Card Deposit:${Card_Deposit} , Refund Amount:${Refund_Amount} , Refund Admin Fee:${Refund_Admin_Fee} , Refund Amount Payable:${Refund_Amount_Payable}
    return from keyword    ${Refund_Amount_Payable}


Less Than Refund Admin Fee
    [Arguments]    ${Refund_Amount}   ${Refund_Admin_Fee}    ${PurseValue}    ${Card_Deposit}    ${ErrorSummary_excel}    ${ErrorMessage_excel}
    Take Desktop Screenshot
    ${Check_Purse_more_Fee}    Evaluate    ${Refund_Amount}==${Refund_Admin_Fee}
    Run keyword If    '${Check_Purse_more_Fee}'=='True'    Attach Window    id:Information_Dialog
    ${Check_Error_AddValue}    Run Keyword And Return Status    Wait Until Item Exists    id:Information_Summary    5s
    ${Check_Error_AddValue}    Run Keyword And Return Status    Wait Until Item Exists    id:Information_Message    5s
    ${Text_Error_App_Summary}    Run Keyword If    '${Check_Error_AddValue}'=='True'    Get Text From Label    id:Information_Summary
    log    ${Text_Error_App_Summary}
    ${Text_Error_App_Message}    Run Keyword If    '${Check_Error_AddValue}'=='True'    Get Text From Label    id:Information_Message
    log    ${Text_Error_App_Message}
    Run Keyword If    '${Check_Error_AddValue}'=='True'    should Contain    ${Text_Error_App_Summary}    ${ErrorSummary_excel}
    Run Keyword If    '${Check_Error_AddValue}'=='True'    should Contain    ${Text_Error_App_Message}    ${ErrorMessage_excel}


Verify CSC Refund Information
    [Arguments]    ${datalist_refund}
    ${datalist_refund['PurseValue']}    Evaluate    ('{:,.2f}'.format(${datalist_refund['PurseValue']}))
    ${datalist_refund['Card_Deposit']}    Evaluate    ('{:,.2f}'.format(${datalist_refund['Card_Deposit']}))
    ${datalist_refund['Refund_Amount']}    Evaluate    ('{:,.2f}'.format(${datalist_refund['Refund_Amount']}))
    ${datalist_refund['Refund_Admin_Fee']}     Evaluate    ('{:,.2f}'.format(${datalist_refund['Refund_Admin_Fee']}))
    ${datalist_refund['Refund_Amount_Payable']}    Evaluate    ('{:,.2f}'.format(${datalist_refund['Refund_Amount_Payable']}))
    Verify Text In Textbox    id:ControlCSCRefundInformation_PurseValue_textbox    ${datalist_refund['PurseValue']}
    Verify Text In Textbox    id:ControlCSCRefundInformation_CardDeposit_textbox    ${datalist_refund['Card_Deposit']}
    Verify Text In Textbox    id:ControlCSCRefundInformation_RefundAmoun_textbox    ${datalist_refund['Refund_Amount']}
    Verify Text In Textbox    id:ControlCSCRefundInformation_RefundAdminFee_textbox    ${datalist_refund['Refund_Admin_Fee']}  
    Verify Text In Textbox    id:ControlCSCRefundInformation_RefundAmountPayable_textbox    ${datalist_refund['Refund_Amount_Payable']}
    #Mouse Click    x=1628    y=991
    Verify Text In Textbox    id:ControlMainCardOperation_TransactionResult_label    Transaction Completed
    Take Desktop Screenshot
    Copy File  ${dir_sim_reader_card_sale}    ${dir_post_config_ini}
    Click Button    id:ControlMainCardOperation_Home_button


Logout POST Apppication
    Click Button    id:ControlMainCardOperation_Home_button
    Click Button    id:ControlMainMenu_Logout_button
    Attach window    id:Confirmation_Dialog
    Click Button    id:ConfirmationPreferNo_YesButton




***Variables***
${MainWindow}    id:MainWindow
${dir_PD_Parameters_Flie}    C:/Users/THANATHIP N/TestCase/Backupsimreader/Refund/PD_PurseValue_LessThan_Fee/BSS_CSPA.SYS
${dir_PD_Parameters_config}    C:/AFC/POST/Parameters/Active
${dir_sim_reader_card_sale}    C:/Users/THANATHIP N/TestCase/Backupsimreader/Refund/Card_PurseValue_LessThan_Fee_LessThan_zero/SimulateCardReader.ini
${dir_post_config_ini}    C:/AFC/POST/POSTApplication/ConfigINI/
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
${Foldername}    refundinvalid
${zero_baht}    0.00
${fiveH_baht}    500.00
${fiffy_baht}    50.00
${Not_Available}    Not Available
${no_pass_ava}    No Pass Available
${Project_Name}    Devlop
${ContinueOnFailure}    True
${Excelname}    Data_Refund_EN_Purse_Value_Card_Deposit_Less_Than_Refund_Admin_Fee_Purse_LessThan_Zero.xlsx