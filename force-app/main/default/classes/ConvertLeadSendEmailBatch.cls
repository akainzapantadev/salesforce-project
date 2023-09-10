/************************************************************************************************************
* @description : ConvertLeadSendEmailBatch
* @author      : Bootcamp A.E.Z
* @date        : 2023-08-10
* **********************************************************************************************************/
public class ConvertLeadSendEmailBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable {
  public Set<Id> contactIds;
  public ConvertLeadSendEmailBatch(){
    contactIds = new Set<Id>();
  }

  public void execute(SchedulableContext sc){
    if(!Test.isRunningTest()){
      Database.executeBatch(new ConvertLeadSendEmailBatch(), 10);
    }
  }

  public Database.QueryLocator start(Database.BatchableContext bc) {
    Set<String> contactEmails = new Set<String>();
    for (Contact c : [SELECT Email FROM Contact WHERE Email != null]) {
      contactEmails.add(c.Email.toLowerCase());
    }
    return Database.getQueryLocator('SELECT Id, Email FROM Lead WHERE Status = \'Working - Contacted\' AND Email NOT IN :contactEmails');
  }

  public void execute(Database.BatchableContext bc, List<Lead> scope) {
    List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
  
    for (Lead lead : scope) {
      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setDoNotCreateOpportunity(true);
      lc.setLeadId(lead.Id);
      lc.setConvertedStatus('Closed - Converted');
      leadConverts.add(lc);
    }
    
    if (!leadConverts.isEmpty()) {
      List<Database.LeadConvertResult> convertResults = Database.convertLead(leadConverts);
      
      for (Database.LeadConvertResult result : convertResults) {
        if (result.isSuccess()) {
          Id convertedContactId = result.getContactId();
          contactIds.add(convertedContactId);
        }
      }
    }
  }

  public void finish(Database.BatchableContext bc) {
    List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
    EmailTemplate et = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName= 'ConvertLeads'];

    for (Contact c : [SELECT Id, Name,AccountId, Email FROM Contact WHERE Id IN :contactIds AND Email != null]){
      
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      email.setTemplateId(et.Id);
      email.setTargetObjectId(c.Id);
      email.setWhatId(c.AccountId);
      email.setSubject('This lead was converted!');
      email.setToAddresses(new List<String>{c.Email});
      email.setPlainTextBody('\n' + 'Thanks for choosing us as a partner.');
      emailMessages.add(email);

    }

    if (emailMessages.size()>0) {
      if(!Test.isRunningTest()){
          Messaging.sendEmail(emailMessages);
      }
    }
  }
}

// public class ConvertLeadSendEmailBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable {
  
//   public Set<Id> contactIds;
//   public Map<String, Id> emailToContactIdMap;

//   public ConvertLeadSendEmailBatch(){
//     contactIds = new Set<Id>();
//     emailToContactIdMap = new Map<String, Id>();
//     for (Contact c : [SELECT Id, Email FROM Contact WHERE Email != null]) {
//       emailToContactIdMap.put(c.Email.toLowerCase(), c.Id);
//     }
//   }

//   public Database.QueryLocator start(Database.BatchableContext bc) {
//     return Database.getQueryLocator('SELECT Id, Email FROM Lead WHERE Status = \'Working - Contacted\' AND Email != null');
//   }

//   public void execute(Database.BatchableContext bc, List<Lead> scope) {
//     List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
  
//     for (Lead lead : scope) {
//       Database.LeadConvert lc = new Database.LeadConvert();
//       lc.setDoNotCreateOpportunity(true);
//       lc.setLeadId(lead.Id);
//       lc.setConvertedStatus('Closed - Converted');
//       if (emailToContactIdMap.containsKey(lead.Email.toLowerCase())) {
//         lc.setContactId(emailToContactIdMap.get(lead.Email.toLowerCase()));
//       }
//       leadConverts.add(lc);
//     }
    
//     if (!leadConverts.isEmpty()) {
//       List<Database.LeadConvertResult> convertResults = Database.convertLead(leadConverts);
      
//       for (Database.LeadConvertResult result : convertResults) {
//         if (result.isSuccess()) {
//           Id convertedContactId = result.getContactId();
//           contactIds.add(convertedContactId);
//         }
//       }
//     }
//   }

//   public void finish(Database.BatchableContext bc) {
//     List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
//     EmailTemplate et = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName= 'ConvertLeads'];

//     for (Contact c : [SELECT Id, Name, Email FROM Contact WHERE Id IN :contactIds AND Email != null]){
      
//       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
//       email.setTemplateId(et.Id);
//       email.setTargetObjectId(c.Id);
//       email.setSubject('This lead was converted!');
//       email.setToAddresses(new List<String>{c.Email});
//       email.setPlainTextBody('\n' + 'Thanks for choosing us as a partner.');
//       emailMessages.add(email);

//     }

//     if (emailMessages.size()>0) {
//       if(!Test.isRunningTest()){
//           Messaging.sendEmail(emailMessages);
//       }
//     }
//   }

//   public void execute(SchedulableContext sc){
//     if(!Test.isRunningTest()){
//       Database.executeBatch(new ConvertLeadSendEmailBatch(), 10);
//     }
//   }
// }