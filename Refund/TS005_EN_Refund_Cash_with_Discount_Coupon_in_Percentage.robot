***Settings****
Library    WhiteLibrary     
#Library    Screenshot
Library    Collections
Library    OperatingSystem
Library    String
#Library    C:/Users/THANATHIP N/TestCase/Custom/FileManager.py
Library    C:/Users/THANATHIP N/TestCase/Custom/ExcelManager.py


***Test Cases***
Refund Cash with Discount Coupon in Percentage

    Post Setup
    Copy File    ${dir_PD_BSS_CSPA_Flie}    ${dir_PD_Parameters_config}
    login POST Application
    :FOR	${iData}	IN    @{TestDataRequest}
    \    Setup Test Data
    \    ${ExecuteTestResult}	Run Keyword And Ignore Error    CSC Refund Information    ${iData}
    Close Application


***Keywords***

CSC Refund Information
    [Arguments]    ${iData}
    Post Setup
    Click Button    id:ControlMainCardOperation_Home_button
    ${Add_Value}    Get Value Of Test Data Request By Name	${iData}	Add_Value   
    ${Cash_Amount_Received}        Get Value Of Test Data Request By Name	${iData}	Cash_Amount_Received
    ${Discount_Coupon}    Get Value Of Test Data Request By Name	${iData}	Discount_Coupon
    ${Voucher_No}    Get Value Of Test Data Request By Name	${iData}	Voucher_No
    ${PurseBeforeAddValue}    Verify that all function of Fare card sale page
    Cash with Discount Coupon in Percentage add value and confrim transaction    ${Add_Value}    ${iData}    ${Cash_Amount_Received}    ${Discount_Coupon}    ${Voucher_No}    ${PurseBeforeAddValue}
    Cash with Discount Coupon in Percentage Verify Total payment    ${Discount_Coupon}    ${Voucher_No}    ${Add_Value}    ${PurseBeforeAddValue}    ${Cash_Amount_Received}
    ${PurseAfterAddValue}    Verify that all function of Refund page
    Verify Refund Purae value    ${PurseAfterAddValue}


Post Setup
    Copy File  ${dir_sim_reader_card_sale}    ${dir_post_config_ini}
    Fetch Configuration From Excel    ${Project_Name}    ${Excelname}    Environment
    @{TestDataRequest}	Fetch BUS Data From Excel	${Project_Name}	${TEST_NAME}	${Excelname}	BUS request
    #@{TestDataReponse}	Fetch BUS Data From Excel	${Project_Name}	${TEST_NAME}	${Excelname}	BUS response
    Set Global Variable    @{TestDataRequest}
    #Set Global Variable    @{TestDataReponse}


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
    ${test_dir}    Set Variable    C:\\Users\\THANATHIP N\\TestCase						
    Open Excel File	${test_dir}\\Test Data\\${ExcelName}							
    ${listdata_api}	Create List							
    ${colcount}	Get Column Count	${SheetName}						
    :FOR	${iCol}	IN RANGE	4	${colcount+1}				
    \    ${head_title}	Get Cell Value By Position	${SheetName}	1	${iCol}			
    \    ${check_request}	Run Keyword And Return Status	Should Contain	${head_title.strip().upper()}	REQUEST VALUE			
    \    ${check_response}	Run Keyword And Return Status	Should Contain	${head_title.strip().upper()}	RESPONSE VALUE			
    \    ${check_title}	Set Variable If	${check_request} or ${check_response}	${True}	${False}		
    \    ${list_datatest}	Run Keyword If	${check_title}	Fetch BUS Data From Excel To List Level	${SheetName}	${Testcase}	${iCol}	
    \    ${count_datalist}	Get Length	${list_datatest}
    \    Log List    ${list_datatest} 					
    \    ${flag_empty}	Verify Test Data Is Empty	${list_datatest}					
    \    Run Keyword If	${count_datalist} != 0 and ${flag_empty} == ${False}	Append To List	${listdata_api}	${list_datatest}			
    Log List	${listdata_api}
    log    ${listdata_api}
    Return From Keyword    ${listdata_api}						
								
