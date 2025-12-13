extends Enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var blink_visible_duration: int = 5
var blink_invisible_duration: int = 3
@onready var blink_timer: Timer = $BlinkTimer

@export var animation_tree : AnimationTree

#@onready var timer = $Timer

func _ready() -> void:
	bounty = 150
	base_speed = 45 # 50 # 45
	speed = base_speed
	look_for_player_area = $LookForPlayerArea
	#timer.start(1)
	attack_damage = 60
	chase_end_distance = 20
	melee_range = 30
	attack_speed = 0.3

	state = STATES.IDLE_STAND
	idle_stand(randi_range(3, 3), "enter") # shuoldnt you just call change_state(IDLE_STAND) ?
	super()


func _physics_process(delta: float) -> void:

	#print("goblin_state: ", state)
	update_animation_parameters()


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
			change_state(STATES.IDLE_STAND)
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
	if velocity == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"] = velocity
	animation_tree["parameters/Walk/blend_position"] = velocity
	animation_tree["parameters/IdleCast/blend_position"] = velocity
	animation_tree["parameters/WalkCast/blend_position"] = velocity


func _on_blink_timer_timeout() -> void:
	print("blink_fey")
	if visible:
		print("blink_fey goes invis")
		visible = false
		blink_timer.start(blink_invisible_duration + randf_range(-2, 2))
	else:
		print("blink_fey goes VIS !")
		visible = true
		blink_timer.start(blink_visible_duration + randf_range(-2, 2))
