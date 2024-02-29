import { LightningElement, wire } from 'lwc';
import fetchContacts from '@salesforce/apex/ContactController.fetchContacts';

const columns = [
    { label: 'Contact Name', fieldName: 'Name' },
    { label: 'Account Name', fieldName: 'AccName' }
];

export default class AccountContactDetailsCompoDemo extends LightningElement {

    records;
    error;
    columns = columns;
    draftValues = [];

    @wire( fetchContacts )  
    wiredAccount( value ) {

        const { data, error } = value;

        if ( data ) {
            
            let tempRecords = JSON.parse( JSON.stringify( data ) );
            tempRecords = tempRecords.map( row => {
                return { ...row, Name: row.Name, AccName: ( row.Account ? row.Account.Name : null ) };
            })
            this.records = tempRecords;
            this.error = undefined;

        } else if ( error ) {

            this.error = error;
            this.records = undefined;

        }

    }  

}
