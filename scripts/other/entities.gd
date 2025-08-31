class_name Entity extends CharacterBody2D



var resistances_and_weaknesses : Dictionary
var last_z_height: int
var current_z_height: int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_z_changed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_z_height = (z_index / 1000) % 10
	if current_z_height != last_z_height:
		on_z_changed()
	last_z_height = current_z_height



func is_on_z_height(z : int, digit : int = 4):
	return int((self.z_index / 10 ** (digit - 1)) % 10) == int((z / 10 ** (digit - 1)) % 10)


func is_on_same_z_height(target: Object) -> bool:
	return int((self.z_index / 1000) % 10) == int((target.z_index / 1000) % 10)


func on_z_changed():
	set_collision_mask_value(20 + last_z_height, false)
	set_collision_mask_value(20 + current_z_height, true)
