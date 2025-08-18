# TransitionZone.gd
extends Area2D

@export var target_map: String
@export var target_entrance: String

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Transition triggered!")
		Spawnstates.next_map_path = target_map
		Spawnstates.next_entrance_name = target_entrance
		get_tree().change_scene_to_file(target_map)
