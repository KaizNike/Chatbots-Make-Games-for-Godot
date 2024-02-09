extends Node2D

var base_color = Color(0.5, 0.5, 0.5)

func _physics_process(delta):
	# Change the background color smoothly
	base_color += Color(0.01, 0.01, 0.01) * delta
	update()
#	set_process_internal(true)

func _draw():
	draw_rect(get_viewport_rect(), base_color)
