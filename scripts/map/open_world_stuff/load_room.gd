extends Node
#
#
#
#
#
## WARNING
#
## this is (or so i think) the UNUSED version of roomload_mess
#
## this script is used by spawn1
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#var player_scene = preload("res://scenes/other/player.tscn")
#var player_instance: Node2D
#
#func load_room(room_path: String, entrance_name: int):
	#print("load_room 2")
	## Remove current scene
	#if get_tree().current_scene:
		#get_tree().current_scene.queue_free()
#
	## Load new room
#
	#var new_room = load(room_path).instantiate()
	#get_tree().root.add_child(new_room)
	#get_tree().current_scene = new_room
#
	## Find entrance and spawn player
	##var entrance = new_room.get_node_or_null("Spawns/" + entrance_name)
	#var entrance = new_room.get_node("Spawns").get_node(entrance_name)
	#if entrance:
#
		#if player_instance:
			#player_instance.queue_free()
		#player_instance = player_scene.instantiate()
		#new_room.add_child(player_instance)
		#player_instance.global_position = entrance.global_position
	#else:
		#print("Entrance not found:", entrance_name)
