extends TextureProgressBar

# this thing should NOT have a script


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = get_parent().max_hp
	value = get_parent().hp



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
