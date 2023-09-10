/************************************************************************************************************
* @description : ContactTriggerHandler
* @author      : Bootcamp A.E.Z
* @date        : 2023-08-07
* **********************************************************************************************************/
public class ContactTriggerHandler {
	/************************************************************************************************************
	* @description : ContactTriggerHandler:onBeforeInsert
	* @author      : Bootcamp A.E.Z
	* @date        : 2023-08-07
	* **********************************************************************************************************/
	public static void onBeforeInsert(List<Contact> contactNewList){
		populateMailingByAccountShipping(contactNewList);
	}
	/************************************************************************************************************
	* @description : ContactTriggerHandler:onBeforeInsert:populateMailingByAccountShipping
	* @author      : Bootcamp A.E.Z
	* @date        : 2023-08-07
	* **********************************************************************************************************/
	public static void populateMailingByAccountShipping(List<Contact> contactNewList) {
		// Initialize Set
		Set<Id> accountIdsWithShipping = new Set<Id>();
		
		// Step 1: Collect accountIds of contact that is related to an account
		for (Contact con : contactNewList) {
			if (con.AccountId != null) {
				accountIdsWithShipping.add(con.AccountId);
			}
		}

		// Step 2: Fetch accounts with shipping address
		Map<Id, Account> accountMap = new Map<Id, Account>([
			SELECT Id, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry
			FROM Account
			WHERE Id IN :accountIdsWithShipping
			AND (ShippingStreet != null OR ShippingCity != null OR ShippingState != null OR ShippingPostalCode != null OR ShippingCountry != null)
		]);

			// Step 3: Loop through contacts and sync mailing address from related account shipping address
		for (Contact con : contactNewList) {
			Account relatedAccount = accountMap.get(con.AccountId);
			if (relatedAccount != null) {
				con.MailingStreet = relatedAccount.ShippingStreet;
				con.MailingCity = relatedAccount.ShippingCity;
				con.MailingState = relatedAccount.ShippingState;
				con.MailingPostalCode = relatedAccount.ShippingPostalCode;
				con.MailingCountry = relatedAccount.ShippingCountry;
			}
		}
	}
}
