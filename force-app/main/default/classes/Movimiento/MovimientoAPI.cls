global class MovimientoAPI implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful { 
    global Iterable<Integer> start(Database.BatchableContext bc){
        List<Integer> indices = new List<Integer>();
        for (Integer i = 1; i <= 826; i++) {
            indices.add(i);
        }
        // Solo para testear
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
                req.setEndpoint('https://pokeapi.co/api/v2/move/' + s);
                req.setMethod('GET');
                HttpResponse res = https.send(req);
                String body = res.getBody();
                PokeAPIJSON pokeapi = PokeAPIJSON.parse(body);
                Movimiento__c moveToIns = new Movimiento__c();
                if (res.getStatusCode() == 200) { 
                    moveToIns.ExtId__c = pokeapi.id;
                    moveToIns.Name = pokeapi.name.capitalize();
                    moveToIns.Objetivo__c = pokeapi.target.name.capitalize();
                    moveToIns.Prioridad__c = pokeapi.priority == null ? 0 : Integer.valueOf(pokeapi.priority);
                    moveToIns.Chance_de_Efecto__c = pokeapi.effect_chance == null ? 0 : Integer.valueOf(pokeapi.effect_chance);
                    moveToIns.Poder__c = pokeapi.power == null ? 0 : Integer.valueOf(pokeapi.power);
                    moveToIns.Pp__c = pokeapi.pp == null ? 0 : Integer.valueOf(pokeapi.pp); 
                    moveToIns.Punteria__c = pokeapi.accuracy == null ? 0 : Integer.valueOf(pokeapi.accuracy);
                    if(pokeapi.effect_entries.size() >= 1){
                        moveToIns.Efecto__c = pokeapi.effect_entries[0].short_effect.capitalize();
                    }else {
                        moveToIns.Efecto__c = 'N/A.';
                    }
                    moveToIns.Tipo__c = pokeapi.type.name;
                    upsert moveToIns;
                }
            } catch (Exception err) {
                System.debug(err.getMessage());
            }
        }
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('Todos los movimientos fueron ingresados.');
    }
}