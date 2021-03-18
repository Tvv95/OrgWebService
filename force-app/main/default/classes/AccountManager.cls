@RestResource(urlMapping='/Accounts/*')
global with sharing class AccountManager {

    @HttpGet
    global static Account getAccById() {
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Name, Site FROM Account WHERE Id = :accId];
        return result;
    }

    @HttpPost
    global static ID createAcc(String name, String site) {
        Account newAcc = new Account (Name=name, Site=site);
        insert newAcc;
        return newAcc.id;
    }

    @HttpDelete
    global static void deleteAcc() {
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account accToDelete = [SELECT Id FROM Account WHERE Id = :accId];
        delete accToDelete;
    }

    @HttpPut
    global static ID upsertAcc(String name, String site, String id) {
        Account upsertAcc = new Account (Id=id, Name=name, Site=site);
        upsert upsertAcc;
        return upsertAcc.id;
    }

    @HttpPatch
    global static ID updateAcc() {
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account accToUpdate = [SELECT Id FROM Account WHERE Id = :accId];
        Map<String, Object> mapToUpdate = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        for(String field : mapToUpdate.keySet()) {
            accToUpdate.put(field, mapToUpdate.get(field));
        }
        update accToUpdate;
        return accToUpdate.Id;
    }
}
