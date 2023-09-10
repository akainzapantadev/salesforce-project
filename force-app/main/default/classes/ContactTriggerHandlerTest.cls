/************************************************************************************************************
* @description : ContactTriggerHandlerTest
* @author      : Bootcamp A.E.Z
* @date        : 2023-08-09
* **********************************************************************************************************/
@isTest
public with sharing class ContactTriggerHandlerTest {
	/************************************************************************************************************
	* @description : populateMailingByAccountShippingTest
	* @author      : Bootcamp A.E.Z
	* @date        : 2023-08-09
	* **********************************************************************************************************/
	@isTest
	static void populateMailingByAccountShippingTest() {
		Account testAccount = new Account(
			Name = 'Test Account',
			ShippingStreet = 'street', 
			ShippingCity = 'city', 
			ShippingState = 'QC', 
			ShippingPostalCode = '1111', 
			ShippingCountry = 'PH'
		);
		insert testAccount;

		List<Contact> testContacts = new List<Contact>{
			new Contact(FirstName = 'AKAIN', LastName = 'DEV', AccountId = testAccount.Id),
			new Contact(FirstName = 'AKAIN1', LastName = 'DEV', AccountId = testAccount.Id),
			new Contact(FirstName = 'AKAIN2', LastName = 'DEV', AccountId = testAccount.Id)
		};
		insert testContacts;

		List<Contact> checkContacts = [
			SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
			FROM Contact WHERE AccountId = :testAccount.Id
		];

		for (Contact contact : checkContacts) {
			System.assertEquals(contact.MailingStreet, testAccount.ShippingStreet);
			System.assertEquals(contact.MailingCity, testAccount.ShippingCity);
			System.assertEquals(contact.MailingState, testAccount.ShippingState);
			System.assertEquals(contact.MailingPostalCode, testAccount.ShippingPostalCode);
			System.assertEquals(contact.MailingCountry, testAccount.ShippingCountry);
		}
	}
}