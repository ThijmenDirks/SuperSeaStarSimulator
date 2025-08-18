extends Node

var player_scene = preload("res://scenes/other/player.tscn")
var player_instance: Node2D

func spawn_player_at(position: Vector2):
	if player_instance:
		player_instance.queue_free()
	player_instance = player_scene.instantiate()
	get_tree().current_scene.add_child(player_instance)
	player_instance.global_position = position
