class_name Level
extends Node2D

# wave number 0 will be empty
# and so will subwave 0, so when the last wave is defeated, there might be a bit of time before the new one begins. "?, not neccesarilly"

@export var all_waves: Array[Wave]
@export var spawn_areas: Array[Area2D]


var goblin = preload("res://scenes/enemies/goblin.tscn")
var shaman = preload("res://scenes/enemies/shaman.tscn")
var green_slime = preload("res://scenes/enemies/green_slime.tscn")

#var last_subwave:bool = false
var wave_is_on_end: bool = false
#var wave_active: bool = false
var active_enemies: int = 0

@onready var amount_of_waves = all_waves.size()
@onready var wave_number_label = get_node("CharacterBody2D/Interface")

#var last_wave = all_waves[amount_of_waves - 0]

var current_wave: int = 0 # wave numer 0 will be empty
var status: String


func _physics_process(delta: float) -> void:
	print("spawn, enemies:   ", active_enemies, "   is on_end ?   ", wave_is_on_end)
	if active_enemies == 0 and wave_is_on_end:
		print("level   current ", current_wave, "  amount   ", amount_of_waves)
		if current_wave == amount_of_waves - 1:
			#get_tree.paused = true
			print("level cleared !")
			wave_number_label.update_wave_number_label(99)
			return
		else:
			#print("                                            spawnn,enemies:   ", active_enemies, "   is last ?   ", last_subwave)
			current_wave += 1
			spawn_next_wave(current_wave)


# credits
# with thanks to alexcavadora and antimundo, https://forum.godotengine.org/t/whats-the-best-way-to-create-a-modular-wave-spawning-node/54271

func spawn_next_wave(wave):
	wave_is_on_end = false
	active_enemies = 0 # this should not be needed
	await get_tree().create_timer(3).timeout
	print("new wave: ", wave)
	print("spawn_test 0")
	wave_number_label.update_wave_number_label(wave)
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
		spawn_unit(current_subwave["name"], current_subwave["time"], current_subwave["amount"], current_subwave["spawn_area"])
		print("time   ", current_subwave["time"])
		await get_tree().create_timer(current_subwave["time"]).timeout
		print("spawnnn   ", current_subwave, "   end:   ", subwave_on_end, "   same?   ", current_subwave == subwave_on_end)
		if current_subwave == subwave_on_end:
			wave_is_on_end = true
		#else:
			#wave_is_on_end = false
	print("spawn_test 6")
	status = "idle"

#spawnnn   <Resource -9223371988871936276>   end   <Resource-9223371988871936276>

# the time is, of course, the amount of time BEFORE these nemeis spawn, not until the next subwave
# really ?
func spawn_unit(enemy_name: String, time, amount: int, spawn_area: int):
	print("spawn_test 3")
	#await
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
		new_enemy.position = get_random_point_in_area(get_node("SpawnAreas").get_child(spawn_area))
		#new_enemy.position += Vector2(randi_range(-100, 100), randi_range(-100, 100))
		active_enemies += 1
		print("spawn_test 5")
		#x.startIndex = spawner_tile_index
	#await get_tree().create_timer(time).timeout #  this should go in spawn_next_wave()


func get_random_point_in_area(area: Area2D) -> Vector2:
	#var shape_node = area.get_node("CollisionShape2D")
	var shape = area.get_node("CollisionShape2D").shape
	print("iii   ", shape)
	if shape is CircleShape2D:
		return get_random_in_circle(shape)
	match shape:
		RectangleShape2D:
			return get_random_in_rectangle(shape)
		CircleShape2D:
			return get_random_in_circle(shape)
	print("iii")
	return Vector2.ZERO


#func get_random_in_rectangle(rect_shape: RectangleShape2D) -> Vector2:
func get_random_in_rectangle(shape: Resource) -> Vector2:
	var ext = shape.extents
	return Vector2(
		randf_range(-ext.x, ext.x),
		randf_range(-ext.y, ext.y)
	)

#func get_random_in_circle(circle_shape: CircleShape2D) -> Vector2:
func get_random_in_circle(shape: Resource) -> Vector2:
	var r = shape.radius * sqrt(randf())  # sqrt to ensure uniform distribution
	var angle = randf() * TAU
	return Vector2(cos(angle), sin(angle)) * r

##func get_random_in_capsule(capsule_shape: CapsuleShape2D) -> Vector2:
#func get_random_in_capsule(area: Area2D) -> Vector2:
	## Treat as two circles + rectangle in between
	#var r = capsule_shape.radius
	#var h = capsule_shape.height
	## Generate a point in a rectangle or circle part
	#while true:
		#var p = Vector2(randf_range(-r, r), randf_range(-h/2 - r, h/2 + r))
		#if p.length() <= r or abs(p.y) <= h/2:
			#return p
	#return Vector2.ZERO
