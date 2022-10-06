@IsTest(SeeAllData=true)
public with sharing class MovimientoAPITest {
    @IsTest
    static void movBatchTest(){
        SingleRequestMock fakeResponse = new singleRequestMock(200,
        'Complete',
        '{"accuracy":100,"effect_chance":null,"effect_entries":[{"effect":"Inflicts regular damage.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Inflicts regular damage with no additional effect."}],"id":1,"name":"pound","power":40,"pp":35,"priority":0,"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}'
        );

        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
            List<Integer> indices = new List<Integer>();
            indices.add(1);
            database.executeBatch(new MovimientoAPI());
            new MovimientoAPI().execute(null, indices);
            new MovimientoAPI().finish(null);
        Test.stopTest();
        
        Movimiento__c movimiento = [SELECT ExtId__c, Objetivo__c, Prioridad__c, Chance_de_Efecto__c, Poder__c, Pp__c, Punteria__c, Efecto__c, Tipo__c FROM Movimiento__c WHERE ExtID__c = 1 LIMIT 1];
        System.assertEquals(1, movimiento.ExtId__c, 'ERROR: ExtId incorrecto.');
        System.assertEquals('selected-pokemon', movimiento.Objetivo__c, 'ERROR: Objetivo incorrecto.');
        System.assertEquals(0, movimiento.Prioridad__c, 'ERROR: Prioridad incorrecta.');
        System.assertEquals(0, movimiento.Chance_de_Efecto__c, 'ERROR: Chance incorrecto.');
        System.assertEquals(40, movimiento.Poder__c, 'ERROR: Poder incorrecto.');
        System.assertEquals(35, movimiento.Pp__c, 'ERROR: Pp incorrecto.');
        System.assertEquals(100, movimiento.Punteria__c, 'ERROR: Puntería incorrecta.');
        System.assertEquals('Inflicts regular damage with no additional effect.', movimiento.Efecto__c, 'ERROR: Efecto incorrecto.');
        System.assertEquals('Normal', movimiento.Tipo__c, 'ERROR: Movimiento incorrecto.');
    }
}