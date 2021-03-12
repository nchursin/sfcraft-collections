public with sharing class sfcraft_Collection {
    private enum CollectionType {
        CollectionList,
        CollectionMap
    }

    private Map<Schema.DisplayType, Type> displayTypeToType = new Map<Schema.DisplayType, Type>{
        Schema.DisplayType.address => String.class,
        Schema.DisplayType.anytype => String.class,
        Schema.DisplayType.base64 => String.class,
        Schema.DisplayType.Boolean => Boolean.class,
        Schema.DisplayType.Combobox => String.class,
        Schema.DisplayType.Currency => Decimal.class,
        Schema.DisplayType.DataCategoryGroupReference => String.class,
        Schema.DisplayType.Date => Date.class,
        Schema.DisplayType.DateTime => Datetime.class,
        Schema.DisplayType.Double => Decimal.class,
        Schema.DisplayType.Email => String.class,
        Schema.DisplayType.EncryptedString => String.class,
        Schema.DisplayType.ID => Id.class,
        Schema.DisplayType.Integer => Integer.class,
        Schema.DisplayType.Long => Long.class,
        Schema.DisplayType.MultiPicklist => String.class,
        Schema.DisplayType.Percent => Decimal.class,
        Schema.DisplayType.Phone => String.class,
        Schema.DisplayType.Picklist => String.class,
        Schema.DisplayType.Reference => Id.class,
        Schema.DisplayType.String => String.class,
        Schema.DisplayType.TextArea => String.class,
        Schema.DisplayType.Time => Time.class,
        Schema.DisplayType.URL => Url.class
    };

    private List<SObject> sobjectList;
    private Map<Id, SObject> sobjectMap;
    private SObjectType sobjType;
    private String sobjTypeName {
        get {
            if (null == this.sobjType) {
                return 'sObject';
            }
            return String.valueOf(this.sobjType);
        }
    }

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
        this.sobjectList = this.createEmptySObjectList();
        this.sobjectList.addAll(sobjectList);

        this.sobjectMap = this.createEmptyIdSObjectMap();
        this.sobjectMap.putAll(sobjectList);
    }

    private sfcraft_Collection(Map<Id, SObject> sobjectMap, SObjectType sobjType) {
        this(sobjType);
        this.sobjectMap = this.createEmptyIdSObjectMap();
        this.sobjectMap.putAll(sobjectMap);

        this.sobjectList = this.createEmptySObjectList();
        this.sobjectList.addAll(sobjectMap.values());
    }

    public List<SObject> getList() {
        return this.sobjectList;
    }

    public Map<Id, SObject> getMap() {
        return this.sobjectMap;
    }

    public Integer size() {
        return this.sobjectList.size();
    }

    public Integer countUnique() {
        return new Set<SObject>(this.sobjectList).size();
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
            this.sobjTypeName +
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

    public List<Object> getFieldValues(String fieldName) {
        this.argumentRequired('Field is required to gather values', fieldName);
        Type fieldType = this.getFieldType(fieldName);
        List<Object> fieldValues = createEmptyListOf(fieldType);
        populateListWithFieldsValues(fieldValues, fieldName);
        return fieldValues;
    }

    public List<Object> getFieldValues(SObjectField field) {
        this.argumentRequired('Field is required to gather values', field);
        Type fieldType = this.getFieldType(field);
        List<Object> fieldValues = createEmptyListOf(fieldType);
        populateListWithFieldsValues(fieldValues, field.getDescribe().getName());
        return fieldValues;
    }

    private void populateListWithFieldsValues(List<Object> listToPopulate, String fieldName) {
        for (SObject record : this.sobjectList) {
            listToPopulate.add(record.get(fieldName));
        }
    }

    private Type getFieldType(String fieldName) {
        Type fieldType;
        if (null == this.sobjType) {
            fieldType = Object.class;
        } else {
            SObjectField field = this.sobjType.getDescribe().fields.getMap().get(fieldName);
            fieldType = getFieldType(field);
        }
        return fieldType;
    }

    private Type getFieldType(SObjectField field) {
        return this.getTypeByDisplayType(field.getDescribe().getType());
    }

    private Type getTypeByDisplayType(Schema.DisplayType displayType) {
        return displayTypeToType.get(displayType);
    }

    private Object getOrPopulateDefault(Map<Object, Object> mapToSearch, Object key, Object defaultValue) {
        if (!mapToSearch.containsKey(key)) {
            mapToSearch.put(key, defaultValue);
        }
        return mapToSearch.get(key);
    }

    private Map<Id, SObject> createEmptyIdSObjectMap() {
        String mapType = 'Map<Id, ' + this.sobjTypeName + '>';
        return (Map<Id, SObject>) Type.forName(mapType).newInstance();
    }

    private List<SObject> createEmptySObjectList() {
        String listType = 'List<' + this.sobjTypeName + '>';
        return (List<SObject>) Type.forName(listType).newInstance();
    }

    private List<Object> createEmptyListOf(Type listObjectType) {
        String listType = 'List<' + listObjectType + '>';
        return (List<Object>) Type.forName(listType).newInstance();
    }

    private Map<Object, SObject> createEmptySObjectMapWithObjectKeys() {
        return (Map<Object, SObject>) createMapObjectTo(this.sobjTypeName);
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
