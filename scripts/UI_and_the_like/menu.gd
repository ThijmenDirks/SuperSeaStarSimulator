extends Node2D

var testlevel = load("res://scenes/levels/test_level.tscn").instantiate()
var Openworld = load("res://scenes/levels/open_world_mode/forest1start/spawn1.tscn").instantiate()

#"res://scenes/levels/test_level.tscn"

#var x: 
func _ready() -> void:
	print("path ", scene_file_path)

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
	#Spawnstates.next_map_path = "res://scenes/levels/open_world_mode_forest1start/spawn1.tscn"
	#Spawnstates.next_entrance_name = "Start"
	#load_room(Spawnstates.next_map_path, Spawnstates.next_entrance_name)
	var spawn_map = SaveSystem.get_player_saved_map()
	var spawn_position = SaveSystem.get_player_saved_point()
	spawn_map = "res://scenes/levels/open_world_mode/forest1start/spawn1.tscn" # deze line
	spawn_position = "Start" # en deze line
	RoomLoad.load_room(spawn_map, spawn_position)
	#player_instance.global_position = spawn_position

#func get_player_saved_point():# -> Vector2:
	#if "Player" in cached_data:
		#return cached_data["Player"]["saved_point"]
	#return Vector2.ZERO
#
#
#func get_player_saved_map():# -> Vector2:
	#if "Player" in cached_data:
		#return cached_data["Player"]["saved_map"]
	#return "res://scenes/levels/open_world_mode/forest1start/spawn1.tscn"
