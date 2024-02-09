extends KinematicBody2D

var speed = 200.0

func _physics_process(delta):
	# Get position and adjust based on speed and delta
	var pos = position
	pos.x += speed * delta
	pos.y -= speed * delta
	position = pos

	# Check for collisions with the scene boundaries
	if pos.x < 0:
		pos.x = 0
		speed *= -1
	if pos.x > get_viewport_rect().size.x:
		pos.x = get_viewport_rect().size.x
		speed *= -1
	if pos.y < 0:
		pos.y = 0
		speed *= -1
	if pos.y > get_viewport_rect().size.y:
		pos.y = get_viewport_rect().size.y
		speed *= -1
