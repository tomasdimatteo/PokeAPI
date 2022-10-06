@isTest(SeeAllData=true)
public with sharing class PokemonAPITest {
    @IsTest
    static void pokeAPITesting(){
        SingleRequestMock fakeResponse = new singleRequestMock(200,
        'OK',
        '{"height":7,"id":1,"name":"bulbasaur","order":1,"stats":[{"base_stat":45,"effort":0,"stat":{"name":"hp","url":"https://pokeapi.co/api/v2/stat/1/"}},{"base_stat":49,"effort":0,"stat":{"name":"attack","url":"https://pokeapi.co/api/v2/stat/2/"}},{"base_stat":49,"effort":0,"stat":{"name":"defense","url":"https://pokeapi.co/api/v2/stat/3/"}},{"base_stat":65,"effort":1,"stat":{"name":"special-attack","url":"https://pokeapi.co/api/v2/stat/4/"}},{"base_stat":65,"effort":0,"stat":{"name":"special-defense","url":"https://pokeapi.co/api/v2/stat/5/"}},{"base_stat":45,"effort":0,"stat":{"name":"speed","url":"https://pokeapi.co/api/v2/stat/6/"}}],"types":[{"slot":1,"type":{"name":"grass","url":"https://pokeapi.co/api/v2/type/12/"}},{"slot":2,"type":{"name":"poison","url":"https://pokeapi.co/api/v2/type/4/"}}],"weight":69}'
        ); 

        Test.setMock(HttpCalloutMock.class, fakeResponse);

        Test.startTest();
        List<Integer> indices = new List<Integer>();
        indices.add(1);
        database.executeBatch(new PokemonAPI());
        new PokemonAPI().execute(null, indices);
        new PokemonAPI().finish(null);
        Test.stopTest();

        Pokemon__c pokemon = [SELECT ExtId__c, Numero_de_Pokemon__c, Altura__c, Peso__c, Vida__c, Ataque__c, Defensa__c, Velocidad__c FROM Pokemon__c WHERE ExtId__c = 1 LIMIT 1];
        System.assertEquals(1, pokemon.ExtId__c, 'ERORR: Peso no coincide');
        System.assertEquals(1, pokemon.Numero_de_Pokemon__c, 'ERORR: Numero de pokemon no coincide');
        System.assertEquals(7, pokemon.Altura__c, 'ERORR: Altura no coincide');
        System.assertEquals(69, pokemon.Peso__c, 'ERORR: Peso no coincide');
        System.assertEquals(45, pokemon.Vida__c, 'ERORR: Vida no coincide');
        System.assertEquals(49, pokemon.Ataque__c, 'ERORR: Ataque no coincide');
        System.assertEquals(49, pokemon.Defensa__c, 'ERORR: Defensa no coincide');
        System.assertEquals(45, pokemon.Velocidad__c, 'ERORR: Velocidad no coincide');
    }
}
