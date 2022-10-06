public class PokeCards {
    @Auraenabled(cacheable=true)
    public static List<Pokemon__c> getPokemons() {
        return [
            SELECT Id, Name, Tipos__c, Altura__c, Peso__c, Generacion__c, Imagen__c, ExtId__c
            FROM Pokemon__c ORDER BY ExtId__c
        ];
    }

    @Auraenabled(cacheable=true)
    public static List<Pokemon__c> getType(String tipo) {
        if (String.isBlank(tipo)) {
            return getPokemons();
        }else {
            return [
                SELECT Id, Name, Tipos__c, Altura__c, Peso__c, Generacion__c, Imagen__c, ExtId__c
                FROM Pokemon__c
                WHERE Tipos__c INCLUDES (:tipo)
                ORDER BY ExtId__c
            ];
        }
    }

    @Auraenabled(cacheable=true)
    public static List<Pokemon__c> getGen(Integer generacion) {
        if (generacion == 0) {
            return getPokemons();
        }else {
            return [
                SELECT Id, Name, Tipos__c, Altura__c, Peso__c, Generacion__c, Imagen__c, ExtId__c
                FROM Pokemon__c
                WHERE Generacion__c = :generacion
                ORDER BY ExtId__c
            ];
        }
    }

    @Auraenabled(cacheable=true)
    public static List<Pokemon__c> searchThis(String search) {
        if (String.isBlank(search)) {
            return getPokemons();
        }else{
            search += '%';
            return [
            SELECT Name, Tipos__c, Altura__c, Peso__c, Generacion__c, Imagen__c, ExtId__c
            FROM Pokemon__c
            WHERE Name LIKE :search
            ORDER BY ExtId__c
            ];
        }
    }
}
