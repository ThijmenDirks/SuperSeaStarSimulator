
class_name BreakableBlock extends StaticBody2D


var resistances_and_weaknesses: Dictionary

@export var max_hp: int = 150
@export var hp: int = 150

@onready var hp_bar = $HPBar



func take_damage(damage : int, damage_type : String):
	print("BreakbleBlock takes ", damage, " damage !")
	if damage_type in resistances_and_weaknesses:
		damage *= resistances_and_weaknesses.damage_type
	hp -= damage
	update_hp_bar()
	if hp < 0:
		get_broken()


func get_broken():
	print("BreakbleBlock breaks !")
	self.queue_free()

func _ready() -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp


func update_hp_bar():
	hp_bar.value = hp