Fetch BUS Data From Excel To List Level
    [Arguments]    ${SheetName}    ${Testcase}    ${Column}								
   	@{api_testname}	Get Cell Value By Column	${SheetName}	2					
    @{api_param}	Get Cell Value By Column	${SheetName}	3					
    @{data_request}	Get Cell Value By Column	${SheetName}	${Column}					
    ${rowcount}	Get Row Count	${SheetName}						
    ${datalist_main}	Create List							
    :FOR	${iRow}	IN RANGE	0	${rowcount}				
    \    ${datalist_sub}	Create List						
    \    ${check_datarow}	Run Keyword And Return Status	Variable Should Not Exist	${api_testname[${iRow}]}				
    \    Continue For Loop If	${check_datarow}						
    \    ${apidata_testname}	Convert To String	${api_testname[${iRow}]}					
    \    ${Testcase}	Convert To String	${Testcase}
    #\    ${apidata_testname}    Decode Bytes To String	${apidata_testname}    UTF-8
    #\    log    ${apidata_testname}				
    \    ${check_testname}	Run Keyword And Return Status	Should Be Equal	${apidata_testname.strip().upper()}	${Testcase.strip().upper()}			
    \    ${variable_name}	Set Variable If	${check_testname}	${api_param[${iRow}]}				
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
    #Log Many	API Code : ${variable_code}	Data Test Request Name : ${variable_name}	Data Test Request Value : ${variable_value}		
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

Test Log Result
    ${Log_Result}	Get Log Test Case Result						
    ${TestStatus}	Set Variable If	${FlagExecute}	PASSED	FAILED			
    ${TestSummary}	Set Variable	\n --------------------------------------------------------------------------------------------------------------------------------------------------------------- \n Test Script : ${TEST_NAME} \n Data Iteration : 1\n Description : ${TestDescription}\n Test Status : ${TestStatus} \n --------------------------------------------------------------------------------------------------------------------------------------------------------------- \n					
    Log To Console	\n --------------------------------------------------------------------------------------------------------------------------------------------------------------- \n Test Script : ${TEST_NAME} \n Data Iteration : 1 \n Test Status : ${TestStatus} \n --------------------------------------------------------------------------------------------------------------------------------------------------------------- \n						
    ${Check_FileExist}	Run Keyword And Return Status	File Should Exist	${log_folder_dtstamp}\\Automation_TestSummary.txt				
    #Run Keyword Unless	${Check_FileExist}	FileManager.Create File	${log_folder_dtstamp}	Automation_TestSummary	txt	utf8	
    #Append Data To File Us Python	${log_folder_dtstamp}\\Automation_TestSummary.txt	${TestSummary}					
    FileManager.Create File	${log_folder_dtstamp}	${log_filename_dtstamp}    html	utf8			
    FileManager.Write File	${log_folder_dtstamp}\\${log_filename_dtstamp}.html	${Log_Result}	utf8		


