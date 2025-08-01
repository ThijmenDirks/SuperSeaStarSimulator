class_name MoveableBlock extends RigidBody2D
#
#
var move_speed : int
var direction : Vector2
var travelled_distance : float
var grid_width = 40
var is_moving: bool = false


@onready var up_space_area = $UpSpaceArea
@onready var right_space_area = $RightSpaceArea
@onready var down_space_area = $DownSpaceArea
@onready var left_space_area = $LeftSpaceArea


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("move ", is_moving)
	if is_moving:
		print("move/   position:   ", position, "   movement:   ", direction * delta * move_speed, "   end_pos:  ", position + direction * delta * move_speed)
		position += direction * delta * move_speed
		travelled_distance += abs(direction.length() * delta * move_speed)
		print("moveable_block travelled:   ", travelled_distance, "  position:  ", position)
		if travelled_distance >= grid_width:#grid_width - travelled_distance < delta * move_speed * 2: #travelled_distance >= grid_width:
			print("movemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemove")
			#print("moveable_block travelled:   ", travelled_distance, "  position:  ", position)
			if direction == Vector2(1, 0):
				#position.x = (grid_width - travelled_distance)
				position.x -= (travelled_distance - grid_width)
			else:
				#position.y += (grid_width - travelled_distance)
				position.y -= (travelled_distance - grid_width)
			move_speed = 0
			travelled_distance = 0
			is_moving = false
			
			linear_velocity = Vector2.ZERO
			#sleeping = true
	else:
		linear_velocity = Vector2.ZERO
	var c = get_colliding_bodies()
	if c:
		c = c[0]
		is_moving = true
		move_speed = c.speed
		var my_pos = global_position
		var other_pos = c.get_position()
		var diff = other_pos - my_pos

		if abs(diff.x) > abs(diff.y):
			if diff.x > 0:
				print("Character is to the RIGHT of the rigidbody")
				direction = Vector2(-1, 0)
			else:
				print("Character is to the LEFT of the rigidbody")
				direction = Vector2(1, 0)
		else:
			if diff.y > 0:
				print("Character is BELOW the rigidbody")
				direction = Vector2(0, -1)
			else:
				print("Character is ABOVE the rigidbody")
				direction = Vector2(0, 1)
		#sleeping = true

				#var push_force = 10
				#c.get_collider().apply_central_impulse(-c.get_normal() * push_foararce)


func _on_body_entered(body: Node) -> void:
	return
	print("Character iss")
	if is_moving:
		return
	print("Character is")

	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#var collider = c.get_collider()
	if body:
		#print("is to the   ", c.get_position())
		is_moving = true
		move_speed = body.speed
		var my_pos = global_position
		var other_pos = body.get_position()
		var diff = other_pos - my_pos

		if abs(diff.x) > abs(diff.y):
			if diff.x > 0:
				print("Character is to the RIGHT of the rigidbody")
				direction = Vector2(-1, 0)
			else:
				print("Character is to the LEFT of the rigidbody")
				direction = Vector2(1, 0)
		else:
			if diff.y > 0:
				print("Character is BELOW the rigidbody")
				direction = Vector2(0, -1)
			else:
				print("Character is ABOVE the rigidbody")
				direction = Vector2(0, 1)


#func move(to_direction: Vector2, speed : int): # but now this func is not needed anymore
	#if is_moving:
		#return
	## hier nog ff kijken of er wel ruimte is
	#
	#is_moving = true
	#move_speed = speed
	#direction = to_direction
	#move_and#
	#position += to_direction * speed * delta
	#is_moving = false


#func _physics_process(_delta):
	#if abs(linear_velocity.x) <= 70 and abs(linear_velocity.y) <= 70:
		#position = position.snapped(Vector2.ONE*40)


#func move(from_direction: String, body: Node2D):
	#print("moveable_block")
	#if from_direction == "left":
		#speed = body.velocity.normalized().x * body.speed
		#direction = Vector2(1, 0)
	#if from_direction == "up":
		#speed = body.velocity.normalized().y * body.speed
		#direction = Vector2(0, 1)
	#if from_direction == "right":
		#speed = body.velocity.normalized().x * body.speed
		#direction = Vector2(1, 0)
	#if from_direction == "down":
		#speed = body.velocity.normalized().y * body.speed
		#direction = Vector2(0, 1)
	##if speed == 0:
		##pass
	##else:
		##return
#
#
#func _on_left_push_area_body_entered(body: Node2D) -> void:
	#if body is Player:
		##speed = body.velocity.normalized().x * body.speed
		##direction = body.velocity.normalized()
		#move("left", body)
#
#
#func _on_up_push_area_body_entered(body: Node2D) -> void:
	#if body is Player:
		##speed = body.velocity.normalized().y * body.speed
		##direction = body.velocity.normalized()
		#move("up", body)
#
#
#func _on_right_push_area_body_entered(body: Node2D) -> void:
	#if body is Player:
		##direction = body.velocity.normalized()
		##speed = body.velocity.normalized().x * body.speed
		#move("right", body)
#
#
#func _on_down_push_area_body_entered(body: Node2D) -> void:
	#if body is Player:
		##direction = body.velocity.normalized()
		##speed = body.velocity.normalized().y * body.speed
		#move("down", body)
