/************************************************************************************************************
* @description : AccountTriggerHandler
* @author      : Bootcamp A.E.Z
* @date        : 2023-08-07
* **********************************************************************************************************/
public class AccountTriggerHandler {
	/************************************************************************************************************
	* @description : AccountTriggerHandler:onBeforeUpdate
	* @author      : Bootcamp A.E.Z
	* @date        : 2023-08-07
	* **********************************************************************************************************/
	public static void onBeforeUpdate(List<Account> accountNewList,Map<Id, Account> oldAccMap){
		contactMailingAccountShippingSync(accountNewList);
	}

	/************************************************************************************************************
	* @description : AccountTriggerHandler:onBeforeUpdate:contactMailingAccountShippingSync
	* @author      : Bootcamp A.E.Z
	* @date        : 2023-08-09
	* **********************************************************************************************************/
	public static void contactMailingAccountShippingSync(List<Account> accountNewList) {
		Map<Id, Account> accountMap = new Map<Id, Account>();
		for (Account acc : accountNewList) {
			if (acc.ShippingStreet != null || acc.ShippingCity != null || acc.ShippingState != null || acc.ShippingPostalCode != null || acc.ShippingCountry != null) {
				accountMap.put(acc.Id, acc);
			}
		}
		if (!accountMap.isEmpty()) {
			// Fetch related contacts to sync mailing address by account shipping address
			List<Contact> contactsToUpdate = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountMap.keySet()];
			for (Contact con : contactsToUpdate) {
				Account relatedAccount = accountMap.get(con.AccountId);
				if (relatedAccount != null) {
					con.MailingStreet = relatedAccount.ShippingStreet;
					con.MailingCity = relatedAccount.ShippingCity;
					con.MailingState = relatedAccount.ShippingState;
					con.MailingPostalCode = relatedAccount.ShippingPostalCode;
					con.MailingCountry = relatedAccount.ShippingCountry;
				}
			}
			if(!contactsToUpdate.isEmpty()){
				update contactsToUpdate;
			}
		}
	}
}
