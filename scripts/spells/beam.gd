extends Spell # might aswell be node2D, i think

var base_grow_speed = 300
var grow_speed = base_grow_speed
var rotation_speed : float = 0.02#(50.0/180.0) * PI
#var length : int = 100
#var hoek = 0
var collision_point : Vector2
var is_colliding = false
var colliding_body : Node2D

@onready var raycast = $RayCast2D
@onready var collision = $Line2D/Area2D
@onready var collision_shape = collision.get_child(0)
@onready var line = $Line2D
#@onready var temp_points = [line.points[0], line.points[1]]

@export var line_pivot : Line2D

signal on_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#rotation = global_position.angle_to(get_global_mouse_position())
	#rotation = line_pivot.global_position.direction_to(get_global_mouse_position()).angle()
	line_pivot.rotation = line_pivot.global_position.direction_to(get_global_mouse_position()).angle()
	line.rotation = line_pivot.rotation  # Optional: also rotate the visual line if needed

	max_range = 300
	#on_hit.connect(_on_hit)
	#on_hit.emit("8")  # only at this place for debugging
	#print("hit 3")
	#pass # Replace with function body.
	#line.rotation = 360
#---
#@export var player: CharacterBody2D

#length = 100


#func _process(delta: float) -> void:
	#var origin = line.points[0]
	#var dir = origin.direction_to(player.global_position)
	#temp_points[1] = origin + (dir * length)
	#line.points = PackedVector2Array(temp_points)
#---
# Called every frame. 'delta' is the elapsed time since the previous frame.


# credits
# thanks to daikaigan


func _physics_process(delta: float) -> void:

	# Clamp the rotation value of the pivot such that 
	# it's always between -PI and PI.
	if line_pivot.rotation > PI:
		line_pivot.rotation -= 2 * PI
	if line_pivot.rotation < -PI:
		line_pivot.rotation += 2 * PI

	var origin = line_pivot.global_position
	var target_angle = origin.direction_to(get_global_mouse_position()).angle()
	var backup_rotation_speed = rotation_speed
	# The logic below can definitely be simplified if you prefer, though writing
	# it this way makes the logic (relatively) easy to understand.
	if abs(line_pivot.rotation - target_angle) < rotation_speed:
		# Stop rotating if the rotation is close enough to the cursor.
		# This stops it from jiterring back and forth.
		rotation_speed = abs(line_pivot.rotation - target_angle)
	if line_pivot.rotation > target_angle:
		if line_pivot.rotation - target_angle > PI:
			line_pivot.rotation += rotation_speed
		else:
			line_pivot.rotation -= rotation_speed
	else:
		if target_angle - line_pivot.rotation > PI:
			line_pivot.rotation -= rotation_speed
		else:
			line_pivot.rotation += rotation_speed
	rotation_speed = backup_rotation_speed

# ----------------------------------------------------------------------------

	line.points[1].x += delta * grow_speed
	collision_shape.shape.size.x = line.points[1].x   #delta * speed
	collision_shape.position.x = line.points[1].x / 2

	#print(line.points[1].x, " ccc ", collision.get_child(0).shape.size.x)

	if is_colliding:
		#is_colliding = false
		_on_area_2d_body_entered(colliding_body)

	#if line.points[1].x >= get_global_mouse_position().distance_to(Vector2(0, 0)):
	#if collision.position.distance_to(Vector2(0, 0)) >= get_global_mouse_position().distance_to(Vector2(0, 0)):
	#if distance(end.position, Vector2(0, 0)) >= distance(get_local_mouse_position(), Vector2(0, 0)):
	
		#print("bbb")
		#line.points[1].x = get_global_mouse_position().distance_to(Vector2(0, 0))
		# seems to be wroking
	var mouse_distance = origin.distance_to(get_global_mouse_position())
	if line.points[1].x >= mouse_distance:
		line.points[1].x = mouse_distance

		#speed = 0
		#is_colliding = true
	if line.points[1].x >= max_range:
		grow_speed = 0
	else:
		grow_speed = base_grow_speed

#func _on_hit():
	#__on_hit()
#
#func __on_hit():
	#print("hit 4")

func _on_area_2d_body_entered(body: Node2D) -> void:
	on_hit.emit(body)
	is_colliding = true
	#grow_speed = 0
	#line.points[1].x = collision_point.distance_to(Vector2(0, 0))

	colliding_body = body
	#var raycast = RayCast2D.new()
	#self.add_child(raycast)
	#raycast.target_position.x = 9999
	raycast.rotation = line.rotation
	raycast.enabled = true
	raycast.force_raycast_update()
	collision_point = to_local(raycast.get_collision_point())
	if collision_point:
		line.points[1].x = Vector2(0, 0).distance_to(collision_point)
		is_colliding = true
	else:
		is_colliding = false
		#print("something went wrong by raycasting beam!!")
	#print("ddd ", collision_point)
	raycast.enabled = false

	#to_local(get_collision_point())
	#speed = 0

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_colliding = false
	speed = base_grow_speed




	#var origin = line.points[0]
	#var dir = origin.direction_to(get_global_mouse_position())
	#temp_points[1] = origin + (dir * length)
	#line.points = PackedVector2Array(temp_points)
	#print("ddd")
	#print("aaa ", line.rotation, "aaa ", get_local_mouse_position().angle())#Vector2(100, 100).angle_to(get_local_mouse_position()))
	##line.rotation = move_toward(line.rotation, get_local_mouse_position().angle(), rotation_speed * delta)
	#var rotation_of_mouse = rad_to_deg(acos(get_local_mouse_position().dot(Vector2(0, 0))))
	#if rotation_of_mouse >= 180:
		#rotation_of_mouse -= 180
	#if rotation_of_mouse < 0:
		#rotation_of_mouse += 180
	#line.rotation = move_toward(line.rotation, abs(line.position.angle_to(Vector2(0, 0)) - get_local_mouse_position().angle_to(Vector2(0,0))), rotation_speed * delta)# + deg_to_rad(45.0) #* rotation_speed * delta
	#line.rotation = move_toward(line.rotation, (get_local_mouse_position() - line.position).angle(), rotation_speed * delta)

#verschil l en m
#l - verscil
#met allebei in dot(), niet arc(dinges -- of juist wel
	#line.rotation - (l-m)
	
	#abs(line.rotation.angle_to(Vector2(0, 0)) - get_local_mouse_position().angle_to(Vector2(0,0)))

	#line.rotation = move_toward(line.rotation, (get_global_mouse_position() - line.global_position).angle(), rotation_speed * delta)

	#line.rotation = move_toward($Line2D.rotation, Vector2(0,0).angle_to(get_local_mouse_position()), rotation_speed * delta) #* rotation_speed * delta
	#line.rotation = move_toward(line.rotation, Vector2(100, 100).angle_to(get_local_mouse_position()), rotation_speed * delta)# + deg_to_rad(45.0) #* rotation_speed * delta
	#self.rotation = Vector2.RIGHT.angle_to(get_local_mouse_position())

	#dot prudct van muis = rotaion van line.

	#self.position = move_toward(self.rotation, Vector2(0, 0).angle_to(get_local_mouse_position()), rotation_speed * delta)
