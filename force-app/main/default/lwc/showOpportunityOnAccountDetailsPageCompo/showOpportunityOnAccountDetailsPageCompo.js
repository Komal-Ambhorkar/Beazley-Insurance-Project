import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';


export default class ShowOpportunityOnAccountDetailsPageCompo extends LightningElement {

  @api  recordId;
    error;
    records;
    @wire(getRelatedListRecords, {
      parentRecordId: '0015h00001cgDpOAAU',
      relatedListId: 'Contacts',
      fields: ['Contact.Id', 'Contact.Name'],
      where: '{ Name: { like: "Bob%" }}',
    })
    listInfo({ error, data }) {
      if (data) {
        this.records = data.records;
        this.error = undefined;
      } else if (error) {
        this.error = error;
        this.records = undefined;
      }
    }
  }