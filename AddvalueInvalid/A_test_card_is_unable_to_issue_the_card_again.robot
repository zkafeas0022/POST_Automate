***Settings****
Library    WhiteLibrary     
#Library    Screenshot
Library    Collections
Library    OperatingSystem
Library    String
#Library    C:/Users/THANATHIP N/TestCase/Custom/FileManager.py
Library    C:/Users/THANATHIP N/TestCase/Custom/ExcelManager.py

***Test Cases***
Discount Coupon in Percentage Unable input add value More than 4000

    Post Setup
    login POST Application
    :FOR	${iData}	IN    @{TestDataRequest}
    \    Setup Test Data
    \    ${ExecuteTestResult}	Run Keyword And Ignore Error    Discount Coupon in Percentage Invalid    ${iData}
   #Close Application


***Keywords***

Discount Coupon in Percentage Invalid
    [Arguments]    ${iData}
    Post Setup
    Verify test card check test flag
   
   


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


Verify that all function of Fare card sale page
    #[Arguments]    ${TestDataReponse}
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


Input Data And Verify Error Message
    [Arguments]    ${Add_Value}    ${iData}    ${Cash_Amount_Received}    ${Discount_Coupon}    ${Voucher_No}    ${PurseBeforeAddValue}    ${ErrorSummary_excel}    ${ErrorMessage_excel}
    log    ${ErrorSummary_excel}
    log    ${ErrorMessage_excel}
#Add Value
    Run keyword If    '${Add_Value}'=='100'    Click Button	text:100    ELSE IF    '${Add_Value}'=='200'    Click Button	text:200    ELSE IF    '${Add_Value}'=='300'    Click Button    text:300    ELSE IF    '${Add_Value}'=='500'    Click Button	text:500    ELSE    Input Text To Textbox    id:ControlAddValue_Addvalue_textbox    ${Add_Value}        
    Run Keyword If   ${Add_Value}>4000    Attach Window    id:Information_Dialog
    Take Desktop Screenshot
    ${Check_Error_AddValue}    Run Keyword And Return Status    Wait Until Item Exists    id:Information_Summary    5s
    ${Check_Error_AddValue}    Run Keyword And Return Status    Wait Until Item Exists    id:Information_Message    5s
    ${Text_Error_App_Summary}    Run Keyword If    '${Check_Error_AddValue}'=='True'    Get Text From Label    id:Information_Summary
    log    ${Text_Error_App_Summary}
    ${Text_Error_App_Message}    Run Keyword If    '${Check_Error_AddValue}'=='True'    Get Text From Label    id:Information_Message
    log    ${Text_Error_App_Message}
    Run Keyword If    '${Check_Error_AddValue}'=='True'    should Contain    ${Text_Error_App_Summary}    ${ErrorSummary_excel}
    Run Keyword If    '${Check_Error_AddValue}'=='True'    should Contain    ${Text_Error_App_Message}    ${ErrorMessage_excel}
    Run keyword IF    '${Check_Error_AddValue}'=='True'    Click Button    id:Information_OKButton
    

Verify test card check test flag
    ${Check_Error_AddValue}    Run Keyword And Return Status    Wait Until Item Exists    id:Information_Summary    5s
    ${Check_Error_AddValue}    Run Keyword And Return Status    Wait Until Item Exists    id:Information_Message    5s
    ${Text_Error_App_Summary}    Run Keyword If    '${Check_Error_AddValue}'=='True'    Get Text From Label    id:Information_Summary
    ${Text_Error_App_Message}    Run Keyword If    '${Check_Error_AddValue}'=='True'    Get Text From Label    id:Information_Message
    Verify Text In Textbox    id:Information_TitleBar    Information
    Click Button    id:Information_CardDetail_Button
    ${Check_TestFlage}    Run Keyword And Return Status    Wait Until Item Exists    id:ControlCSCInformation_TestFlage_textbox    5s
    ${Get_TestFlage}    Run keywod If    '${Get_TestFlage}'=='Ture'    Get Text From Textbox    id:ControlCSCInformation_TestFlage_textbox
    #should Contain 





**Variables***
${dir_sim_reader_card_sale}  C:/Users/THANATHIP N/TestCase/Backupsimreader/TestFlag1/SimulateCardReader.ini
${dir_post_config_ini}  C:/AFC/POST/POSTApplication/ConfigINI/
${Foldername}    addvalueinvalid
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
${Excelname}    Data_AddValue_TS005_EN_Cash_with_Discount_Coupon_in_Percentage_Unable_input_add_value_More_than_4000.xlsx