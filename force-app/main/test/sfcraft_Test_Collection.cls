@isTest
private with sharing class sfcraft_Test_Collection {
    private static sfcraft_Collection collectionUnderTest;
    // DONE: Map by field (string)
    // DONE: Map by field unique (string)
    // TODO: Map by field (sobjectField)
    // TODO: Map by field unique (sobjectField)
    // TODO: Map by field unique (null) - illegal argument exception
    // TODO: Count unique
    // TODO: Total size
    // TODO: From set
    // DONE: from list
    // DONE: from map
    // TODO: To set
    // DONE: to list
    // DONE: to map
    // TODO: Get set of field values
    // TODO: Generic type (SObject without concrete type)
    // TODO: Empty collection
    // TODO: add
    // TODO: remove
    // TODO: addAll(List)
    // TODO: putAll(Map)
    // TODO: throw exception if toMap but not all entities have ids
    // TODO: bypass checks throw exception if toMap but not all entities have ids
    // TODO: addAll(sfcraft_Collection)
    // TODO: putAll(sfcraft_Collection)
    // TODO: bypass checks putAll(sfcraft_Collection) throw exception if not all elements have ids
    // TODO: getSobjectType
    // TODO: removeAll

    private static List<Account> collectionList = new List<Account>{
        new Account(Id = '001000000000001', Name = 'acc1', NumberOfEmployees = 1000),
        new Account(Id = '001000000000002', Name = 'acc2', NumberOfEmployees = 1000)
    };
    private static Map<Id, Account> collectionMap = new Map<Id, Account>(collectionList);

    static {
        collectionUnderTest = sfcraft_Collection.fromList(collectionList);
    }

    @IsTest
    private static void canCreateCollectionFromList() {
        collectionUnderTest = sfcraft_Collection.fromList(collectionList);
        List<Account> actualList = (List<Account>) collectionUnderTest.getList();
        System.assertEquals(collectionList, actualList, 'Generated list is different from expected');
    }

    @IsTest
    private static void canCreateCollectionFromMap() {
        collectionUnderTest = sfcraft_Collection.fromMap(collectionMap);
        Map<Id, Account> actualMap = (Map<Id, Account>) collectionUnderTest.getMap();
        System.assertEquals(collectionMap, actualMap, 'Generated list is different from expected');
    }

    @IsTest
    private static void canCreateCollectionFromListToMap() {
        collectionUnderTest = sfcraft_Collection.fromList(collectionList);
        Map<Id, Account> actualMap = (Map<Id, Account>) collectionUnderTest.getMap();
        System.assertEquals(collectionMap, actualMap, 'Generated list is different from expected');
    }

    @IsTest
    private static void canCreateCollectionFromMapToList() {
        collectionUnderTest = sfcraft_Collection.fromMap(new Map<Id, Account>(collectionList));
        List<Account> actualMap = (List<Account>) collectionUnderTest.getList();
        System.assertEquals(collectionList, actualMap, 'Generated list is different from expected');
    }

    @IsTest
    private static void canMapByFieldUniqueName() {
        Map<Object, Account> mappedByName = (Map<Object, Account>) collectionUnderTest.mapByFieldUnique('Name');
        System.assertEquals(collectionList.size(), mappedByName.size(), 'Result size is different from expected');
        for (Account acc : collectionList) {
            System.assertEquals(acc, mappedByName.get(acc.Name), 'Wrong account mapped for name: ' + acc.Name);
        }
    }

    @IsTest
    private static void canMapByFieldUnique() {
        Map<Object, Account> mappedByName = (Map<Object, Account>) collectionUnderTest.mapByFieldUnique(Account.Name);
        System.assertEquals(collectionList.size(), mappedByName.size(), 'Result size is different from expected');
        for (Account acc : collectionList) {
            System.assertEquals(acc, mappedByName.get(acc.Name), 'Wrong account mapped for name: ' + acc.Name);
        }
    }

    @IsTest
    private static void canMapByFieldName() {
        Map<Object, List<Account>> mappedByNumber = (Map<Object, List<Account>>) collectionUnderTest.mapByField(
            'NumberOfEmployees'
        );
        System.assertEquals(1, mappedByNumber.size(), 'Result size is different from expected');
        System.assertEquals(collectionList, mappedByNumber.get(1000), 'Wrong mapping for numbers');
    }

    @IsTest
    private static void canMapByField() {
        Map<Object, List<Account>> mappedByNumber = (Map<Object, List<Account>>) collectionUnderTest.mapByField(
            Account.NumberOfEmployees
        );
        System.assertEquals(1, mappedByNumber.size(), 'Result size is different from expected');
        System.assertEquals(collectionList, mappedByNumber.get(1000), 'Wrong mapping for numbers');
    }
}
