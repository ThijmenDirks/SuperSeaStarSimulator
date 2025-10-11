class_name Level
extends Node2D


@export var all_waves: Array[Wave]
@export var spawn_areas: Array[Area2D]


var goblin = preload("res://scenes/enemies/goblin.tscn")
var shaman = preload("res://scenes/enemies/shaman.tscn")
var blue_slime = preload("res://scenes/enemies/slimes/blue_slime.tscn")
var red_slime = preload("res://scenes/enemies/slimes/red_slime.tscn")
var green_slime = preload("res://scenes/enemies/slimes/green_slime.tscn")
var king_slime = preload("res://scenes/enemies/slimes/king_slime.tscn")
var ogre = preload("res://scenes/enemies/ogre.tscn")
var blink_fey = preload("res://scenes/enemies/blink_fey.tscn")
var mummy = preload("res://scenes/enemies/mummy.tscn")
var dart_fey = preload("res://scenes/enemies/dart_fey.tscn")

var enemy_map = {
	"goblin": goblin,
	"shaman": shaman,
	"ogre": ogre,
	"blue_slime": blue_slime,
	"green_slime": green_slime,
	"red_slime": red_slime,
	"king_slime": king_slime,
	"blink_fey": blink_fey,
	"mummy": mummy,
	"dart_fey": dart_fey,
}

#enemy_map[all_enemies[]]

var all_enemies = [
	"goblin",
	"shaman",
	"ogre",
	"blue_slime",
	"green_slime",
	"red_slime",
	"king_slime",
	"blink_fey",
	"mummy",
	"dart_fey"
]

var wave_has_fully_spawned: bool = false
var active_enemies: int = 0

@onready var wave_number_label = get_node("CharacterBody2D/Interface")

var current_wave: int = 0 # wave numer 0 will be empty


func _process(_delta: float) -> void:
	if active_enemies == 0 and wave_has_fully_spawned:
		if current_wave == all_waves.size() - 1:
			print("level cleared !")
			wave_number_label.update_wave_number_label(99)
			return
		else:
			current_wave += 1
			spawn_next_wave(current_wave)


# credits
# with thanks to alexcavadora and antimundo, https://forum.godotengine.org/t/whats-the-best-way-to-create-a-modular-wave-spawning-node/54271
func spawn_next_wave(wave):
	wave_has_fully_spawned = false
	active_enemies = 0 # this should not be needed
	await get_tree().create_timer(3).timeout
	wave_number_label.update_wave_number_label(wave) # should go back !
	var final_subwave = all_waves[wave].subwaves.back()
	for current_subwave in all_waves[wave].subwaves:
		spawn_enemies(all_enemies[current_subwave["enemy"]], current_subwave["amount"], current_subwave["spawn_area"])
		if current_subwave == final_subwave:
			wave_has_fully_spawned = true
		print("Subwave has spawned, next wave will spawn in: ", current_subwave["time"])
		print("Spawned: ", current_subwave, ", this was", "not " if current_subwave != final_subwave else "", " the last wave")
		await get_tree().create_timer(current_subwave["time"]).timeout


func spawn_enemies(enemy_name: String, amount: int, spawn_area: int):
	var spawn_area_node = get_node("SpawnAreas").get_child(spawn_area)
	for i in amount:
		var new_enemy
		if enemy_name in enemy_map:
			new_enemy = enemy_map[enemy_name].instantiate()
		else:
			print("Unknown enemy type: ", enemy_name)
			continue  # Skip spawning and go to next enemy if enemy_name

		spawn_area_node.add_child(new_enemy)
		new_enemy.position = get_random_point_in_area(spawn_area_node)
		#new_enemy.position += Vector2(randi_range(-100, 100), randi_range(-100, 100))
		active_enemies += 1
		#wave_number_label.update_wave_number_label(active_enemies)


func get_random_point_in_area(area: Area2D) -> Vector2:
	var shape = area.get_node("CollisionShape2D").shape
	if shape is RectangleShape2D:
			return get_random_in_rectangle(shape)
	elif shape is CircleShape2D:
		return get_random_in_circle(shape)
	else:
		return Vector2.ZERO


func get_random_in_rectangle(shape: Resource) -> Vector2:
	var ext = shape.extents
	return Vector2(
		randf_range(-ext.x, ext.x),
		randf_range(-ext.y, ext.y)
	)


func get_random_in_circle(shape: Resource) -> Vector2:
	var r = shape.radius * sqrt(randf())  # sqrt to ensure uniform distribution
	var angle = randf() * TAU
	return Vector2(cos(angle), sin(angle)) * r


func generate_new_wave():
	pass
