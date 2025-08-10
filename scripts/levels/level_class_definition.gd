class_name Level
extends Node2D

# wave number 0 will be empty
# and so will subwave 0, so when the last wave is defeated, there might be a bit of time before the new one begins

@export var all_waves: Array[Wave]
@export var spawn_areas: Array[Area2D]

## ! this might be commented out, but it will be used !

var goblin = preload("res://scenes/enemies/goblin.tscn")
var shaman = preload("res://scenes/enemies/shaman.tscn")
var green_slime = preload("res://scenes/enemies/green_slime.tscn")

var last_subwave:bool = false
var wave_is_ending: bool = false
#var wave_active: bool = false
var active_enemies: int = 0
@onready var amount_of_waves = all_waves.size()

#var last_wave = all_waves[amount_of_waves - 0]

var current_wave: int = 0 # wave numer 0 will be empty
var status: String


func _physics_process(delta: float) -> void:
	#print("spawn,enemies:   ", active_enemies, "   is last ?   ", last_subwave)
	if active_enemies == 0 and wave_is_ending:
		print("level   c ", current_wave, "amount   ", amount_of_waves)
		if current_wave == amount_of_waves - 1:
			#get_tree.paused = true
			print("level cleared !")
			return
		else:
			#print("                                            spawnn,enemies:   ", active_enemies, "   is last ?   ", last_subwave)
			current_wave += 1
			spawn_next_wave(current_wave)


# credits
# with thanks to alexcavadora and antimundo, https://forum.godotengine.org/t/whats-the-best-way-to-create-a-modular-wave-spawning-node/54271

func spawn_next_wave(wave):
	print("spawn_test 0")
	#last_subwave = false
	var subwave_on_end =  all_waves[current_wave].subwaves[-1]
	#print("enemy   ", all_waves)
	#print("enemy   ", all_waves[current_wave])
	#print("enemy   ", all_waves[current_wave].subwaves)
	#print("spawn_test 0.5")
	#if current_wave > amount_of_waves or status == "spawning":
		#return
	print("spawn_test 1")
	status = "spawning"
	#emit_signal('wave_changed', current_wave)
	for current_subwave in all_waves[wave].subwaves:
		print("spawn_test 2")
		print("enemy   ", current_subwave)#all_waves[current_wave].subwaves)
		#var current_subwave = all_waves[current_wave].subwaves[enemy]
		await spawn_unit(current_subwave["name"], current_subwave["time"], current_subwave["amount"], current_subwave["spawn_area"])
		await get_tree().create_timer(current_subwave["time"]).timeout
		print("spawnnn   ", current_subwave, "   end:   ", subwave_on_end, "   same?   ", current_subwave == subwave_on_end)
		if current_subwave == subwave_on_end:
			wave_is_ending = true
	print("spawn_test 6")
	status = "idle"

#spawnnn   <Resource -9223371988871936276>   end   <Resource-9223371988871936276>

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
		active_enemies += 1
		print("spawn_test 5")
		#x.startIndex = spawner_tile_index
	#await get_tree().create_timer(time).timeout #  this should go in spawn_next_wave()
	
	
