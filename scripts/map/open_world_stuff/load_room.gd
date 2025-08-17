extends Node2D

func _ready():
	var entrance_name = Spawnstates.next_entrance_name
	var entrance = $Spawns.get_node_or_null(entrance_name)
	if entrance:
		var player_scene = load("res://scenes/other/player.tscn")
		var player = player_scene.instantiate()
		player.global_position = entrance.global_position
		add_child(player)
