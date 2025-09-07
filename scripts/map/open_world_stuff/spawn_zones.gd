# TransitionZone.gd
extends Area2D

@export var target_map: String
@export var target_entrance: String

func _on_body_entered(body):
	print("waaaaz")
	return
	if body.is_in_group("player"):
		print("Transition triggered!")
		print("Changing to:", target_map)
		print("Entrance name:", target_entrance)
		Spawnstates.next_map_path = target_map
		Spawnstates.next_entrance_name = target_entrance
		
		
		#et_tree().current_scene.queue_free()
		#get_tree().change_scene_to_file(Spawnstates.next_map_path)
		#var result = get_tree().change_scene_to_file(target_map)
		#print("Scene change result:", result)
		
		RoomLoad.load_room(target_map, target_entrance)
