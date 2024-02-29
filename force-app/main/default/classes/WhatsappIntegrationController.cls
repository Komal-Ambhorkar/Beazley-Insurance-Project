public with sharing class WhatsappIntegrationController {
    @AuraEnabled
    public static string sendTemplateMessage(string contactId){
        try {
            Contact contactDetail = [SELECT Id, Phone FROM Contact WHERE Id = :contactId LIMIT 1];

            String whatsappNumber = '';

            if (contactDetail != null && contactDetail.Phone != null) {
                whatsappNumber = '91' + contactDetail.Phone;
            } else { 
                System.debug('Contact or phone number is null');
                return null;
            }
           
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://graph.facebook.com/v18.0/221962400999001/messages');
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('POST');
            request.setBody('{ \"messaging_product\": \"whatsapp\", \"to\": \"+whatsappNumber\", \"type\": \"template\", \"template\": { \"name\": \"hello_world\", \"language\": { \"code\": \"en_US\" } } }');
            string apiToken = 'EAAMvuo1YP0kBO9Vhn9IFhlSFcc8brbNXZBTxmQ7EsNpMYwfZA6mzBkia5XONAWb1ZCcUKbZBLgMWaevJuY4MC2jLZCwFx7N7uZAUqM3R0XNJpCrusMHPfDyTgLVaE6hX3MGXwuyXZAuzpPKZBjLyG3G4NpbwNthelvJQmgGC9zlzm4RZBit2m1ikH2PqQnJL4Anqo7n49OGIwNxJusTGec9oZD';
            request.setHeader('Authorization','Bearer '+apiToken);
            HttpResponse response = http.send(request);
            System.debug('Response Status Code = '+response.getStatusCode()); 
            System.debug('Received Data = '+response.getBody()); 
            
        return response.getBody();
        } 
        catch (Exception e) {
            return null;
        }
    }
}