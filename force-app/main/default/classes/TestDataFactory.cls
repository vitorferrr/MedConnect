/**
 * @description Classe utilitária para gerar dados de teste baseados no documento do projeto.
 * @author      Vitor Ferreira
 */
@isTest
public class TestDataFactory {
    
    public static Medical_Event__c createEvent(String eventName, Boolean doInsert) {
        Medical_Event__c ev = new Medical_Event__c();
        
        ev.Name__c = eventName; 
        ev.Live__c = true;
        
        ev.Start__c = Datetime.now().addDays(1); 
        ev.End__c = Datetime.now().addDays(2);   
        
        ev.Max_Seats__c = 100;      
        
        if (doInsert) {
            insert ev;
        }
        return ev;
    }

    public static Speaker__c createSpeaker(Boolean doInsert) {
        Speaker__c sp = new Speaker__c();
        sp.Name = 'Dr. Teste da Silva';
        sp.Email__c = 'dr.teste@organizamed.com';
        sp.Phone__c = '81999999999'; 
        
        if (doInsert) {
            insert sp;
        }
        return sp;
    }
}