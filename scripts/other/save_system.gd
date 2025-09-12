extends Node

#@onready var label: Label = $Label

#var save_path = "user://save.save"
var save_path := "user://savegame.dat"
var cached_data #gpt

func _ready() -> void:
	pass

func save_data() -> void:
	var data := {}
	print("data saved ", get_tree().get_nodes_in_group("saveables"))
	for node in get_tree().get_nodes_in_group("saveables"):
		print("data save test 2")
		data[node.name] = node.get_save_stats()	
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)


func load_data() -> void:
	if not FileAccess.file_exists(save_path):
		print("no data saved")
		return
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	#var data: Dictionary = file.get_var()
	var loaded = file.get_var()
	print("loaded: ", loaded, " file: ", file)
	if loaded is Dictionary:
		cached_data = loaded
	else:
		cached_data = {}
		print("warning: save file contained no valid data")
	
	#cached_data = file.get_var() #gpt
	
	#for node in get_tree().get_nodes_in_group("saveables"):
		#if node.name in data:
			#node.set_save_stats(data[node.name])
	#cached_data = file.get_var() #gpt
	print("data loaded")


func get_player_saved_map():# -> Vector2:
	load_data()
	print("cached_data: ", cached_data)
	if cached_data is Dictionary:
		if "Player" in cached_data:
			return cached_data["Player"]["saved_map"]
	return "res://scenes/levels/open_world_mode/forest1start/spawn1.tscn"


func get_player_saved_point():# -> Vector2:
	load_data()
	if cached_data is Dictionary:
		if "Player" in cached_data:
			return cached_data["Player"]["saved_point"]
	return 0


#func save_data():
	#for node in get_tree().get_nodes_in_group("saveable"): # might change "node" to "scene" ? i dont raelly know acttually
#
		#var file = FileAccess.open(save_path, FileAccess.WRITE)
		#file.store_var(node.get_save_stats())
	#print("data saved")
#
#func load_data():
	#if FileAccess.file_exists(save_path):
		#for node in get_tree().get_nodes_in_group("saveable"): # might change "node" to "scene" ? i dont raelly know acttually
			#var file = FileAccess.open(save_path, FileAccess.READ)
			#node.set_save_stats(file.get_var())
			#print("data loaded")
	#else:
		#print("no data saved")
		#clicks = 0

#func _on_buttonn_button_down() -> void:
	#print("hi")
