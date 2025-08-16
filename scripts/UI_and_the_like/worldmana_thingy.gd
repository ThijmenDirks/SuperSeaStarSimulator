class_name NewManaThingy
extends Node2D

@export var my_color: String

@onready var mana_bar = $TextureProgressBar
@onready var mana_bar2 = $TextureProgressBar2

var all_colors = ["red", "blue", "green", "purple"]
var used_colors = ["red", "blue"]
var max_orbs = 7
var filled_orbs = max_orbs
var mana_recharge_base_speed = 100
var mana_recharge_multiplier = 1 # size**2
var mana_recharge_speed : int # damage_mulitiplier = size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mana_bar.value = 0
	mana_bar2.value = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mana_recharge_multiplier = get_parent().get_node("Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar(my_color).size_flags_stretch_ratio ** 2
	#print("dd ", mana_recharge_multiplier)
	mana_recharge_speed = mana_recharge_base_speed * mana_recharge_multiplier
	mana_bar.value += mana_recharge_speed
	mana_bar2.value += mana_recharge_speed
	if mana_bar.value == mana_bar.max_value:
		if filled_orbs < max_orbs:
			filled_orbs += 1
			mana_bar.value = 0
			mana_bar2.value = 0
	#print("mana_thingy ", my_color, "   ", filled_orbs)
