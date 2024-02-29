public with sharing class ApplicantOTPProvider{

    @AuraEnabled
    public static Integer sendEmail(Applicant__c objApp) {
        try {
            // Generate a 6-digit random OTP
            Integer generatedOtp = (Integer)Math.round(Math.random() * 900000 + 100000);
            system.debug('##### Genreted OTP ='+generatedOtp);

        //     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //     mail.setToAddresses(new String[] { objApp.Email_Id__c }); // Assuming Email_Id__c is the field containing the email address
        //     mail.setSenderDisplayName('Beazley Limited');
        //     mail.setSubject('Welcome to Beazley Limited: Verify Email Id');
        //     mail.setPlainTextBody('Your OTP for Email Verification: ' + generatedOtp);

        //    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            return generatedOtp;
        } catch (Exception e) {
            system.debug('Exception: ' + e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static List<Applicant__c> updateApplicantDetails(Applicant__c objApp) {
        try {
            List<Applicant__c> appList = new List<Applicant__c>();
            Applicant__c insertApplicantObj = new Applicant__c(
                First_Name__c = objApp.First_Name__c,
                Last_Name__c = objApp.Last_Name__c,
                Email_Id__c = objApp.Email_Id__c,
                OTP_Verified__c = true
            );
            appList.add(insertApplicantObj);
            insert appList;
            return appList;
        } catch (Exception e) {
            system.debug('Error in updating applicant details :' + e.getMessage());
            return null;
        }
    }

}  



