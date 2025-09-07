extends StaticBody2D

@onready var bridge_side_collision_1 = $CollisionShape2D
@onready var bridge_side_collision_2 = $CollisionShape2D2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("bridge test 0")
	if body is Player or body is Enemy or body is Spell:
		if not is_on_same_z_height(body): # this might change to body.in_on_samea_z_heigth
			#body.add_collision_exception_with(bridge_side_collision_1)
			#body.add_collision_exception_with(bridge_side_collision_2)
			body.add_collision_exception_with(self) # warning! thisl ine might be interesting !
			print("bridge test 1  ", body.get_collision_exceptions())



func is_on_z_height(z : int, digit : int = 4):
	return int((self.z_index / 10 ** (digit - 1)) % 10) == int((z / 10 ** (digit - 1)) % 10)


func is_on_same_z_height(target: Object) -> bool:
	return int((self.z_index / 1000) % 10) == int((target.z_index / 1000) % 10)
