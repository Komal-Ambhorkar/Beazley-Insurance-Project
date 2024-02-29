import { LightningElement,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import sendTemplateMessage from '@salesforce/apex/WhatsappIntegrationController.sendTemplateMessage';
export default class WhatsappIntegrationTemplate extends LightningElement {
@api recordId

onSendTemplate(){
    sendTemplateMessage({contactId: this.recordId})
    .then(result=>{
        const toastEvent = new ShowToastEvent({
            title : "Success",
            message : "Message sent to contact successfully",
            variant : "success",
        });
        dispatchEvent(toastEvent);
    })
    .catch(error =>{
        const toastEvent = new ShowToastEvent({
            title : "Error",
            message : "Message failed",
            variant : "error",
        });
        dispatchEvent(toastEvent);
    })
}
}