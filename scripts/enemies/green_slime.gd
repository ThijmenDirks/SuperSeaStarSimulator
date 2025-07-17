extends Slime

#const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var timer_is_already_running = true
var jump_duration = 1.0 # in sec

@export var animation_tree : AnimationTree

@onready var timer = $Timer


func _ready() -> void:
	max_hp= 200
	hp = 200#max_HP
	speed = 50
	jump_hight = 20
	state = STATES.IDLE_WALK
	look_for_player_area = $LookForPlayerArea
	print("slime_", state)
	timer.start(1)
	sprite = $Sprite2D
	loot_table = {
		"green_slime" = 50, # %
		"super_legendary_drop" = 0.001,
	}

#func _process(delta: float) -> void:
	#super(delta)

# shouldnt this be in Enemy?
func _physics_process(delta: float) -> void:
	#super(delta)
	print("HP ", hp)
	update_animation_parameters()
	if state == STATES.JUMP:
		jump(delta)
	if state == STATES.IDLE_STAND:
		if not timer_is_already_running:
			#timer.start(1)
			pass


func change_state():
	if state == STATES.IDLE_STAND:
		state = STATES.JUMP
		#walk()
		#jump(0.0)
		print("slime_jumpp")
		timer.start(jump_duration)
		var direction_angle = randf_range(0.0, TAU) # TAU = 2 * PI
		direction = Vector2(cos(direction_angle), sin(direction_angle)).normalized()
		#velocity = direction * speed
		velocity = Vector2(cos(direction_angle), sin(direction_angle)) * speed
		velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * speed


	elif state == STATES.IDLE_WALK:
		state = STATES.IDLE_STAND
		print("WARNING! SOMETHING GOES WRONG")
		#idle() # ?
	elif state == STATES.JUMP:
		state = STATES.IDLE_STAND
		timer.start(3)


func update_animation_parameters():
	if velocity == Vector2.ZERO:
		return
	print("slime ", animation_tree["parameters/Walk/blend_position"], " ", velocity)
	animation_tree["parameters/Idle/blend_position"] = velocity
	animation_tree["parameters/Walk/blend_position"] = velocity
	animation_tree["parameters/IdleCast/blend_position"] = velocity
	animation_tree["parameters/WalkCast/blend_position"] = velocity


func _on_timer_timeout() -> void:
	print("slime_timout")
	change_state()
#---
	#if state == IDLE:
		#state = JUMP
		## NOT timer.start(1). dat wordt al gedaan in change_state()
	#if state == JUMP:
		#state = IDLE
#---
	#state = JUMP_ATTACK
	#var direction_angle = randf_range(0.0, TAU) # TAU = 2 * PI
	#direction = Vector2(cos(direction_angle), sin(direction_angle)).normalized()   #Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	##destination = position + direction * 100
	#jump_distance = 100
	##jump()
	##timer.start(randi_range(1,5)) # dit moet eigenlijk in WALK, IDLE, ETC
	#timer_is_already_running = false
	#timer.start(2)
	##ground_position.x = position.x
	#ground_position = position

# snijpunt van z = 0 y en z = 0.7 y + b
# y = (z - b)/0.7
# z = 0.7 * y + b
# door (y, z)
#      (7, 2)
# b = z - 0.7 y

# y = (z - b)/0.7
# y = (z -z + 0.7 y)/0.7


# slime.z = 2
# slime.y = 7
# -> b = -2.9
# z = 0.7y -2.9
# y = (2 + 2.9)/0.7  <-
# y = (2 + (-2 + 0.7 * 7))/0.7
# y = (z + (0.7 * y - z))/0.7

# y = (z + (0.7 * y - z))/0.7
