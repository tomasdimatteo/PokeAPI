global class PokemonAPI implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {
    global Iterable<Integer> start(Database.BatchableContext bc){
        List<Integer> indices = new List<Integer>();
        for (Integer i = 1; i <= 898; i++) {
            indices.add(i);
        }
        //Solo para testear.
        // indices.add(1);
        return indices;
    }

    global void execute(Database.BatchableContext bc, List<Integer> scope){

        for (Integer s : scope) {
            try {
                Http https = new Http(); 
                HttpRequest req = new HttpRequest();
                req.setHeader('Accept', 'application/json');
                req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                req.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+ s);
                req.setMethod('GET');
                HttpResponse res = https.send(req);
                String body = res.getBody();
                PokeAPIJSON pokeapi = PokeAPIJSON.parse(body);
                //Creamos el objeto a insertar.
                Pokemon__c pokeToIns = new Pokemon__c();
                //Slots de movimientos
                Movimiento__c slot1, slot2, slot3, slot4;
                //Habilidad
                Habilidad__c hab;
                //System.debug('PokeAPI JSON to APEX = '+ pokeapi.types[0].type.name);
                if (res.getStatusCode() == 200) { 
                        //Si el código de la respuesta es 200. Entonces se conectó con éxito.
                        //Rellenamos los campos del objeto.
                        pokeToIns.Name = pokeapi.name.capitalize();
                        pokeToIns.ExtId__c = pokeapi.id;
                        pokeToIns.Numero_de_Pokemon__c = pokeapi.order;
                        pokeToIns.Altura__c = Decimal.valueOf(pokeapi.height);
                        pokeToIns.Peso__c = Decimal.valueOf(pokeapi.weight);
                        if (integer.valueof(pokeapi.id) < 650) {
                            pokeToIns.Imagen__c = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/' + pokeapi.id + '.gif';
                        } else {
                            pokeToIns.Imagen__c = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/'+ pokeapi.id + '.png';
                        }
                        for (Integer i = 0; i < pokeapi.types.size(); i++) {
                            pokeToIns.Tipos__c =  pokeToIns.Tipos__c == null ? pokeapi.types[i].type.name.capitalize() : pokeToIns.Tipos__c + ';' + pokeapi.types[i].type.name.capitalize();
                        }
                        pokeToIns.Vida__c = Decimal.valueOf(pokeapi.stats[0].base_stat);
                        pokeToIns.Ataque__c = Decimal.valueOf(pokeapi.stats[1].base_stat);
                        pokeToIns.Defensa__c = Decimal.valueOf(pokeapi.stats[2].base_stat);
                        pokeToIns.Velocidad__c = Decimal.valueOf(pokeapi.stats[5].base_stat);
                        //Insertamos los movimientos relacionados verificando que la cantidad de movimientos corresponda con los slots
                        if (pokeapi.moves.size() >= 4) {
                            slot1 = [SELECT Id FROM Movimiento__c WHERE Name = :pokeapi.moves[0].move.name LIMIT 1];
                            pokeToIns.Slot1__c = slot1.Id;
                            slot2 = [SELECT Id FROM Movimiento__c WHERE Name = :pokeapi.moves[1].move.name LIMIT 1];
                            pokeToIns.Slot2__c = slot2.Id;
                            slot3 = [SELECT Id FROM Movimiento__c WHERE Name = :pokeapi.moves[2].move.name LIMIT 1];
                            pokeToIns.Slot3__c = slot3.Id;
                            slot4 = [SELECT Id FROM Movimiento__c WHERE Name = :pokeapi.moves[3].move.name LIMIT 1];
                            pokeToIns.Slot4__c = slot4.Id;
                        }else {
                            if (pokeapi.moves.size() == 3) {
                                slot1 = [SELECT Id FROM Movimiento__c WHERE Name = :pokeapi.moves[0].move.name LIMIT 1];
                                pokeToIns.Slot1__c = slot1.Id;
                                slot2 = [SELECT Id FROM Movimiento__c WHERE Name = :pokeapi.moves[1].move.name LIMIT 1];
                                pokeToIns.Slot2__c = slot2.Id;
                                slot3 = [SELECT Id FROM Movimiento__c WHERE Name = :pokeapi.moves[2].move.name LIMIT 1];
                                pokeToIns.Slot3__c = slot3.Id;
                            }else {
                                if (pokeapi.moves.size() == 2) {
                                    slot1 = [SELECT Id FROM Movimiento__c WHERE Name = :pokeapi.moves[0].move.name LIMIT 1];
                                    pokeToIns.Slot1__c = slot1.Id;
                                    slot2 = [SELECT Id FROM Movimiento__c WHERE Name = :pokeapi.moves[1].move.name LIMIT 1];
                                    pokeToIns.Slot2__c = slot2.Id;
                                } else {
                                    if (pokeapi.moves.size() == 1) {
                                        slot1 = [SELECT Id FROM Movimiento__c WHERE Name = :pokeapi.moves[0].move.name LIMIT 1];
                                        pokeToIns.Slot1__c = slot1.Id;
                                    }
                                }
                            }
                        }
                        hab = [SELECT Id FROM Habilidad__c WHERE Name = :pokeapi.abilities[0].ability.name LIMIT 1];
                        pokeToIns.Habilidad__c = hab.Id;
                        //Hacemos un upsert. Si el campo ya existe se actualiza, sino se inserta.
                        upsert pokeToIns;
                }
            } catch (Exception err) {
                //Si no se conectó exitosamente obtenemos el mensaje de error.
                System.debug(err.getMessage());
            }
        }
    }
        
    public void finish(Database.BatchableContext bc){
        System.debug('Todos los movimientos fueron ingresados.');
    }
}
