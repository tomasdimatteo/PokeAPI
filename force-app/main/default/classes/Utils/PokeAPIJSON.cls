public class PokeAPIJSON{
	//Pokemon
	public Integer count;
	public Integer height;
	public Integer id;	
	public String name;	
	public Integer order;
	public cls_stats[] stats;
	public cls_types[] types;
	public Integer weight;
	public cls_target target;
	public cls_moves[] moves;
	public cls_abilities[] abilities;

	public class cls_abilities {
		public cls_ability ability;
		public boolean is_hidden;
		public Integer slot;	//1
	}
	public class cls_ability {
		public String name;	//overgrow
		public String url;	//https://pokeapi.co/api/v2/ability/65/
	}
	public class cls_moves {
		public cls_move move;
	}
	public class cls_move {
		public String name;	//razor-wind
		public String url;	//https://pokeapi.co/api/v2/move/13/
	}
	public class cls_stats {
		public Integer base_stat;	
		public Integer effort;	
		public cls_stat stat;
	}
	public class cls_stat {
		public String name;	
		public String url;
	}
	public class cls_types {
		public Integer slot;	
		public cls_type type;
	}
	public class cls_type {
		public String name;	
		public String url;	
	}
	public class cls_target {
		public String name;	
		public String url;	
	}
	//Movimientos
	public Integer accuracy;
	public String effect_chance;
	public cls_effect_entries[] effect_entries;
	//public Integer id_m;	
	public Integer power;	
	public Integer pp;	
	public Integer priority;
	//public cls_target_m target_m;
	public cls_type type;

	public class cls_effect_entries {
		public String effect;	
		public cls_language language;
		public String short_effect;	
	}
	public class cls_language {
		public String name;
		public String url;	
	}
	/*public class cls_target_m {
		public String name;	
		public String url;	
	}
	public class cls_type {
		public String name;	
		public String url;	
	}*/
	//Habilidades
	//public cls_effect_entries[] effect_entries_h;
	//public Integer id_h;	
	//public String name_h;	
	/*class cls_effect_entries_h {
		public String effect;
		public cls_language language;
		public String short_effect;
	}
	class cls_language_h {
		public String name;	
		public String url;	
	}*/
	public static PokeAPIJSON parse(String json){
		return (PokeAPIJSON) System.JSON.deserialize(json, PokeAPIJSON.class);
	}
}