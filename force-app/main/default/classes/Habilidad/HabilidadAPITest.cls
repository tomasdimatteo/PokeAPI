@IsTest(SeeAllData=true)
public with sharing class HabilidadAPITest {
    @IsTest
    static void habBatchTest(){
        SingleRequestMock fakeResponse = new singleRequestMock(200,
        'Complete',
        '{"effect_entries":[{"effect":"Attacken die Schaden verursachen haben mit jedem Treffer eine 10% Chance das Ziel zurückschrecken zu lassen, wenn die Attacke dies nicht bereits als Nebeneffekt hat.Der Effekt stapelt nicht mit dem von getragenen Items.Außerhalb vom Kampf: Wenn ein Pokémon mit dieser Fähigkeit an erster Stelle im Team steht, tauchen wilde Pokémon nur halb so oft auf.","language":{"name":"de","url":"https://pokeapi.co/api/v2/language/6/"},"short_effect":"Mit jedem Treffer besteht eine 10% Chance das Ziel zurückschrecken zu lassen."},{"effect":"This Pokémons damaging moves have a 10% chance to make the target flinch with each hit if they do not already cause flinching as a secondary effect.This ability does not stack with a held item Overworld: The wild encounter rate is halved while this Pokémon is first in the party.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Has a 10% chance of making target Pokemon flinch with each hit."}],"id":1}'
        );

        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
            List<Integer> indices = new List<Integer>();
            indices.add(1);
            database.executeBatch(new HabilidadAPI());
            new HabilidadAPI().execute(null, indices);
            new HabilidadAPI().finish(null);
        Test.stopTest();
        Habilidad__c habilidad = [SELECT ExtId__c, Efecto__c FROM Habilidad__c WHERE ExtID__c = 1];
        System.assertEquals(1, habilidad.ExtId__c, 'ERROR: ExtId incorrecto.');
        System.assertEquals('Has a 10% chance of making target Pokémon flinch with each hit.', habilidad.Efecto__c , 'ERROR: Efecto incorrecto');
    }
}