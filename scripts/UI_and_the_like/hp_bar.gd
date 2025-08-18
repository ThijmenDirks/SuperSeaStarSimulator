extends TextureProgressBar

# this thing should NOT have a script


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#max_value = get_parent().max_hp
	#value = get_parent().hp
# ^ this didnt work cause it runned before the hp of the enemy was set in their _ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
