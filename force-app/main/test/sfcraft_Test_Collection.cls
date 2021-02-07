@isTest
private with sharing class sfcraft_Test_Collection {
    @IsTest
    private static void testCreateCollectionFromList() {
        List<Account> expectedList = new List<Account> {
            new Account(Name = 'acc1'),
            new Account(Name = 'acc2')
        };
        sfcraft_Collection collection = new sfcraft_Collection(expectedList);
        List<Account> actualList = (List<Account>) collection.getList();
        System.assertEquals(expectedList, actualList, 'Generated list is different from expected');
    }
}
