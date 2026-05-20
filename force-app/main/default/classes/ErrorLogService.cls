public inherited sharing class ErrorLogService {
    public static void createErrorLog(Datetime logTime, String details, String process) {
        
        Error_Log__c newLog = new Error_Log__c();
        
        newLog.Log_Date_Time__c = logTime;
        newLog.Log_Details__c = details;
        newLog.Process_Name__c = process;
        
        try {
            insert newLog;
        } catch (Exception ex) {
            System.debug('Failed to insert Error Log: ' + ex.getMessage());
        }
    }
}