Get Log Test Case Result
    ${Log}	Set Variable									
    ${Log_Length}	Get Length	${Log_Result}								
    :FOR	${iLog}	IN RANGE	0	${Log_Length}						
    \    ${Log}	Set Variable	${Log}<b>( ${iLog+1} ) Test Step : </b> <font color="blue">${Log_Result[${iLog}][0]}</font> <br>							
    \    ${Log}	Set Variable If	'${Log_Result[${iLog}][1].strip().upper()}' == 'PASS'	${Log} <b>Result : </b> <font color="green">${Log_Result[${iLog}][1]}</font> <br>	'${Log_Result[${iLog}][1].strip().upper()}' == 'FAIL'	${Log} <b>Result : </b> <font color="red">${Log_Result[${iLog}][1]}</font> <br>	'${Log_Result[${iLog}][1].strip().upper()}' == 'INFO'	${Log} <b>Result : </b> <font color="blue">${Log_Result[${iLog}][1]}</font> <br>	${Log} <b>Result : </b> ${Log_Result[${iLog}][1]} <br>	
    \    ${FlagExecute}	Set Variable If	'${Log_Result[${iLog}][1].strip().upper()}' == 'PASS' or '${Log_Result[${iLog}][1].strip().upper()}' == 'INFO'	${FlagExecute}	'${Log_Result[${iLog}][1].strip().upper()}' == 'FAIL'	${False}	${False}			
    \    ${Log}	Set Variable	${Log} <b>Text : </b> ${Log_Result[${iLog}][2]} <br>							
    \    ${Log}	Set Variable If	"${Log_Result[${iLog}][3]}" != "None"	${Log} <b>Image : </b> <br><br><a href="${Log_Result[${iLog}][3]}"><img width="800" src="${Log_Result[${iLog}][3]}" /></a> <br>	${Log}					
    \    ${Check_Description}	Run Keyword And Return Status	Should Not Be Empty	${Log_Result[${iLog}][4]}						
    \    ${Log}	Set Variable If	${Check_Description}	${Log} <b>Description : </b> <br><textarea rows="10" cols="150">${Log_Result[${iLog}][4]}</textarea>	${Log}					
    \    ${Log}	Set Variable	${Log} <br><br>							
    ${TestStatus}	Set Variable If	${FlagExecute}	<font size="4" color="green"> PASS </font>	<font size="4" color="red"> FAIL </font>						
    ${TestStatusDescription}	Set Variable If	${FlagExecute}	<font size="4">${EMPTY}</font>	<font size="4">${FailureMsg}</font>						
    ${Log}	Set Variable	<!DOCTYPE html><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><html><head><title>Automate Test Report</title></head><body style="font-family: 'Candara';"><img src="LogImg/logo.png" style="float: left; height: 50px; width: 260px; padding-bottom: 10px; padding-right: 10px; padding-right: 30px;"><div style="float: left; width: 500px;"><b>Automation Test Report</b></div><br><div style="float: left; width: 500px;">Software Quality Management</div><br><div style="float: left; width: 500px;">Application Management</div><br><span style="width: 500px;">____________________________________________________________________________________________________________________________________________________________________________________________________________________________</span><br><p><font size="5" ><b>Robot Framework Automation Summary Test Result</b></font></p><table><tr><td><p>&nbsp;</p></td><td><p>&nbsp;</p></td><td><p>&nbsp;</p></td><td><p>&nbsp;</p></td><td><p>&nbsp;</p></td><td><font size="4.5"><b>Test Case : </b></font> <font size="4" color="blue">${TEST_NAME}</font><br><font size="4.5"><b>Test Description : </b></font> <font size="4">${TestDescription}</font><br><font size="4.5"><b>Test Status : </b></font>${TestStatus}<br><font size="4.5"><b>Test Status Description : </b></font>${TestStatusDescription}<br><font size="4.5"><b>Test Time Start : </b></font><font size="4">${DataTestTimeStart}</font><br><font size="4.5"><b>Test Time Stop : </b></font><font size="4">${DataTestTimeStop}</font><br><font size="4.5"><b>Test Time Duration : </b></font><font size="4">${DataTestTimeDuration}</font><br><br>${Log}								
    ${Log}	Set Variable	${Log} </td></tr></table></body><footer style="padding-bottom: 50px; padding-top: 50px"><span style="width: 500px;">____________________________________________________________________________________________________________________________________________________________________________________________________________________________</span><p><b>Contact Us : Automation Test</b></p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Address : BPS Office Floor 17</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Email : Thanathipn@bkkps.co.th</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p></footer></html>								
    ${FlagTestSummary}	Set Variable If	${FlagExecute} == ${False}	${False}	${FlagTestSummary}						
    Set Global Variable	${FlagTestSummary}									
    Set Global Variable	${FlagExecute}									
    Return From Keyword	${Log}									
						
					
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
                    

Analyze Test Result
    [Arguments]    ${executes_test_result}    ${capture_screen}=${True}
    ${DataTestTimeStop}	Evaluate	datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")	modules=datetime				
    Set Global Variable	${DataTestTimeStop}						
    ${DataTestTimeDuration}	Evaluate	datetime.datetime.strptime(str('${DataTestTimeStop}'),'%Y-%m-%d %H:%M:%S.%f') - datetime.datetime.strptime(str('${DataTestTimeStart}'),'%Y-%m-%d %H:%M:%S.%f')	modules=datetime				
    Set Global Variable	${DataTestTimeDuration}						
    ${CheckExecuteResult}	Run Keyword And Return Status	Should Not Be Equal	${executes_test_result}	${NULL}			
    Run Keyword Unless	${CheckExecuteResult}	Fail	msg=Please check data test, because have not any automate test script is executes.				
    ${FlagExecute}	Set Variable If	'${executes_test_result[0]}' == 'FAIL'	${False}	'${executes_test_result[0]}' == 'PASS'	${True}		
    ${CheckVariableFailMsg}	Run Keyword And Return Status	Variable Should Exist	${executes_test_result[1]}				
    ${FailureMsg}	Set Variable If	${CheckVariableFailMsg}	${executes_test_result[1]}	${EMPTY}			
    ${CheckFailureMsgIsNull}	Run Keyword And Return Status	Should Be Equal	${FailureMsg}	${NULL}			
    ${FailureMsg}	Set Variable If	${CheckFailureMsgIsNull}	${EMPTY}	${FailureMsg}			
    ${FailureMsg}	Replace String	${FailureMsg}	\<	${SPACE}			
    ${FailureMsg}	Replace String	${FailureMsg}	\>	${SPACE}			
    ${FailureMsg}	Replace String	${FailureMsg}	\<\/	${SPACE}			
    Run Keyword If	${capture_screen} == ${True} and ${FlagExecute} == ${False}	Run Keyword And Ignore Error	Capture Page Screenshot	filename=robot_analyze_test_result_${postfix_dtstamp}.png			
    Run Keyword If	${capture_screen} == ${True} and ${FlagExecute} == ${False}	Log Test Step Result	\Analyze Fail Test Result	\FAIL	${FailureMsg}	LogImg/robot_analyze_test_result_${postfix_dtstamp}.png	
    Run Keyword If	${capture_screen} == ${False} and ${FlagExecute} == ${False}	Log Test Step Result	\Analyze Fail Test Result	\FAIL	${FailureMsg}		
    Set Global Variable	${FlagExecute}						
    Set Global Variable	${FailureMsg}						

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

