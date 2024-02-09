extends Node2D

# Player properties
var player_speed = 200
var player_size = Vector2(64, 64)
var player = null

# Enemy properties
var enemy_speed = 100
var enemy_size = Vector2(64, 64)
var enemies = []

func _ready():
	# Create player
	player = Sprite.new()
	var player_texture = preload("res://icon.png")
	player.texture = player_texture
	player.position = Vector2(100, 100)
	add_child(player)

	# Create enemies
	for i in range(5):
		var enemy = Sprite.new()
		var enemy_texture = preload("res://icon.png")
		enemy.texture = enemy_texture
		enemy.position = Vector2(randi() % int(get_viewport_rect().size.x), randi() % int(get_viewport_rect().size.y))
		add_child(enemy)
		enemies.append(enemy)

func _process(delta):
	# Player movement
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	player.position += input_vector.normalized() * player_speed * delta

	# Enemy movement
	for enemy in enemies:
		var direction = (player.position - enemy.position).normalized()
		enemy.position += direction * enemy_speed * delta

	# Check collision
	for enemy in enemies:
		var player_rect = Rect2(player.position - player_size / 2, player_size)
		var enemy_rect = Rect2(enemy.position - enemy_size / 2, enemy_size)
		if player_rect.intersects(enemy_rect):
			get_tree().reload_current_scene()
