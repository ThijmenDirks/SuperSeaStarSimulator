extends Node2D

var speed = 300
var rotation_speed : float = (50.0/180.0) * PI
var length : int
var hoek = 0
var collision_point : Vector2
var is_coliding = false
var coliding_body : Node2D

@onready var collision = $Line2D/Area2D
@onready var line = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#line.rotation += PI/4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("ddd")
	print("aaa ", line.rotation, "aaa ", get_local_mouse_position().angle())#Vector2(100, 100).angle_to(get_local_mouse_position()))
	line.rotation = move_toward(line.rotation, get_local_mouse_position().dot(line), rotation_speed * delta)# + deg_to_rad(45.0) #* rotation_speed * delta
	#line.rotation = move_toward($Line2D.rotation, Vector2(0,0).angle_to(get_local_mouse_position()), rotation_speed * delta) #* rotation_speed * delta
	#line.rotation = move_toward(line.rotation, Vector2(100, 100).angle_to(get_local_mouse_position()), rotation_speed * delta)# + deg_to_rad(45.0) #* rotation_speed * delta
	#self.rotation = Vector2.RIGHT.angle_to(get_local_mouse_position())

	dot prudct van muis = rotaion van line.

	#self.position = move_toward(self.rotation, Vector2(0, 0).angle_to(get_local_mouse_position()), rotation_speed * delta)
	line.points[1].x += delta * speed

	collision.get_child(0).shape.size.x = line.points[1].x * 2   #delta * speed
	print(line.points[1].x, " ccc ", collision.get_child(0).shape.size.x)

	if is_coliding:
		#is_coliding = false
		_on_area_2d_body_entered(coliding_body)

	if collision.position.distance_to(Vector2(0, 0)) >= get_global_mouse_position().distance_to(Vector2(0, 0)):
	#if distance(end.position, Vector2(0, 0)) >= distance(get_local_mouse_position(), Vector2(0, 0)):
	
		print("bbb")
		speed = 0
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	coliding_body = body
	var raycast = RayCast2D.new()
	self.add_child(raycast)
	raycast.target_position.x = 9999
	raycast.rotation = line.rotation
	raycast.force_raycast_update()
	collision_point = to_local(raycast.get_collision_point())
	if collision_point:
		line.points[1].x = Vector2(0, 0).distance_to(collision_point)
		is_coliding = true
	else:
		is_coliding = false
	print("ddd ", collision_point)

	#to_local(get_collision_point())
	#speed = 0