Verify that all function of Fare card sale page
    #[Arguments]
    Attach Window	id:MainWindow
    ${current_title} =	get window title
    log    ${current_title}
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

Cash with Discount Coupon in Percentage add value and confrim transaction    
    [Arguments]    ${Add_Value}    ${iData}    ${Cash_Amount_Received}    ${Discount_Coupon}    ${Voucher_No}    ${PurseBeforeAddValue}
    Attach Window	id:MainWindow	
    Item Should Be Enabled	text:100	
    Item Should Be Enabled	text:200	 
    Item Should Be Enabled	text:300	
    Item Should Be Enabled	text:500
    sleep    3s
    log    ${Cash_Amount_Received}
    log    ${Add_Value}
    log    ${Discount_Coupon}
    Run keyword If    '${Add_Value}'=='100'    Click Button	text:100    ELSE IF    '${Add_Value}'=='200'    Click Button	text:200    ELSE IF    '${Add_Value}'=='300'    Click Button    text:300    ELSE IF    '${Add_Value}'=='500'    Click Button	text:500    ELSE    Input Text To Textbox    id:ControlAddValue_Addvalue_textbox    ${Add_Value}        
    ${Payment_Mode}    Get Value Of Test Data Request By Name	${iData}	Payment_Mode
    Select Combobox Value	id:ControlPaymentMode_Payment_combobox	${Payment_Mode}
    log    ${Add_Value}
    log    ${Discount_Coupon}
    Input Text To Textbox    id:ControlPaymentMode_Voucher_textbox    ${Discount_Coupon}   
    Input Text To Textbox    id:ControlPaymentMode_VoucherNo_textbox    ${Voucher_No}    
    ${Amount1}    Run keyword And Return Status    Button Text Should Be    id:ControlCashAmountReceive_btn100_button	${Cash_Amount_Received}
    Run keyword If    '${Amount1}'=='True'    Click Button    id:ControlCashAmountReceive_btn100_button  
    ${Amount2}    Run keyword And Return Status    Button Text Should Be	id:ControlCashAmountReceive_btn200_button	${Cash_Amount_Received}
    Run keyword If    '${Amount2}'=='True'    Click Button    id:ControlCashAmountReceive_btn200_button 
    ${Amount3}    Run keyword And Return Status    Button Text Should Be	id:ControlCashAmountReceive_btn300_button	${Cash_Amount_Received}
    Run keyword If    '${Amount3}'=='True'    Click Button    id:ControlCashAmountReceive_btn300_button
    ${Amount4}    Run keyword And Return Status    Button Text Should Be    id:ControlCashAmountReceive_btn500_button    ${Cash_Amount_Received}
    Run keyword If    '${Amount4}'=='True'    Click Button    id:ControlCashAmountReceive_btn500_button
    ${Amount5}    Run keyword And Return Status    Button Text Should Be    id:ControlCashAmountReceive_btnBlank_button    ${Cash_Amount_Received}
    Run keyword If    '${Amount5}'=='True'    Click Button    id:ControlCashAmountReceive_btnBlank_button
    Click Button    id:ControlMainCardOperation_Confirm_button
   #Run keyword If    '${Cash_Amount_Received_Input}'!='${EMPTY}'    Input Text To Textbox    id:ControlCashAmountReceive_CashReceived_textbox    ${Cash_Amount_Received_Input}

