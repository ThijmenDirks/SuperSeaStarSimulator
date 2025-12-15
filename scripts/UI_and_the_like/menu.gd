extends Node2D

var testlevel: PackedScene = load("res://scenes/levels/test_level_3.tscn")
var openworld: PackedScene = load("res://scenes/levels/open_world_mode/forest1start/spawn1.tscn")
var classic_level: PackedScene = load("res://scenes/levels/classic_level_1.tscn")
var turtortial: PackedScene = load("res://scenes/levels/tutortial.tscn")

@onready var mouse_size_button: Button = $MouseSizeButton

var big_cursor: bool = false

var CursorScript = preload("res://scripts/UI_and_the_like/cursor_script.gd")

#"res://scenes/levels/test_level.tscn"

#var x: 
func _ready() -> void:
	print("really still paused ? ", get_tree().paused)
	print("path ", scene_file_path)
	get_tree().paused = false
	print("really really still paused ? ", get_tree().paused)

func _process(delta: float) -> void:
	get_tree().paused = false

func _on_wave_mode_button_button_down() -> void:
	print("wave_mode button down")
	get_tree().root.add_child(testlevel.instantiate())
	#self.add_child(testlevel.instantiate())
	#self.visible = false
	queue_free()


func _on_basic_controls_button_pressed() -> void:
	print("basic_controls button pressed")
	var sprite = $Sprite2D2
	if sprite.visible == true:
		sprite.visible = false
	else:
		sprite.visible = true


func _on_open_world_mode_button_button_down() -> void:
	print("open_world_mode button down")
	#Spawnstates.next_map_path = "res://scenes/levels/open_world_mode_forest1start/spawn1.tscn"
	#Spawnstates.next_entrance_name = "Start"
	#load_room(Spawnstates.next_map_path, Spawnstates.next_entrance_name)
	var spawn_map = SaveSystem.get_player_saved_map()
	var spawn_position = SaveSystem.get_player_saved_point()
	#spawn_map = "res://scenes/levels/open_world_mode/forest1start/spawn1.tscn" # deze line
	#spawn_position = "Start" # en deze line
	RoomLoad.load_room(spawn_map, spawn_position)
	queue_free()
	#player_instance.global_position = spawn_position


func _on_classic_mode_button_pressed() -> void:
	print("classic_mode button down")
	get_tree().root.add_child(classic_level.instantiate())
	#self.add_child(testlevel.instantiate())
	#self.visible = false
	queue_free()


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


func _on_basic_controls_button_2_pressed():
	print("turtortial_mode button down")
	get_tree().root.add_child(turtortial.instantiate())
	#self.add_child(testlevel.instantiate())
	#self.visible = false
	queue_free()


func _on_mouse_size_button_pressed() -> void:
	if big_cursor:
		get_tree().get_root().get_node("/root/CursorScript").get_small()
		mouse_size_button.text = "big cursor"
		big_cursor = false
	else:
		get_tree().get_root().get_node("/root/CursorScript").get_big()
		mouse_size_button.text = "small cursor"
		big_cursor = true
		
