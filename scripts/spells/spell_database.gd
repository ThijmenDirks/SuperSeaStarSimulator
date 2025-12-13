extends Spell

##var all_spells = Spell.new()
#
#func _ready():
	#pass
var test1304 = "1304"

# !!! DONT YOU WANT TO MAKE SPELL STATIC_BODIES OR SOMETHING ANDTHEN JUST ADD AREAS FOR COLLISION ?!?

var fireball = {
	"spell_name" = "fireball",
	"spell_recipe" = ["q","w","r","r"],
	"spell_school" = SPELL_SCHOOLS.FIRE,
	"spell_slot" = 0,
	"spell_type" = "offensive",
	"spell_target" = "aoe",
	"spell_aoe_size" = 75.0,
	"spell_damage" = 50.0,
	"spell_damage_type" = "fire",
	"spell_kleurenbalkje_change" = 2,
	"spell_orb_cost" = {"red" = 2}, # 3
	"spell_noise" = 200, #amount of (???)(pixels?) ditance in witch enemies are warned. this, or something else, might get multyplied for some enemies.
	"spell_is_targetable" = true,
	"spell_range" = 3000,
	"spell_speed" = 200,
	"spell_function" = load("res://scripts/spells/fireball.gd"),# NIET ".BOOM()", MAAR BIJ ELKE CAST NIEUWE INSTANCE VAN FUNCTIE, ANDERS WORDT ER GEOVERWRITED BIJ SPAMMEN! + gebruik await in functie zodat de animatie niet direct weer wordt verwijderd
	"spell_scene" = load("res://scenes/spells/fireball.tscn")
	}


var heal = {
	"spell_name" = "heal",
	"spell_recipe" = ["wr"],
	"spell_school" = SPELL_SCHOOLS.BUFF,
	"spell_slot" = 0,
	"spell_type" = "healing",
	"spell_target" = "single_target",
	"spell_healing" = 50.0, # 50.0
	"spell_healing_type" = "bandage", # ?
	"spell_kleurenbalkje_change" = 4,
	"spell_orb_cost" = {"green" = 4, "blue" = 1},
	"spell_noise" = 20, #amount of (???)(pixels?) ditance in witch enemies are warned. this, or something else, might get multyplied for some enemies.
	"spell_is_targetable" = true,
	"spell_range" = 300,
	"spell_function" = load("res://scripts/spells/heal.gd"),# NIET ".BOOM()", MAAR BIJ ELKE CAST NIEUWE INSTANCE VAN FUNCTIE, ANDERS WORDT ER GEOVERWRITED BIJ SPAMMEN! + gebruik await in functie zodat de animatie niet direct weer wordt verwijderd
	"spell_scene" = load("res://scenes/spells/heal.tscn")
	}


var chain_lightning = {
	"spell_name" = "chain_lightning",
	"spell_recipe" = ["ecleft_mouse_click", "ecleft_mouse_click", "ecright_mouse_click", "z"],
	"spell_school" = SPELL_SCHOOLS.FIRE,
	"spell_slot" = 1,
	"spell_type" = "damage",
	"spell_target" = "multiple_target",
	"spell_chain_range" = 500,
	"spell_damage" = 30.0, # 30.0
	"spell_damage_type" = "electricity", # ?
	"spell_kleurenbalkje_change" = 4,
	"spell_orb_cost" = {"blue" = 4},
	"spell_noise" = 300, #amount of (???)(pixels?) ditance in witch enemies are warned. this, or something else, might get multyplied for some enemies.
	"spell_is_targetable" = true,
	"spell_range" = 500,
	"spell_function" = load("res://scripts/spells/chain_lightning.gd"),# NIET ".BOOM()", MAAR BIJ ELKE CAST NIEUWE INSTANCE VAN FUNCTIE, ANDERS WORDT ER GEOVERWRITED BIJ SPAMMEN! + gebruik await in functie zodat de animatie niet direct weer wordt verwijderd
	"spell_scene" = load("res://scenes/spells/chain_lightning.tscn")
	}


var disintegrate = {
	"spell_name" = "disintegrate",
	"spell_recipe" = ["r", "r", "r"],
	"spell_school" = SPELL_SCHOOLS.FIRE,
	"spell_slot" = 2,
	"spell_type" = "damage",
	"spell_target" = "single_target",
	"spell_base_grow_speed" = 30,
	"spell_rotation_speed" = 0.02,
	"spell_lifetime" = 5,
	"spell_damage" = 999.0,
	"spell_damage_type" = "true", # ?
	"spell_kleurenbalkje_change" = 8,
	"spell_orb_cost" = {"red" = 6, "green" = 2, "blue" = 2, "purple" = 3}, # 5, 5, 2
	"spell_noise" = 300, #amount of (???)(pixels?) ditance in witch enemies are warned. this, or something else, might get multyplied for some enemies.
	"spell_is_targetable" = true,
	"spell_range" = 300,
	"spell_function" = load("res://scripts/spells/disintegrate.gd"),# NIET ".BOOM()", MAAR BIJ ELKE CAST NIEUWE INSTANCE VAN FUNCTIE, ANDERS WORDT ER GEOVERWRITED BIJ SPAMMEN! + gebruik await in functie zodat de animatie niet direct weer wordt verwijderd
	"spell_scene" = load("res://scenes/spells/disintegrate.tscn")
	}