Cash with Discount Coupon in Percentage Verify Total payment
    [Arguments]    ${Discount_Coupon}    ${Voucher_No}    ${Add_Value}    ${PurseBeforeAddValue}    ${Cash_Amount_Received}
    Verify Text In Textbox    id:ControlMainCardOperation_TransactionResult_label    Transaction Completed
    Item Should Be Disabled    text:100
    Item Should Be Disabled   text:200
    Item Should Be Disabled    text:300
    Item Should Be Disabled    text:500
    Item Should Be Disabled    id:ControlAddValue_Addvalue_textbox
    #Payment Mode
    ${Bonus}    Evaluate    (${Add_Value}*${Discount_Coupon})/100
    log    ${Bonus}
    ${Cash}    Run keyword If    '${Discount_Coupon}'=='100'   set Variable    0    ELSE    Evaluate    ${Add_Value}-${Bonus}
    ${Cash}    Evaluate    ('{:,.2f}'.format( ${Cash}))
    ${Bonus}    Evaluate    ('{:,.2f}'.format(${Bonus}))
    Item Should Be Disabled    id:ControlPaymentMode_Payment_combobox
    Verify Text In Textbox    id:ControlPaymentMode_Cash_textbox    ${Cash}
    Verify Text In Textbox    id:ControlPaymentMode_CreditCard_textbox     ${zero_baht}
    Verify Text In Textbox    id:ControlPaymentMode_CreditCardNo_textbox    ${EMPTY}
    Verify Text In Textbox    id:ControlPaymentMode_Voucher_textbox    ${Discount_Coupon}
    Verify Text In Textbox    id:ControlPaymentMode_VoucherNo_textbox    ${Voucher_No}
    Verify Label    id:ControlPaymentMode_VoucherDigit_label    %
    #Cash Amount Recevied
    Item Should Be Disabled    id:ControlCashAmountReceive_btn100_button
    Item Should Be Disabled    id:ControlCashAmountReceive_btn200_button
    Item Should Be Disabled    id:ControlCashAmountReceive_btn300_button
    Item Should Be Disabled   id:ControlCashAmountReceive_btn500_button
    Item Should Be Disabled    id:ControlCashAmountReceive_btnBlank_button
    Item Should Be Disabled    id:ControlCashAmountReceive_CashReceived_textbox
    #CSC information
    ${PurseBeforeAddValue}    Remove string    ${PurseBeforeAddValue}    ,
    ${PurseAfterAddValue}    evaluate    ${PurseBeforeAddValue}+${Cash}
    ${PurseBeforeAddValue}   evaluate    ('{:,.2f}'.format(${PurseBeforeAddValue}))
    Verify Text In Textbox	id:ControlCSCInformationB_PurseBeforeAddValue_TextBox    ${PurseBeforeAddValue}
    Verify Text In Textbox	id:ControlCSCInformationB_ValueAddedtoPurse_TextBox    ${Cash}
    ${PurseAfterAddValue}   evaluate    ('{:,.2f}'.format(${PurseAfterAddValue}))
    Verify Text In Textbox	id:ControlCSCInformationB_PurseAfterAddValue_TextBox	${PurseAfterAddValue}
    #Bonus Information
    Verify Text In Textbox    id:ControlBonusInformationB_BonusMode_TextBox    ${Mode}
    Verify Text In Textbox    id:ControlBonusInformationB_BonusBeforeCardSale_textbox    ${zero_baht}
    Verify Text In Textbox    id:ControlBonusInformationB_BonusAdded_textbox    ${Bonus}
    Verify Text In Textbox    id:ControlBonusInformationB_BonusAfterCardSale_textbox    ${Bonus}
    #Payment
    ${Change_Due}    Evaluate    ${Cash_Amount_Received}-${cash}
    ${Change_Due}    Evaluate    ('{:,.2f}'.format(${Change_Due}))
    ${Cash_Amount_Received}   Evaluate    ('{:,.2f}'.format(${Cash_Amount_Received}))
    Verify Text In Textbox	id:ControlPayment_TotalAmountReceived_TextBox    ${Cash_Amount_Received}
    Verify Text In Textbox	id:ControlPayment_TotalPayment_TextBox    ${Cash}
    Verify Text In Textbox    id:ControlPayment_ChangeDue_TextBox    ${Change_Due}
    #Button
    Item Should Be Disabled   id:ControlMainCardOperation_Confirm_button
    Item Should Be Enabled     id:ControlMainCardOperation_PrintReceipt_button
    


