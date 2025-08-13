extends HBoxContainer

#@onready var panel1 = $Panel1
#@onready var panel2 = $Panel2
#@onready var panel3 = $Panel3

var all_colors = ["red", "blue", "green", "purple"]
var used_colors = ["red", "green", "blue", "a", "purple"]
var colors_in_bar : Array
var damage_multiplier = 1 # standaarddeviate tretch_ratio en nog iet <- NEE
var mana_recharge_multiplier = 1 # size of stretch_ratio. iets met (sieze / gemiddlede)
var kleurenbalkje_recharge_speed = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("color")
	for color in used_colors:
		add_color(color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for color in colors_in_bar:
		#if (lerp(color.size_flags_stretch_ratio, 1.0, 0.002) - color.size_flags_stretch_ratio) < 0.01:
			#print("kleurkleur")
		#
		if color.size_flags_stretch_ratio != 1.0:
			var growth = lerp(color.size_flags_stretch_ratio, 1.0, 0.01) - color.size_flags_stretch_ratio
			print("kleurkleur growth =  ", growth)
			if growth < 0.001:
				growth = 0.001
				print("kleurkleurMIN")
			color.size_flags_stretch_ratio += growth
			if color.size_flags_stretch_ratio > 1.0:
				color.size_flags_stretch_ratio = 1.0
			print("kleurkleur color.size_flags_stretch_ratio = ", color.size_flags_stretch_ratio)

		
		
		#color.size_flags_stretch_ratio += clampf((lerp(color.size_flags_stretch_ratio, 1.0, 0.002) - color.size_flags_stretch_ratio), 0.01, abs(1-color.size_flags_stretch_ratio))
		#color.size_flags_stretch_ratio += minf((lerp(color.size_flags_stretch_ratio, 1.0, 0.02) - color.size_flags_stretch_ratio), 0.1)
		#if color.size_flags_stretch_ratio > 1.0:
			#color.size_flags_stretch_ratio = 1.0

		#color.size_flags_stretch_ratio = color.size_flags_stretch_ratio.move_toward(1.0, 0.01)
		#color.size_flags_stretch_ratio = color.size_flags_stretch_ratio.move_toward(1.0, 0.001)

		#if color.size_flags_stretch_ratio < 1:
			#print("vee", color)
			#color.size_flags_stretch_ratio *= 1.001
		#if color.size_flags_stretch_ratio > 1:
			#color.size_flags_stretch_ratio = 1
		#print("vee", color)
		#print("vee", colors_in_bar)
		#color.size_flags_stretch_ratio += randf_range(-0.1, 0.1)

		pass
		#print("color", color.size_flags_stretch_ratio)
	var kanstraksweg = []
	for color in colors_in_bar:
		kanstraksweg.append(color.size_flags_stretch_ratio)
	print("kleur", kanstraksweg)
		
	keep_scales_fancy()


func add_color(color):
	var new_panel = Panel.new()
	new_panel.custom_minimum_size = Vector2(10, 10)
	new_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var custom_style = StyleBoxFlat.new()
	var box_color : Color
	match color:
		"red":
			box_color = Color(1, 0, 0, 1)
		"blue":
			box_color = Color(0, 0, 1, 1)
		"green":
			box_color = Color(0, 1, 0, 1)
		"purple":
			box_color = Color(1, 0, 1, 1)

	#custom_style.bg_color = Color(randf_range(0.0,1.0), 0, 0, 1)
	custom_style.bg_color = Color(box_color)
	new_panel.add_theme_stylebox_override("panel", custom_style)

	colors_in_bar.append(new_panel)
	#print(colors_in_bar)
	#print(color, "color")
	self.add_child(new_panel)

# functie die op basis van naam (kleur) alle informtaire van desbetreffend balkje kna halen.
func get_color_bar(color):
	for i in used_colors:
		if i == color:
			return  get_child(used_colors.find(i))
	#return child_by_number()


# aangerpoepen als kleur met scale 1 wordt aangepast. 1. zoek grootste 2. deel alles door grootste 3. maak grootste 1
func keep_scales_fancy():
	var biggest_color : Panel
	var biggest_color_size = 0.0
	for color in colors_in_bar: # find biggest color
		if color.size_flags_stretch_ratio > biggest_color_size:
			biggest_color = color#.size_flags_stretch_ratio
	biggest_color_size = biggest_color.size_flags_stretch_ratio
	for color in colors_in_bar:
		color.size_flags_stretch_ratio /= biggest_color_size
		#print("kleurkleurk", color.size_flags_stretch_ratio)
	biggest_color.size_flags_stretch_ratio = 1
