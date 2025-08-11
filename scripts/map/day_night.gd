extends CanvasModulate

@export var start_time := 6.0  # hours
@export var day_length := 150.0  # seconds for a full day cycle

var _time_offset := 0.0

func _ready():
	var _time_offset = (start_time / 24.0) * day_length

func _process(delta):
	var time = fmod(Time.get_ticks_msec() / 1000.0 + _time_offset, day_length)
	var t = sin(time / day_length * PI * 2.0) * 0.5 + 0.5  # normalized 0–1

	# settings night and day colors
	var night_color = Color(0.1, 0.1, 0.3)
	var day_color = Color(1.0, 1.0, 1.0)
	color = night_color.lerp(day_color, t) #yay kijk een lerp (:
