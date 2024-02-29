import { LightningElement, track } from 'lwc';
import sendEmail from '@salesforce/apex/ApplicantOTPProvider.sendEmail';
import updateApplicantDetails from '@salesforce/apex/ApplicantOTPProvider.updateApplicantDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Label from '@salesforce/label/c.OTPTimer'; // use custom label in admin and c is used becoz its custom label


export default class CreateApplicantFormCompo extends LightningElement {

    
    @track isButtonDisabled = false;
    @track verifyEmail;
    @track errorMessage;
    @track enteredValue= '';
    @track showOtpMessage;
    @track showOTPsucessfullyMessage;
    @track objApplicant = {'sobjecttype' : 'Applicant__c'};
    @track minutes;
    @track seconds;
    @track emailToVerify;
    @track showFailEmail;
	@track apiUrl;


   emailHandler(event){
    this.objApplicant.Email_Id__c = event.target.value;
    console.log(this.objApplicant.Email_Id__c);
   }

initializeTimeLeft(timeFormat) {
    const [minutes, seconds] = timeFormat.split(':');
    this.minutes = parseInt(minutes) || 0;
    this.seconds = parseInt(seconds) || 0;
}

generateOTPHandler(event) {
    if (this.objApplicant.Email_Id__c.trim() !== '') {
        this.isButtonDisabled = true;
        console.log('button is clicked!!!!!');
        
        // Validate Email Id format and call Apex method to generate OTP
        this.emailToVerify = this.objApplicant.Email_Id__c;
        this.apiUrl = 'https://emailvalidation.abstractapi.com/v1/?api_key=9c5a0f08399646d2b6f87bc522656485&email=' + this.emailToVerify;

        console.log(+this.apiUrl);
        fetch(this.apiUrl, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            },
        })
        .then(response => { 
            console.log('Raw Response:', response);

            if (response.ok) {
                return response.json()
            //.catch(() => response.text());
            } else {
                console.error('Network response was not ok:', response.status);
                throw new Error('Network response was not ok: ' + response.status);
            }
        })
        .then(data => {
            console.log('Data received:', data);

            if (data.deliverability === 'DELIVERABLE') {
                console.log('Email is deliverable');
                this.showOtpMessage = true;
                this.showFailEmail = false;
                console.log('Sending email verification request...');
                sendEmail({ 'objApp': this.objApplicant })
                    .then(success => {
                        console.log('Email verification success:', success);
                        this.verifyEmail = success;

                        console.log('OTP on Mail =' + this.verifyEmail);

                        this.initializeTimeLeft(JSON.parse(Label).time || '00:00');

                        const decrementTime = () => {
                            if (this.minutes === 0 && this.seconds === 0) {
                                this.isButtonDisabled = false;
                            } else {
                                if (this.seconds === 0) {
                                    this.minutes--;
                                    this.seconds = 59;
                                } else {
                                    this.seconds--;
                                }
                                this.timer = setTimeout(decrementTime, 1000);
                            }
                        };

                        decrementTime();
                    })
                    .catch(error => {
                        console.error('Error during email verification:', error);
                    });
            } else {
                console.log('Email is undeliverable');
                this.showFailEmail = true;
                this.showOtpMessage = false;
                this.showEnterOTPField = false;
                this.isButtonDisabled = false;
                this.showOTPsucessfullyMessage = false;
            }
        })
        .catch(error => {
            console.error('Error during email verification:', error);
            // Provide user feedback or handle the error appropriately
        });

        this.showEnterOTPField = true;
    }
}        

    OtpHandler(event){
        this.enteredValue  = event.target.value;
            if(this.enteredValue == this.verifyEmail){
                this.showOtpMessage = false;
                this.showOTPsucessfullyMessage = true;
                this.isButtonDisabled = false;
                this.errorMessage=false;

    }
    else{ 
                this.errorMessage=true;
                this.showOTPsucessfullyMessage=false;
            
    }
  
}
handleSubmit(event){
    updateApplicantDetails({ 'objApp' : this.objApplicant })
        .then(result => {
            // alert("Data Updated Successfully");
            window.location.reload();
            this.dispatchEvent(
                new ShowToastEvent({
                    message: 'FORM HAS BEEN SUBMITTED',
                    variant: 'success'
                })  // <-- Added closing parenthesis
            );
        })
        .catch(error => {
            // alert("Some Error Occurred, Please try again later!");
        });
}
}
