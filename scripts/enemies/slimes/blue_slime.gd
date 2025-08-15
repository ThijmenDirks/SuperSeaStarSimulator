extends Slime # please dont forget to fix raycast collision masks !!

#const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var timer_is_already_running = true
#var jump_duration = 1.5 # in sec

#@export var animation_tree : AnimationTree

#@onready var timer = $Timer

func _ready() -> void:
	max_hp= 200
	hp = 200#max_HP
	base_speed = 30
	speed = base_speed
	chase_end_distance = 250
	melee_range = 50
	attack_damage = 2
	angry = false

	jump_hight = 20
	state = STATES.IDLE_WALK
	idle_walk(0, jump_duration, "enter")
	look_for_player_area = $LookForPlayerArea
	#print("slime_", state)
	#state_duration_timer.start(1)
	sprite = $Sprite2D
	loot_table = {
		"green_slimeball" = 50, # %
		"super_legendary_drop" = 0.001,
	}

#func _process(delta: float) -> void:
	#super(delta)

# shouldnt this be in Enemy?
#func _physics_process(delta: float) -> void:
	##super(delta)
	#print("HP ", hp)
	#update_animation_parameters()
	#if state == STATES.JUMP:
		#jump(delta)
	#if state == STATES.IDLE_STAND:
		#if not timer_is_already_running:
			##timer.start(1)
			#pass


func request_change_state(new_state):
	print("slime angry?   ", angry)
	match new_state:
		STATES.CHASE: # might want to make slimes unable to chase adn use jump_attack for it instaed
			if state != STATES.JUMP_ATTACK and angry:
				change_state(STATES.CHASE)
		#STATES.PATHFIND:
			#change_state(STATES.PATHFIND)
		#STATES.IDLE_STAND:
			#change_state(STATES.IDLE_STAND)
		STATES.IDLE_WALK:
			change_state(STATES.IDLE_WALK)
		STATES.JUMP_ATTACK:
			if angry:
				change_state(STATES.JUMP_ATTACK)
		STATES.ATTACK:
			if angry:
				change_state(STATES.JUMP_ATTACK)


func change_state(new_state):
	state_duration_timer.stop()
# right now im changing state here, but might do that in state funcionts self because of on_stae("exit"): state = state.last # i dont think so..
	if state_is_locked:
		return
	state_history.append(state)
	match new_state:
		#STATES.IDLE_STAND:
			#state = STATES.IDLE_STAND
			#idle_stand(randi_range(3, 5), "enter")
		STATES.IDLE_WALK:
			state = STATES.IDLE_WALK
			idle_walk(0, jump_duration, "enter") # the time given here should be the same as N jumps in the animation
		STATES.CHASE:
			state = STATES.CHASE
			chase_state(0, "enter")
		#STATES.PATHFIND:
			#pathfind_state(0, "enter")
			#state = STATES.PATHFIND
		STATES.JUMP_ATTACK:
			state = STATES.JUMP_ATTACK
			jump_attack_state(0, jump_duration, "enter")
