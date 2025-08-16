extends Node2D


@onready var blob = $Blob

var fall_speed = 50
var is_falling: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_falling:
		blob.position.y += min(fall_speed * delta, abs(blob.position.y - position.y))
	if blob.position == position:
		is_falling = false
