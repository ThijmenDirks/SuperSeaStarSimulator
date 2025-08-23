
class_name BreakableBlock extends StaticBody2D


var resistances_and_weaknesses: Dictionary

@export var max_hp: int = 100
@export var hp: int = 100


func take_damage(damage : int, damage_type : String):
	print("BreakbleBlock takes ", damage, " damage !")
	if damage_type in resistances_and_weaknesses:
		damage *= resistances_and_weaknesses.damage_type
	hp -= damage
	#update_hp_bar()
	if hp < 0:
		get_broken()


func get_broken():
	print("BreakbleBlock breaks !")
	self.queue_free()

#