Verify that all function of Refund page
    ${PurseAfterAddValue}    Get Text From Textbox    id:ControlCSCInformationB_PurseAfterAddValue_TextBox
    Click Button    id:ControlOption_RefundCSC_button
    Verify Text In Textbox    id:ControlCSCRefundInformation_PurseValue_textbox    ${PurseAfterAddValue}
    Verify Text In Textbox    id:ControlCSCRefundInformation_CardDeposit_textbox    ${zero_baht}    
    Verify Text In Textbox    id:ControlCSCRefundInformation_RefundAmoun_textbox    ${PurseAfterAddValue}
    Verify Text In Textbox    id:ControlCSCRefundInformation_RefundAdminFee_textbox    ${zero_baht} 
    Verify Text In Textbox    id:ControlCSCRefundInformation_RefundAmountPayable_textbox    ${PurseAfterAddValue}
    return from keyword    ${PurseAfterAddValue}
  
  
Verify Refund Purae value
    [Arguments]    ${PurseAfterAddValue}
    ${PurseAfterAddValue}    Run keyword if    '${PurseAfterAddValue}'!='${EMPTY}'    Remove String    ${PurseAfterAddValue}}    ,
    ${Get_Purae_value}    Get Text From Textbox    id:ControlCSCRefundInformation_PurseValue_textbox
    ${Get_Card_deposit}    Get Text From Textbox    id:ControlCSCRefundInformation_CardDeposit_textbox
    ${Get_Refund_amuong}    Get Text From Textbox    id:ControlCSCRefundInformation_RefundAmoun_textbox
    ${Get_Refund_adminFee}    Get Text From Textbox    id:ControlCSCRefundInformation_RefundAdminFee_textbox
    ${Get_Refund_amoung_payable}    Get Text From Textbox    id:ControlCSCRefundInformation_RefundAmountPayable_textbox
    ${Get_Purae_value}    Run keyword if    '${Get_Purae_value}'!='${EMPTY}'    Remove String    ${Get_Purae_value}    , 
    ${Get_Card_deposit}    Run keyword if    '${Get_Card_deposit}'!='${EMPTY}'    Remove String    ${Get_Card_deposit}    ,
    ${Get_Refund_amuong}    Run keyword if    '${Get_Refund_amuong}'!='${EMPTY}'    Remove String    ${Get_Refund_amuong}    ,  
    ${Get_Refund_adminFee}    Run keyword if    '${Get_Refund_adminFee}'!='${EMPTY}'    Remove String    ${Get_Refund_adminFee}    ,
    ${Get_Refund_amoung_payable}    Run keyword if    '${Get_Refund_amoung_payable}'!='${EMPTY}'    Remove String    ${Get_Refund_amoung_payable}    ,
    Run keyword If    '${Get_Purae_value}'!='${EMPTY}'    should Contain    ${PurseAfterAddValue}    ${Get_Purae_value}
    Run keyword If    '${Get_Refund_amuong}'!='${EMPTY}'    should Contain    ${PurseAfterAddValue}    ${Get_Refund_amuong}
    Run keyword If    '${Get_Refund_amoung_payable}'!='${EMPTY}'    should Contain    ${PurseAfterAddValue}    ${Get_Refund_amoung_payable}
    Mouse Click    x=1628    y=991
    Verify Text In Textbox    id:ControlMainCardOperation_TransactionResult_label    Transaction Completed
    Copy File  ${dir_sim_reader_card_sale}    ${dir_post_config_ini}
    Click Button    id:ControlMainCardOperation_Home_button



**Variables***
${dir_PD_BSS_CSPA_Flie}    C:/Users/THANATHIP N/TestCase/Backupsimreader/BSS_CSPA_Normal/BSS_CSPA.SYS
${dir_PD_Parameters_config}    C:/AFC/POST/Parameters/Active
${dir_sim_reader_card_sale}  C:/Users/THANATHIP N/TestCase/Backupsimreader/Refund/Refund/SimulateCardReader.ini
${dir_post_config_ini}  C:/AFC/POST/POSTApplication/ConfigINI/
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
${zero_baht}    0.00
${fiveH_baht}    500.00
${fiffy_baht}    50.00
${Mode}    Coupon Discount
${Not_Available}    Not Available
${no_pass_ava}    No Pass Available
${Project_Name}    Devlop
${Excelname}    Data_Refund_TS005_EN_Cash_with_Discount_Coupon_in_Percentage.xlsx