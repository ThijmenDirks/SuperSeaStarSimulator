extends Spell

##var all_spells = Spell.new()
#
#func _ready():
	#pass
var test1304 = "1304"

var fireball = {
	"spell_name" = "fireball",
	"spell_recipe" = ["q","z","x","x"],
	"spell_type" = "offensive",
	"spell_target" = "aoe",
	"spell_aoe_size" = 75.0,
	"spell_damage" = 50.0,
	"spell_damage_type" = "fire",
	"spell_kleurenbalkje_change" = 2,
	"spell_orb_cost" = 3,
	"spell_noise" = 200, #amount of (???)(pixels?) ditance in witch enemies are warned. this, or something else, might get multyplied for some enemies.
	"spell_is_targetable" = true,
	"spell_range" = 3000,
	"spell_speed" = 200,
	"spell_function" = load("res://scripts/spells/fireball_func.gd"),# NIET ".BOOM()", MAAR BIJ ELKE CAST NIEUWE INSTANCE VAN FUNCTIE, ANDERS WORDT ER GEOVERWRITED BIJ SPAMMEN! + gebruik await in functie zodat de animatie niet direct weer wordt verwijderd
	"spell_scene" = load("res://scenes/spells/fireball.tscn")
	}

var heal = {
	"spell_name" = "heal",
	"spell_recipe" = ["qe"],
}

var iceblast = {
	"spell_name" = "iceblast",
	"spell_recipe" = ["c","q","x"],
}

#func cast():
	#print("cast ", name)
	##explode()


func get_names():
	#var spell_names = []
	#for spell in self.keys():
		#spell_names.append(spell.name)
	return ["fireball", "heal", "iceblast"]
