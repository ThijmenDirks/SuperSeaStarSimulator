# TransitionZone.gd
extends Area2D

@export var target_map: String
@export var target_entrance: String

@onready var return_point: Marker2D = $"../Spawns/return"


func _on_body_entered(body):



	if body.is_in_group("player") and body is Player:
		print("player got lost in desert")
		print("Transition triggered!")
		print("Changing to:", target_map)
		print("Entrance name:", target_entrance)
		body.position = return_point.position

		#Spawnstates.next_map_path = target_map
		#Spawnstates.next_entrance_name = target_entrance
		
		
		#et_tree().current_scene.queue_free()
		#get_tree().change_scene_to_file(Spawnstates.next_map_path)
		#var result = get_tree().change_scene_to_file(target_map)
		#print("Scene change result:", result)
		
		#RoomLoad.load_room(target_map, target_entrance)
