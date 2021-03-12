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

        this.sobjectMap = this.createEmptyMap();
        this.sobjectMap.putAll(sobjectList);
    }

    private sfcraft_Collection(Map<Id, SObject> sobjectMap, SObjectType sobjType) {
        this(sobjType);
        this.sobjectMap = sobjectMap;

        this.sobjectList = this.createEmptyList();
        this.sobjectList.addAll(sobjectMap.values());
    }

    public List<SObject> getList() {
        return this.sobjectList;
    }

	public Map<Id, SObject> getMap() {
        return this.sobjectMap;
	} 

	// public Map<String, SObject> mapByFieldUnique(String fieldName) {
    //     return this.createEmptyMap();
	// }

    private Map<Id, SObject> createEmptyMap() {
        String mapType = 'Map<Id, ' + this.sobjType + '>';
        return (Map<Id, SObject>)Type.forName(mapType).newInstance();
    }

    private List<SObject> createEmptyList() {
        String listType = 'List<' + this.sobjType + '>';
        return (List<SObject>)Type.forName(listType).newInstance();
    }
}