var magic_missile = {
	"spell_name" = "magic_missile",
	"spell_recipe" = ["q","q"],
	"spell_school" = SPELL_SCHOOLS.OTHER,
	"spell_slot" = 0,
	"spell_type" = "offensive",
	"spell_target" = "bullets",
	"spell_damage" = 30.0,
	"spell_damage_type" = "magic",
	"spell_kleurenbalkje_change" = 10,
	"spell_orb_cost" = {"purple" = 2}, # 1
	"spell_noise" = 200, #amount of (???)(pixels?) ditance in witch enemies are warned. this, or something else, might get multyplied for some enemies.
	"spell_is_targetable" = true,
	"spell_range" = 200,
	"spell_speed" = 200,
	"spell_amount_of_bullets" = 5,
	"spell_rate_of_fire" = 0.2,
	"spell_function" = load("res://scripts/spells/magic_missile/magic_missile.gd"),# NIET ".BOOM()", MAAR BIJ ELKE CAST NIEUWE INSTANCE VAN FUNCTIE, ANDERS WORDT ER GEOVERWRITED BIJ SPAMMEN! + gebruik await in functie zodat de animatie niet direct weer wordt verwijderd
	"spell_scene" = load("res://scenes/spells/magic_missile/magic_missile.tscn"),
	"spell_bullet" = load("res://scenes/spells/magic_missile/magic_missile_bullet.tscn"),
	#"spell_bullet" = load("res://scenes/spells/fireball.tscn")
	}


var teleport = {
	"spell_name" = "teleport",
	"spell_recipe" = ["q", "v"],
	"spell_school" = SPELL_SCHOOLS.BUFF,
	"spell_slot" = 1,
	"spell_type" = "utility",
	"spell_target" = "position",
	#"spell_healing" = 50.0, # 50.0
	#"spell_healing_type" = "bandage", # ?
	"spell_kleurenbalkje_change" = 4,
	"spell_orb_cost" = {"purple" = 1, "blue" = 1}, # 5
	"spell_noise" = 20, #amount of (???)(pixels?) ditance in witch enemies are warned. this, or something else, might get multyplied for some enemies.
	"spell_is_targetable" = true,
	"spell_range" = 300,
	"spell_function" = load("res://scripts/spells/teleport.gd"),# NIET ".BOOM()", MAAR BIJ ELKE CAST NIEUWE INSTANCE VAN FUNCTIE, ANDERS WORDT ER GEOVERWRITED BIJ SPAMMEN! + gebruik await in functie zodat de animatie niet direct weer wordt verwijderd
	"spell_scene" = load("res://scenes/spells/teleport.tscn")
	}


var block_of_stone = {
	"spell_name" = "block_of_stone",
	"spell_recipe" = ["q", "r"],
	"spell_school" = SPELL_SCHOOLS.OTHER,
	"spell_slot" = 1,
	"spell_type" = "utility",
	"spell_target" = "single_target",
	"duration" = 5,
	#"spell_healing" = 50.0, # 50.0
	#"spell_healing_type" = "bandage", # ?
	"spell_kleurenbalkje_change" = 2,
	"spell_orb_cost" = {"blue" = 1},
	"spell_noise" = 20, #amount of (???)(pixels?) ditance in witch enemies are warned. this, or something else, might get multyplied for some enemies.
	"spell_is_targetable" = true,
	"spell_range" = 300,
	"spell_function" = load("res://scripts/spells/block_of_stone.gd"),# NIET ".BOOM()", MAAR BIJ ELKE CAST NIEUWE INSTANCE VAN FUNCTIE, ANDERS WORDT ER GEOVERWRITED BIJ SPAMMEN! + gebruik await in functie zodat de animatie niet direct weer wordt verwijderd
	"spell_scene" = load("res://scenes/spells/block_of_stone.tscn")
	}


var iceblast = {
	"spell_name" = "iceblast",
	"spell_recipe" = ["c","q","x"],
}

var all_spells : Array = [fireball, heal, chain_lightning, disintegrate, magic_missile, teleport, block_of_stone]

#func cast():
	#print("cast ", name)
	##explode()


func get_names(): # not sure wheter this func is still in use
	#var spell_names = []
	#for spell in self.keys():
		#spell_names.append(spell.name)
	return ["fireball", "heal", "chain_lightning", "disintegrate", "magic_missile", "teleport", "block_of_stone"]

func get_spell_by_name(name : String):
	for spell in all_spells:
		if spell["spell_name"] == name:
			return spell
	return null
