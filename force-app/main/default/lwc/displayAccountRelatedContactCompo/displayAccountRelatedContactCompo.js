import { LightningElement, track } from 'lwc';
import getAccountsAndContacts from '@salesforce/apex/AccountController.getAccountsAndContacts';

export default class DisplayAccountRelatedContactCompo extends LightningElement {
    @track accountList;
    @track TotalRecords = 0;

    accountColumns = [
        { label: 'Account Name', fieldName: 'Name', type: 'text' },
        { label: 'Contact Name', fieldName: 'contactName', type: 'text' }
    ];

    searchAccountsHandler() {
        console.log('You clicked the button');

        getAccountsAndContacts()
            .then(result => {
                    console.log('success');
                    this.accountList = result.map(account => ({
                    Id: account.Id,
                    Name: account.Name,
                    contactName: account.Contacts ? account.Contacts.map(contact => contact.Name).join(', ') : ''
                }));

                if (result.length > 0) {
                    this.TotalRecords = result.length;
                } else {
                    this.TotalRecords = 0;
                }
            })
            .catch(error => {
                console.log('error');
                this.accountList = null;
                this.TotalRecords = 0;
            });
    }
}