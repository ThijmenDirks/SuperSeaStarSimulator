extends Node2D


@onready var blob = $Blob

var slime: PackedScene = load("res://scenes/enemies/slimes/red_slime.tscn")

var fall_speed = 5
var is_falling: bool = true # this var should not be needed
var impact_damage:int = 80

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
	for body in $DamageArea.get_overlapping_bodies():
		if body is Enemy or body is Player:
			body.take_damage(impact_damage, "falling")
	print("blob")
	var new_slime = slime.instantiate()
	new_slime.position = position
	get_parent().add_child(new_slime)
	queue_free()
