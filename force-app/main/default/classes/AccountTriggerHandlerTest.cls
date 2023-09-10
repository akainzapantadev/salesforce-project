/************************************************************************************************************
* @description : AccountTriggerHandlerTest
* @author      : Bootcamp A.E.Z
* @date        : 2023-08-09
* **********************************************************************************************************/
@isTest
public with sharing class AccountTriggerHandlerTest {
	/************************************************************************************************************
	* @description : contactMailingAccountShippingSyncTest
	* @author      : Bootcamp A.E.Z
	* @date        : 2023-08-09
	* **********************************************************************************************************/
	@isTest
	static void contactMailingAccountShippingSyncTest() {
		// Create a new Account
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		// Create a new Contacts related to the Account
		List<Contact> testContacts = new List<Contact>{
			new Contact(FirstName = 'AKAIN', LastName = 'DEV', AccountId = testAccount.Id),
			new Contact(FirstName = 'AKAIN1', LastName = 'DEV', AccountId = testAccount.Id),
			new Contact(FirstName = 'AKAIN2', LastName = 'DEV', AccountId = testAccount.Id)
		};
		insert testContacts;
		// Update the Account's shipping address
		testAccount.ShippingStreet = 'street';
		testAccount.ShippingCity = 'city';
		testAccount.ShippingState = 'QC';
		testAccount.ShippingPostalCode = '1111';
		testAccount.ShippingCountry = 'PH';
		update testAccount;
		
		// Reload the Contacts to check if mailing address is synced
		List<Contact> updatedContacts = [
			SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
			FROM Contact WHERE AccountId = :testAccount.Id
		];
		// Check if mailing address is synced with shipping address for each contact
		for (Contact contact : updatedContacts) {
			System.assertEquals(testAccount.ShippingStreet, contact.MailingStreet);
			System.assertEquals(testAccount.ShippingCity, contact.MailingCity);
			System.assertEquals(testAccount.ShippingState, contact.MailingState);
			System.assertEquals(testAccount.ShippingPostalCode, contact.MailingPostalCode);
			System.assertEquals(testAccount.ShippingCountry, contact.MailingCountry);
		}
	}
}
