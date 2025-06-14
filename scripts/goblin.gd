extends Enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var animation_tree : AnimationTree

@onready var timer = $Timer
#@onready vision_field = $VisionField

func _ready() -> void:
	speed = 50
	state = IDLE
	look_for_player_area = $LookForPlayerArea
	#vision_field = $VisionField # now in enemy_class_definition
	timer.start(1)


func _physics_process(delta: float) -> void:
	update_animation_parameters()


func change_state():
	if state == IDLE:
		state = WALK
		walk()
		rotate_vision_field()
		timer.start(3)
	elif state == WALK:
		state = IDLE
		idle() # ?
		timer.start(2)


func update_animation_parameters():
	if velocity == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"] = velocity
	animation_tree["parameters/Walk/blend_position"] = velocity
	animation_tree["parameters/IdleCast/blend_position"] = velocity
	animation_tree["parameters/WalkCast/blend_position"] = velocity


func _on_timer_timeout() -> void:
	change_state()
	#timer.start(randi_range(1,5)) # dit moet eigenlijk in WALK, IDLE, ETC
