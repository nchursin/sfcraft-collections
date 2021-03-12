public with sharing class sfcraft_Collection {
    private enum CollectionType {
        CollectionList, CollectionMap
    }

    private List<SObject> sobjectList;
    private Map<Id, SObject> sobjectMap;
    private SObjectType sobjType;

    public static sfcraft_Collection fromList(List<SObject> sobjectList) {
        return new sfcraft_Collection(sobjectList, sobjectList.getSObjectType());
    }

    public static sfcraft_Collection fromMap(Map<Id, SObject> sobjectMap){
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
        Map<Object, SObject> result = this.createEmptySObjectMapWithObjectKeys();
        for (SObject record : this.sobjectList) {
            Object fieldValue = record.get(fieldName);
            result.put(fieldValue, record);
        }
        return result;
	}

	public Map<Object, List<SObject>> mapByField(String fieldName){
        String mapType = 'Map<Object, List<' + this.sobjType + '>>';
        Map<Object, List<SObject>> result = (Map<Object, List<SObject>>) Type.forName(mapType).newInstance();
        for (SObject record : this.sobjectList) {
            Object fieldValue = record.get(fieldName);
            if (!result.containsKey(fieldValue)) {
                result.put(fieldValue, this.createEmptySObjectList());
            }
            result.get(fieldValue).add(record);
        }
        return result;
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
        String mapType = 'Map<Object, ' + this.sobjType + '>';
        return (Map<Object, SObject>) Type.forName(mapType).newInstance();
    }
}
