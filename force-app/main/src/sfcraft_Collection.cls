public with sharing class sfcraft_Collection {
    private List<SObject> sobjectList;

    public sfcraft_Collection(List<SObject> sobjectList) {
        this.sobjectList = sobjectList;
    }

    public List<SObject> getList() {
        return sobjectList;
    }
}
