extends Node

var label = Label.new()

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	label.z_index = 99999
	label.position = Vector2(100, 100)
	label.process_mode = PROCESS_MODE_ALWAYS
	self.process_mode = PROCESS_MODE_ALWAYS
	add_child(label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().paused:
		#label.text = "paused"
		print("label prints paused ", randf())
	else:
		label.text = "running"
		#print("label prints running ", randf())
