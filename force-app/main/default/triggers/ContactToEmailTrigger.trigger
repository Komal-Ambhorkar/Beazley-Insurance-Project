trigger ContactToEmailTrigger on Contact(After Insert){
 List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
    if(trigger.isAfter && trigger.isInsert){
        for(Contact objCon: trigger.new){
            if(objCon.Email!=null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new String[] {objCon.Email});
                    mail.setSenderDisplayName('Beazley Limited');
                    mail.setSubject('Your New Contact Has Been Created');
                    mail.setPlainTextBody('Hello '+objCon.FirstName+'\n'+'Your Contact Record has Been Created...!!! \n Team Beazley Limited');
                    mailList.add(mail);
            }
            if(!mailList.isEmpty()){
            Messaging.sendEmail(mailList,false);
        }
    }
}
}