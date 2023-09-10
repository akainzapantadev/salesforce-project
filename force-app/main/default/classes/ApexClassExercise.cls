/************************************************************************************************************
* @description : Apex Class Exercise : ApexClassExercise1
* @author      : Bootcamp A.E.Z
* @date        : 2023-08-02
* **********************************************************************************************************/

public class ApexClassExercise {
    //This method fetch related contacts from accounts and displays the result on Logs
    public static void getRelatedContactsFromAccount(){
        
        //Initial test to check if class is working
        //System.debug('test');
        
        //Query to fetch accounts with related Contacts containing 'test' in name
        //List<Account> accountQuery = [SELECT Name , (SELECT Name  FROM Contacts WHERE FirstName LIKE '%test%' OR LastName LIKE '%test%') FROM Account];
        
        //Query to fetch accounts with related Contact names
        List<Account> accountQuery = [SELECT Name , (SELECT Name  FROM Contacts) FROM Account];   
        
        //For each loop thru the account result
        for (Account acc : accountQuery) {
            //Fetch related contacts for each account
            List<Contact> relatedContacts = acc.Contacts;
            
            //For each loop and print Account name and Contact names
            for (Contact con : relatedContacts) {
                System.debug('\n' + 'Account: ' + acc.Name + '\n' + 'Contact name: ' + con.Name);
            }
        }
    }
}