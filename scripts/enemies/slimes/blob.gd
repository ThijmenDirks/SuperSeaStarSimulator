#class_name BLob

extends Node2D


@onready var blob = $Blob
const SLIMEING = preload("res://art/particles/slimeing.tscn")

var slime: PackedScene = load("res://scenes/enemies/slimes/red_slime.tscn")

var fall_speed = 5
var is_falling: bool = true # this var should not be needed
var impact_damage:int = 80

var can_spawn_slimes: bool = true
var king_slime

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#print("blob spawns")
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(blob.position, "  blob ", blob.global_position)
	if is_falling:
		#blob.position.y += min(fall_speed * delta, abs(blob.position.y - position.y))
		blob.position.y = move_toward(blob.position.y, 0, fall_speed)
	if blob.position == Vector2(0, 0):
		on_blob_land()


func on_blob_land():
	self.add_child(SLIMEING.instantiate())
	for body in $DamageArea.get_overlapping_bodies():
		if body is Enemy or body is Player:
			body.take_damage(impact_damage, "falling")
	print("blob")
	if can_spawn_slimes:
		var new_slime = slime.instantiate()
		new_slime.position = position
		new_slime.is_spawned_by_king_slime = true
		new_slime.king_slime = king_slime
		king_slime.active_slimes += 1
		
		get_parent().add_child(new_slime)
	queue_free()
