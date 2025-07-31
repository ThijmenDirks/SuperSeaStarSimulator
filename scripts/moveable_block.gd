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
@onready var left_space_area = $DownSpaceArea
@onready var down_space_area = $LeftSpaceArea


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("move ", is_moving)
	if is_moving:
		print("move/   position:   ", position, "   movement:   ", direction * delta * move_speed, "   end_pos:  ", position + direction * delta * move_speed)
		position += direction * delta * move_speed
		travelled_distance += abs(direction.length() * delta * move_speed)
		print("moveable_block travelled:   ", travelled_distance, "  position:  ", position)
		if travelled_distance >= grid_width:
			print("movemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemove")
			#print("moveable_block travelled:   ", travelled_distance, "  position:  ", position)
			if direction == Vector2(1, 0):
				position.x -= (travelled_distance - grid_width)
			else:
				position.y -= (travelled_distance - grid_width)
			move_speed = 0
			travelled_distance = 0
			is_moving = false


func move(to_direction: Vector2, speed : int):
	if is_moving:
		return
	# hier nog ff kijken of er wel ruimte is
	
	is_moving = true
	move_speed = speed
	direction = to_direction
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
