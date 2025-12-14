extends Enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dart_cooldown: float = randf_range(1.0, 2.5)
var dart_minimum_distance: int = 30
var dart_maximum_distance: int = 70
var dart_tries: int = 8

@onready var dart_timer: Timer = $DartTimer
@onready var dart_ray_cast: RayCast2D = $DartRayCast2D


#@export var animation_tree : AnimationTree

#@onready var timer = $Timer

func _ready() -> void:
	bounty = 30
	base_speed = 60 # 50 # 45
	speed = base_speed
	look_for_player_area = $LookForPlayerArea
	#timer.start(1)
	attack_damage = 5
	chase_end_distance = 20
	melee_range = 30
	attack_speed = 0.1

	max_hp = 50
	hp = max_hp

	state = STATES.IDLE_STAND
	idle_stand(randi_range(3, 3), "enter") # shuoldnt you just call change_state(IDLE_STAND) ?
	super()


func _physics_process(delta: float) -> void:

	#print("goblin_state: ", state)
	#update_animation_parameters() # dart_fey doesnt use complicated animations
	pass


func on_something_in_vision_field(bodies : Array):
	if player_in_vision_field:
		chase_target = player_in_vision_field
		#for body in bodies:
			#if body is Player:
				#chase_target = body
		request_change_state(STATES.CHASE)


func request_change_state(new_state):
	match new_state:
		STATES.CHASE:
			change_state(STATES.CHASE)
		STATES.PATHFIND:
			change_state(STATES.PATHFIND)
		STATES.IDLE_STAND:
			change_state(STATES.IDLE_WALK)
		STATES.IDLE_WALK:
			change_state(STATES.IDLE_WALK)
		STATES.MELEE_ATTACK:
			change_state(STATES.MELEE_ATTACK)
		STATES.ATTACK:
			change_state(STATES.MELEE_ATTACK)


func change_state(new_state):
	state_duration_timer.stop()
# right now im changing state here, but might do that in state funcionts self because of on_stae("exit"): state = state.last # i dont think so..
	if state_is_locked:
		return
	state_history.append(state)
	match new_state:
		STATES.IDLE_STAND:
			state = STATES.IDLE_STAND
			idle_stand(randi_range(3, 5), "enter")
		STATES.IDLE_WALK:
			state = STATES.IDLE_WALK
			idle_walk(0, randi_range(3, 5), "enter")
		STATES.CHASE:
			state = STATES.CHASE
			chase_state(0, "enter")
		STATES.PATHFIND:
			pathfind_state(0, "enter")
			state = STATES.PATHFIND
		STATES.MELEE_ATTACK:
			melee_attack_state(0, "enter")
			state = STATES.MELEE_ATTACK


func update_animation_parameters():
	pass # dart_fey doesnt use complicated animations
	#if velocity == Vector2.ZERO:
		#return
	#animation_tree["parameters/Idle/blend_position"] = velocity
	#animation_tree["parameters/Walk/blend_position"] = velocity
	#animation_tree["parameters/IdleCast/blend_position"] = velocity
	#animation_tree["parameters/WalkCast/blend_position"] = velocity


func _on_dart_timer_timeout() -> void:
	dart()


func dart():
	#print("dart_fey starts darting")
	var tries: int = 0
	for try in dart_tries:
		#print("dart_fey tries a dart: ", try)
		try += 1
		var dart_distance = randi_range(dart_minimum_distance, dart_maximum_distance)
		var angle = randf_range(0, TAU)
		var dart_target_position: Vector2 = position + Vector2(cos(angle), sin(angle)) * dart_distance
		dart_ray_cast.target_position = dart_target_position
		dart_ray_cast.force_raycast_update()
		if not dart_ray_cast.is_colliding():
			#print("dart_fey succesfully darts !")
			position = dart_target_position
			return
	dart_cooldown = randf_range(2, 4)
