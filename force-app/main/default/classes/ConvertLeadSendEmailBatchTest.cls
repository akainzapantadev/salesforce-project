@isTest
private class ConvertLeadSendEmailBatchTest {

  @isTest
  static void testBatchExecution() {
    List<Lead> leads = new List<Lead>();
    for (Integer i = 0; i < 10; i++) {
      leads.add(new Lead(LastName = 'Test Lead ' + i, FirstName = 'asd', Status = 'Working - Contacted', Company = 'copany' + i, Email = 'test' + i + '@test.mail'));
    }
    insert leads;

    Lead customLead = new Lead(LastName = 'akain test', Company = 'akaindev', Status = 'Working - Contacted', Email = 'akainzapantadev@gmail.com');
    insert customLead;

    Test.startTest();
      Database.executeBatch(new ConvertLeadSendEmailBatch());
      // System.schedule('ConvertLeadSendEmailBatch', '0 0 1 * * ?', new ConvertLeadSendEmailBatch());
    Test.stopTest();
  }
}
