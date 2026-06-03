public with sharing class GenericTableController {
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String objectName) {
        try {
            String query = 'SELECT Id, Name ';
            String sanitizedObject = String.escapeSingleQuotes(objectName);
            
            if (sanitizedObject == 'Medical_Event__c') {
                query += ', Name__c, Start__c, End__c, Event_Type__c, Status__c, Max_Seats__c ';
            } else if (sanitizedObject == 'Clinic_Organizer__c') {
                query += ', Email__c, Phone__c ';
            } else if (sanitizedObject == 'Speaker__c') {
                query += ', Email__c, Specialisation__c ';
            } else if (sanitizedObject == 'Attendees__c') {
                query += ', Email__c, Company_Instituition_Name__c ';
            } else if (sanitizedObject == 'Location__c') {
                query += ', City__c, State__c, Landmark__c ';
            }
            
            query += ' FROM ' + sanitizedObject;
            return Database.query(query);
            
        } catch (Exception e) {
            throw new AuraHandledException('Erro ao buscar registros: ' + e.getMessage());
        }
    }
}