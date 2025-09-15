 #TransitionZone.gd
class_name Transition extends CollisionShape2D

@export var ID: String
#@export var shapee: Shape2D
@export var string_target_map: String
#@export var player
#@export var target_entrance: PackedScene
var player# = load("res://scenes/other/player.tscn")
var target_map: PackedScene

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	target_map = load(string_target_map)
	print("waah  ", get_child(0).get_child(0), "   ", self)#get_parent().get_node("Transitions").get_child(0))
	get_child(0).get_child(0).shape = self.shape
	#get_child(0).get_child(0).shape.size = Vector2(10, 30)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("waaah  body entered")
	if body is Player:
		player = body
		print("player entered area !")
		switch_map()
	#if body.is_in_group("player"):
		#print("Transition triggered!")
		#print("Changing to:", target_map)


func switch_map():
	print("switch_map test 0")
	if not target_map: # this probalby wont wokr, needs some weird syntax
		return
	var new_map = target_map.instantiate()
	#print("New map parent:", get_parent().get_parent().get_parent().name)
	#print("Queue freeing:", get_parent().get_parent().name)
	#print("switch_map test 1")
	get_parent().get_parent().get_parent().add_child(new_map) # USER ERROR: Can't change this state while flushing queries. Use call_deferred() or set_deferred() to change monitoring state instead.[enter]at: area_set_shape_disabled (servers/physics_2d/godot_physics_server_2d.cpp:355)
	get_parent().get_parent().get_parent().call_deferred("add_child", new_map)#.add_child(new_map)
	#print("switch_map test 2")
	player.get_parent().remove_child(player) # all fine
	#print("switch_map test 3")
	##player.free()
	##player.reparent(new_map)
	##player.remove_child($Camera2D)
	##player.remove_child($Interface)
	##new_map.add_child(load("res://scenes/other/player.tscn").instantiate())
	#print("Is player valid?", is_instance_valid(player))
	#print("Player name:", player.name)
	new_map.call_deferred("add_child", player) #  here it all goes wrong # not anymore
	#print("switch_map test 4")
	#ID = 
	player.position = new_map.get_node("Spawns").get_node(ID).global_position
	#player.saved_point = new_map.get_node("Spawns").get_child(ID)
	player.saved_point = ID
	player.saved_map = target_map
	#print("switch_map test 5")
	get_parent().get_parent().queue_free()
	#print("switch_map test 6")


#func switch_map():
	#print("--- Switching map ---")
#
	## Instantiate the new map
	#var new_map = target_map.instantiate()
	#var root = get_tree().get_root()#get_tree().current_scene
	#
	## Find current map (assuming this script is inside the current map)
	#var old_map = get_parent().get_parent()
	#
	## Move player safely out of the old map
	#if is_instance_valid(player):
		#old_map.remove_child(player)
	#else:
		#push_warning("Player is not valid! Aborting map switch.")
		#return
#
	## Add the new map to the scene tree
	#root.add_child(new_map)
	#print("New map added:", new_map.name)
#
	## Place player at the target entrance
	#var entrances = new_map.get_node_or_null("TargetEntrances")
	#if entrances and entrances.get_child_count() > 0:
		#player.position = entrances.get_child(ID).global_position
	#else:
		#push_warning("No target entrance found in new map!")
#
	## Add player to new map
	#new_map.add_child(player)
	#print("Player moved to new map at position:", player.position)
#
	## Free the old map
	##old_map.get_parent().get_node("spawn1").queue_free()
	#old_map.queue_free()
	#print("Old map freed:", old_map.name)
#
	#print("--- Map switch complete ---")











		#print("Entrance name:", target_entrance)
		#Spawnstates.next_map_path = target_map
		#Spawnstates.next_entrance_name = target_entrance
		
		#RoomLoad.load_room(target_map, target_entrance)


		#et_tree().current_scene.queue_free()
		#get_tree().change_scene_to_file(Spawnstates.next_map_path)
		#var result = get_tree().change_scene_to_file(target_map)
		#print("Scene change result:", result)
		
