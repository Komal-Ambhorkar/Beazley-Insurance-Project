
import { LightningElement, track, api, wire } from 'lwc';
import getCaseStatus from '@salesforce/apex/CaseStatusRecord.getCaseStatus';
import escalateCase from '@salesforce/apex/CaseStatusRecord.escalateCase';
import reopenCase from '@salesforce/apex/CaseStatusRecord.reopenCase';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LWCCaseButtonCompo extends LightningElement {
    @api recordId; 
    @track showEscalateButton = false;
    @track showReopenButton = false;
    @track showTextArea = false;
    @track escalationReason = '';
    

    @wire(getCaseStatus, { caseId: '$recordId' })
    wiredCaseStatus({ error, data }) {
        if (data == 'Escalated') {
            this.showReopenButton = true;
        }
        else if (data == 'New' ||data == 'In Progress' ) {
            this.showEscalateButton = true;
            this.showTextArea = true;
        }
    }
        

    handleTextareaChange(event) {
        this.escalationReason = event.target.value;
    }
    /*handleEscalateClick(event) {

        escalateCase({ caseId: this.recordId, reason: this.escalationReason })
            .then(() => {
                window.location.reload();
                    this.dispatchEvent(
                            new ShowToastEvent({
                                message: 'Case Status has been escalated',
                            })
                    )

                this.showEscalateButton = false;
                this.showReopenButton = true;
                this.showTextArea = false;
                this.escalationReason = '';
            })
            .catch(error => {
                console.error('Error escalating Case', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Error escalating Case',
                    })
            )
            });
    }

    handleReopenClick() {
        
        reopenCase({ caseId: this.recordId })
            .then(() => {
                window.location.reload();
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Case Status Has Been New',
                    })
            )
                this.showEscalateButton = true;
                this.showReopenButton = false;
                this.showTextArea = true;
                this.escalationReason = '';
            })
            .catch(error => {
                console.error('Error reopening Case', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: 'Error reopening Case',
                    })
            )
            });
    }*/
}