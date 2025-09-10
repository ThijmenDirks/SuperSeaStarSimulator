extends Node2D

var testlevel = load("res://scenes/levels/test_level.tscn").instantiate()
var Openworld = load("res://scenes/levels/open_world_mode/forest1start/spawn1.tscn").instantiate()

#"res://scenes/levels/test_level.tscn"


func _on_wave_mode_button_button_down() -> void:
	get_tree().root.add_child(testlevel)
	self.add_child(testlevel)
	self.visible = false


func _on_basic_controls_button_pressed() -> void:
	var sprite = $Sprite2D2
	if sprite.visible == true:
		sprite.visible = false
	else:
		sprite.visible = true


func _on_open_world_mode_button_button_down() -> void:
	RoomLoad.load_room("res://scenes/levels/open_world_mode/forest1start/spawn1.tscn", "Start")
	#Spawnstates.next_map_path = "res://scenes/levels/open_world_mode_forest1start/spawn1.tscn"
	#Spawnstates.next_entrance_name = "Start"
	#load_room(Spawnstates.next_map_path, Spawnstates.next_entrance_name)
