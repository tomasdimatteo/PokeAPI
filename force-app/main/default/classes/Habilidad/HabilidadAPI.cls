global class HabilidadAPI implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {
    global Iterable<Integer> start(Database.BatchableContext bc){
        List<Integer> indices = new List<Integer>();
        for (Integer i = 1; i <= 267; i++) {
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
                req.setEndpoint('https://pokeapi.co/api/v2/ability/' + s);
                req.setMethod('GET');
                HttpResponse res = https.send(req);
                String body = res.getBody();
                PokeAPIJSON pokeapi = PokeAPIJSON.parse(body);
                Habilidad__c abToIns = new Habilidad__c();
                if (res.getStatusCode() == 200) {
                    abToIns.Name = pokeapi.name.capitalize();
                    abToIns.ExtId__c = pokeapi.id;
                    if (pokeapi.effect_entries.size() > 1) {
                        abToIns.Efecto__c = pokeapi.effect_entries[1].short_effect.capitalize();
                    }else if(pokeapi.effect_entries.size() == 1){
                        abToIns.Efecto__c = pokeapi.effect_entries[0].short_effect.capitalize();
                    }else {
                        abToIns.Efecto__c = 'N/A.';
                    }
                    upsert abToIns;
                }
            } catch (Exception err) {
                System.debug(err.getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Todos las habilidades fueron ingresados.');
    }
}
