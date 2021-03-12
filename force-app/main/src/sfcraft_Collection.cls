public with sharing class sfcraft_Collection {
    private List<SObject> sobjectList;
    private Map<Id, SObject> sobjectMap;
    private SObjectType sobjType;

    public static sfcraft_Collection fromList(List<SObject> sobjectList) {
        return new sfcraft_Collection(sobjectList, sobjectList.getSObjectType());
    }

    public static sfcraft_Collection fromMap(Map<Id, SObject> sobjectMap){
		return new sfcraft_Collection(sobjectMap, sobjectMap.getSObjectType());
	} 

    private sfcraft_Collection(List<SObject> sobjectList, SObjectType sobjType) {
        this.sobjType = sobjType;
        this.sobjectList = sobjectList;

        this.sobjectMap = this.getEmptyMapOfSObjectType(sobjType);
        this.sobjectMap.putAll(sobjectList);
    }

    private sfcraft_Collection(Map<Id, SObject> sobjectMap, SObjectType sobjType) {
        this.sobjType = sobjType;
        this.sobjectMap = sobjectMap;

        this.sobjectList = getEmptyListOfSObjectType(sobjType);
        this.sobjectList.addAll(sobjectMap.values());
    }

    public List<SObject> getList() {
        return this.sobjectList;
    }

	public Map<Id, SObject> getMap() {
        return this.sobjectMap;
	} 

	// public Map<String, SObject> mapByFieldUnique(String fieldName) {
    //     return getEmptyListOfSObjectType(this.sobjType);
	// }

    private Map<Id, SObject> getEmptyMapOfSObjectType(SObjectType sobjType) {
        String mapType = 'Map<Id, ' + sobjType + '>';
        return (Map<Id, SObject>)Type.forName(mapType).newInstance();
    }

    private List<SObject> getEmptyListOfSObjectType(SObjectType sobjType) {
        String listType = 'List<' + sobjType + '>';
        return (List<SObject>)Type.forName(listType).newInstance();
    }
}
