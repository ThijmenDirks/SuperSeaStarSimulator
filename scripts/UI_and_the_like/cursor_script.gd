extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = load("res://art/UI_and_the_like/kleurenbalkje/other/tempcursortest.png")
	scale = Vector2(1, 1)
	visible = false
	#get_big()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_global_mouse_position()

func get_big():
	scale = Vector2(1.5, 1.5)
	print("cursor big")

func get_small():
	scale = Vector2(1, 1)
	print("cursor small")

func cry():
	pass
