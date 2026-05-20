/**
 * @description Service class to handle the creation of Error Log records across the application.
 * @author      Vitor Ferreira
 */
public inherited sharing class ErrorLogService {
    
    /**
     * @description Inserts a new Error_Log__c record.
     * @param logTime    Datetime when the error occurred
     * @param details    Complete Stack Trace or Error Message
     * @param process    Name of the Apex Class, Trigger, or LWC
     */
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