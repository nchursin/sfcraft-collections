@isTest
private with sharing class sfcraft_Test_Collection {
    private static sfcraft_Collection collectionUnderTest;
    // DONE: Map by field (string)
    // DONE: Map by field unique (string)
    // DONE: Map by field (sobjectField)
    // DONE: Map by field unique (sobjectField)
    // DONE: Map by field unique (null) - illegal argument exception
    // DONE: Total size
    // DONE: Count unique
    // TODO: From set
    // DONE: from list
    // DONE: from map
    // DONE: from list(null) throw IAE
    // DONE: from map(null) throw IAE
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

    private static List<Account> collectionList;
    private static Map<Id, Account> collectionMap;

    static {
        collectionList = new List<Account>{
            new Account(Id = '001000000000001', Name = 'acc1', NumberOfEmployees = 1000),
            new Account(Id = '001000000000002', Name = 'acc2', NumberOfEmployees = 1000)
        };
        collectionMap = new Map<Id, Account>(collectionList);
        collectionUnderTest = sfcraft_Collection.fromList(collectionList);
    }

    @IsTest
    private static void canCreateCollectionFromList() {
        collectionUnderTest = sfcraft_Collection.fromList(collectionList);
        List<Account> actualList = (List<Account>) collectionUnderTest.getList();
        System.assertEquals(collectionList, actualList, 'Generated list is different from expected');
    }

    @IsTest
    private static void calculatesSize() {
        collectionUnderTest = sfcraft_Collection.fromList(collectionList);
        System.assertEquals(collectionList.size(), collectionUnderTest.size(), 'Size is different from expected');
    }

    @IsTest
    private static void collectionHasItsOwnInstancesOfList() {
        List<Account> accList = new List<Account>{ collectionList.get(0) };
        Integer expectedSize = accList.size();
        collectionUnderTest = sfcraft_Collection.fromList(accList);
        accList.add(accList.get(0));
        System.assertEquals(expectedSize, collectionUnderTest.size(), 'Collection is changed');
        System.assertNotEquals(accList, collectionUnderTest.getList(), 'Collection is changed');
    }

    @IsTest
    private static void collectionHasItsOwnInstancesOfMap() {
        Map<Id, Account> accMap = new Map<Id, Account>{ collectionList.get(0).Id => collectionList.get(0) };
        Integer expectedSize = accMap.size();
        collectionUnderTest = sfcraft_Collection.fromMap(accMap);
        accMap.put(collectionList.get(1).Id, collectionList.get(1));
        System.assertEquals(expectedSize, collectionUnderTest.size(), 'Collection is changed');
        System.assertNotEquals(accMap, collectionUnderTest.getMap(), 'Collection is changed');
    }

    @IsTest
    private static void canCountUnique() {
        collectionList.add(collectionList[0]);
        collectionUnderTest = sfcraft_Collection.fromList(collectionList);
        System.assertEquals(
            collectionList.size() - 1,
            collectionUnderTest.countUnique(),
            'Unique count is different from expected'
        );
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

    @IsTest
    private static void mapByFieldMethodsThrowIllegalArgumentException() {
        String fieldName = null;
        SObjectField field = null;
        try {
            collectionUnderTest.mapByField(fieldName);
            expectException(IllegalArgumentException.class);
        } catch (IllegalArgumentException ex) {
            expectException('Field is required to map', ex);
        }
        try {
            collectionUnderTest.mapByField(field);
            expectException(IllegalArgumentException.class);
        } catch (IllegalArgumentException ex) {
            expectException('Field is required to map', ex);
        }
        try {
            collectionUnderTest.mapByFieldUnique(fieldName);
            expectException(IllegalArgumentException.class);
        } catch (IllegalArgumentException ex) {
            expectException('Field is required to map', ex);
        }
        try {
            collectionUnderTest.mapByFieldUnique(field);
            expectException(IllegalArgumentException.class);
        } catch (IllegalArgumentException ex) {
            expectException('Field is required to map', ex);
        }
    }

    private static void expectException(Type exceptionType) {
        System.assert(false, exceptionType.getName() + ' expected');
    }

    private static void expectException(String message, Exception ex) {
        System.assertEquals(message, ex.getMessage(), 'Exception message is different from expected');
    }
}
