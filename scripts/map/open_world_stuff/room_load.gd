extends Node


var player_scene = preload("res://scenes/other/player.tscn")
var player_instance: Node2D

func load_room(room_path: String, entrance_name):
	print("load_room 1")
	# Remove current scene if one exists
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()

	# Load and instantiate the new room
	#room_path = ("res://scenes/levels/open_world_mode/forest1start/spawn1.tscn")
	var new_room = load(room_path).instantiate()
	get_tree().root.add_child(new_room)
	get_tree().current_scene = new_room

	 # Find the entrance point
	#var entrance = new_room.get_node_or_null("Spawns/" + entrance_name)
	var entrance = new_room.get_node("Spawns").get_node(entrance_name)
	if entrance:
		# Spawn or move the player
		#if player_instance:
			#player_instance.queue_free()
		player_instance = player_scene.instantiate()
		new_room.add_child(player_instance)
		player_instance.global_position = entrance.global_position
	else:
		print("Entrance not found:", entrance_name)
