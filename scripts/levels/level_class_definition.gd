class_name Level
extends Node2D

 # wave numer 0 will be empty

@export var all_waves: Array[Wave]
@export var spawn_areas: Array[Area2D]

## ! this might be commented out, but it will be used !

var goblin = preload("res://scenes/enemies/goblin.tscn")
var shaman = preload("res://scenes/enemies/shaman.tscn")
var green_slime = preload("res://scenes/enemies/green_slime.tscn")

var amount_of_waves = 3 # all_waves.size()
var current_wave: int = 0 # wave numer 0 will be empty
var status: String

# credits
# with thanks to alexcavadora and antimundo, https://forum.godotengine.org/t/whats-the-best-way-to-create-a-modular-wave-spawning-node/54271

func spawn_next_wave():
	print("spawn_test 0")
	#return
	current_wave += 1
	#print("enemy   ", all_waves)
	#print("enemy   ", all_waves[current_wave])
	#print("enemy   ", all_waves[current_wave].subwaves)
	#print("spawn_test 0.5")
	if current_wave > amount_of_waves or status == "spawning":
		return
	print("spawn_test 1")
	status = "spawning"
	#emit_signal('wave_changed', current_wave)
	for current_subwave in all_waves[current_wave].subwaves:
		print("spawn_test 2")
		print("enemy   ", current_subwave)#all_waves[current_wave].subwaves)
		#var current_subwave = all_waves[current_wave].subwaves[enemy]
		await spawn_unit(current_subwave["name"], current_subwave["time"], current_subwave["amount"], current_subwave["spawn_area"])
		await get_tree().create_timer(current_subwave["time"]).timeout
	print("spawn_test 6")
	status = "idle"



func spawn_unit(enemy_name: String, time, amount: int, spawn_area: int):
	print("spawn_test 3")
	print("spawn_test 4")
	for i in amount:
		var new_enemy
		match enemy_name:
			"slime":
				new_enemy = green_slime.instantiate()
			"goblin":
				new_enemy = goblin.instantiate()
			"shaman":
				new_enemy = shaman.instantiate()
		#get_node("SpawnAreas").get_child(spawn_area).add_child.call_deferred(new_enemy)
		get_node("SpawnAreas").get_child(spawn_area).add_child(new_enemy)
		new_enemy.position += Vector2(randi_range(-100, 100), randi_range(-100, 100))
		print("spawn_test 5")
		#x.startIndex = spawner_tile_index
	#await get_tree().create_timer(time).timeout #  this should go in spawn_next_wave()
	
	
