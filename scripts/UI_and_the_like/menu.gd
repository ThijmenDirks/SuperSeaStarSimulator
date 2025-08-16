extends Node2D

var testlevel2 = load("res://scenes/levels/test_level.tscn").instantiate()
var Openworld = load("res://scenes/levels/openworld.tscn").instantiate()

#"res://scenes/levels/test_level.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_button_down() -> void:
	pass # Replace with function body.
	print("hi")
	get_tree().root.add_child(testlevel2)
	self.add_child(testlevel2)
	self.visible = false


func _on_button_button_down():
	pass # Replace with function body.
	print("hi")
	get_tree().root.add_child(Openworld)
	self.add_child(Openworld)
	self.visible = false
