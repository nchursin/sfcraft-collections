public with sharing class sfcraft_Collection {
    private enum CollectionType {
        CollectionList,
        CollectionMap
    }

    private List<SObject> sobjectList;
    private Map<Id, SObject> sobjectMap;
    private SObjectType sobjType;

    public static sfcraft_Collection fromList(List<SObject> sobjectList) {
        return new sfcraft_Collection(sobjectList, sobjectList.getSObjectType());
    }

    public static sfcraft_Collection fromMap(Map<Id, SObject> sobjectMap) {
        return new sfcraft_Collection(sobjectMap, sobjectMap.getSObjectType());
    }

    private sfcraft_Collection(SObjectType sobjType) {
        this.sobjType = sobjType;
    }

    private sfcraft_Collection(List<SObject> sobjectList, SObjectType sobjType) {
        this(sobjType);
        this.sobjectList = sobjectList;

        this.sobjectMap = this.createEmptyIdSObjectMap();
        this.sobjectMap.putAll(sobjectList);
    }

    private sfcraft_Collection(Map<Id, SObject> sobjectMap, SObjectType sobjType) {
        this(sobjType);
        this.sobjectMap = sobjectMap;

        this.sobjectList = this.createEmptySObjectList();
        this.sobjectList.addAll(sobjectMap.values());
    }

    public List<SObject> getList() {
        return this.sobjectList;
    }

    public Map<Id, SObject> getMap() {
        return this.sobjectMap;
    }

    public Map<Object, SObject> mapByFieldUnique(String fieldName) {
        this.argumentRequired('Field is required to map', fieldName);
        Map<Object, SObject> result = this.createEmptySObjectMapWithObjectKeys();
        for (SObject record : this.sobjectList) {
            Object fieldValue = record.get(fieldName);
            result.put(fieldValue, record);
        }
        return result;
    }

    public Map<Object, List<SObject>> mapByField(String fieldName) {
        this.argumentRequired('Field is required to map', fieldName);
        Map<Object, List<SObject>> result = (Map<Object, List<SObject>>) createMapObjectTo(
            'List<' +
            this.sobjType +
            '>'
        );
        for (SObject record : this.sobjectList) {
            Object fieldValue = record.get(fieldName);
            List<SObject> listToAddTo = (List<SObject>) this.getOrPopulateDefault(
                result,
                fieldValue,
                createEmptySObjectList()
            );
            listToAddTo.add(record);
        }
        return result;
    }

    public Map<Object, List<SObject>> mapByField(SObjectField field) {
        this.argumentRequired('Field is required to map', field);
        return this.mapByField(field.getDescribe().getName());
    }

    public Map<Object, SObject> mapByFieldUnique(SObjectField field) {
        this.argumentRequired('Field is required to map', field);
        return this.mapByFieldUnique(field.getDescribe().getName());
    }

    private Object getOrPopulateDefault(Map<Object, Object> mapToSearch, Object key, Object defaultValue) {
        if (!mapToSearch.containsKey(key)) {
            mapToSearch.put(key, defaultValue);
        }
        return mapToSearch.get(key);
    }

    private Map<Id, SObject> createEmptyIdSObjectMap() {
        String mapType = 'Map<Id, ' + this.sobjType + '>';
        return (Map<Id, SObject>) Type.forName(mapType).newInstance();
    }

    private List<SObject> createEmptySObjectList() {
        String listType = 'List<' + this.sobjType + '>';
        return (List<SObject>) Type.forName(listType).newInstance();
    }

    private Map<Object, SObject> createEmptySObjectMapWithObjectKeys() {
        return (Map<Object, SObject>) createMapObjectTo(String.valueOf(this.sobjType));
    }

    private Map<Object, Object> createMapObjectTo(String valueType) {
        String mapType = 'Map<Object, ' + valueType + '>';
        return (Map<Object, Object>) Type.forName(mapType).newInstance();
    }

    private void argumentRequired(String message, Object value) {
        if (null == value) {
            throw new IllegalArgumentException(message);
        }
    }
}
