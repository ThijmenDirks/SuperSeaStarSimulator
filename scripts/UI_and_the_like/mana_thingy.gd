class_name ManaThingy
extends Node2D

@export var my_color_string: String
@export var my_color_color: Color

@onready var mana_bar_1: TextureProgressBar = $TextureProgressBar1
@onready var mana_bar_2: TextureProgressBar = $TextureProgressBar2

@onready var orbs: Node2D = $Orbs


var all_colors = ["red", "blue", "green", "purple"]
var used_colors = ["red", "green", "blue", "a", "purple"]
var max_orbs = 7
var filled_orbs = max_orbs
var mana_recharge_base_speed = 100
var mana_recharge_multiplier = 1 # size**2
var mana_recharge_speed : int # damage_mulitiplier = size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mana_bar_1.value = 0
	mana_bar_2.value = 0

func set_color(color):
	print("color has been set !")

	match color:
		"red":
			my_color_color = Color(1, 0, 0, 1)
		"blue":
			my_color_color = Color(0, 0, 1, 1)
		"green":
			my_color_color = Color(0, 1, 0, 1)
		"purple":
			my_color_color = Color(1, 0, 1, 1)


	mana_bar_1.tint_progress = my_color_color
	mana_bar_2.tint_progress = my_color_color
	for orb in orbs.get_children():
		orb.color = my_color_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_orbs()
	mana_recharge_multiplier = get_parent().get_node("Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar(my_color_string).size_flags_stretch_ratio ** 2
	#print("dd ", mana_recharge_multiplier)
	mana_recharge_speed = mana_recharge_base_speed * mana_recharge_multiplier
	mana_bar_1.value += mana_recharge_speed
	mana_bar_2.value += mana_recharge_speed
	if mana_bar_1.value == mana_bar_1.max_value:
		if filled_orbs < max_orbs:
			filled_orbs += 1
			mana_bar_1.value = 0
			mana_bar_2.value = 0
	#print("mana_thingy ", my_color, "   ", filled_orbs)

func update_orbs():
	var n: int = 0
	for orb in orbs.get_children():
		if filled_orbs > n:
			orb.color = my_color_color
		else:
			orb.color = Color(0, 0, 0, 1)
		n += 1
