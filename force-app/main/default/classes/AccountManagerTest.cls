@isTest
private class AccountManagerTest {
    @isTest static void testGetAccById() {
        Id accId = createTestAcc();
        RestRequest request = new RestRequest();
        request.requestUri = 'https://resourceful-wolf-st5svy-dev-ed.salesforce.com/services/apexrest/Accounts/' + accId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        Account takenAcc = AccountManager.getAccById();
        System.assertEquals('Test Name', takenAcc.Name);
    }

    @isTest static void testCreateAcc() {
        Id accId = AccountManager.createAcc('Test Name', 'Test Site');
        Account createdAcc = [SELECT Id, Name FROM Account WHERE Id = :accId];
        System.assertEquals('Test Name', createdAcc.Name);
    }

    @isTest static void testDeleteAcc() {
        Id accId = createTestAcc();
        RestRequest request = new RestRequest();
        request.requestUri = 'https://resourceful-wolf-st5svy-dev-ed.salesforce.com/services/apexrest/Accounts/' + accId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        AccountManager.deleteAcc();
        List<Account> accs = [SELECT Id FROM Account WHERE Id = :accId];
        System.assertEquals(0, accs.size());
    }

    @isTest static void testUpsertAcc() {
        Id accId = AccountManager.createAcc('Test Name', 'Test Site');
        Account oldAcc = [SELECT Id, Name FROM Account WHERE Id=:accId];
        System.assertEquals('Test Name', oldAcc.Name);
        Id newAccId = AccountManager.upsertAcc('New Name', 'New Site', accId);
        System.assertEquals(accId, newAccId);
        Account newAcc = [SELECT Id, Name FROM Account WHERE Id=:newAccId];
        System.assertEquals('New Name', newAcc.Name);
    }

    @isTest static void testUpdateAcc() {
        Id accId = createTestAcc();
        RestRequest request = new RestRequest();
        request.requestUri = 'https://resourceful-wolf-st5svy-dev-ed.salesforce.com/services/apexrest/Accounts/' + accId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Name": "Updated Name"}');
        RestContext.request = request;
        Id updatedAccId = AccountManager.updateAcc();
        Account updatedAcc = [SELECT Id, Name From Account WHERE Id = :updatedAccId];
        System.assertEquals('Updated Name', updatedAcc.Name);
    }

    static Id createTestAcc() {
        Account testAcc = new Account(Name='Test Name', Site='Test Site');
        insert testAcc;
        return testAcc.Id;
    }
}
