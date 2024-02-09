extends Node2D

# Define some constants for the game settings
const SCREEN_WIDTH = 800
const SCREEN_HEIGHT = 600
const PADDLE_SPEED = 300
const BALL_SPEED = 400
const SCORE_LIMIT = 10

# Define some variables for the game objects and the score
var player
var opponent
var ball
var ball_velocity := Vector2.ZERO
var player_score
var opponent_score

func _ready():
	# Create the player paddle and add it to the scene
	player = Node2D.new()
	player.position = Vector2(50, SCREEN_HEIGHT / 2)
	player.scale = Vector2(0.5, 4)
	var player_sprite = Sprite.new()
	player_sprite.texture = load("res://icon.png")
	player.add_child(player_sprite)
	add_child(player)
	
	# Create the opponent paddle and add it to the scene
	opponent = Node2D.new()
	opponent.position = Vector2(SCREEN_WIDTH - 50, SCREEN_HEIGHT / 2)
	opponent.scale = Vector2(0.5, 4)
	var opponent_sprite = Sprite.new()
	opponent_sprite.texture = load("res://icon.png")
	opponent.add_child(opponent_sprite)
	add_child(opponent)
	
	# Create the ball and add it to the scene
	ball = Node2D.new()
	ball.position = Vector2(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	ball.scale = Vector2(0.5, 0.5)
	var ball_sprite = Sprite.new()
	ball_sprite.texture = load("res://icon.png")
	ball.add_child(ball_sprite)
	add_child(ball)
	
	# Initialize the score to zero
	player_score = 0
	opponent_score = 0
	
	# Start the game loop
	set_process(true)
	ball_velocity = Vector2(BALL_SPEED, 0)

func _process(delta):
	# Move the player paddle according to the input
	var input_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	player.position.y += input_y * PADDLE_SPEED * delta
	# Clamp the player paddle position to the screen boundaries
	player.position.y = clamp(player.position.y, player.scale.y * 32, SCREEN_HEIGHT - player.scale.y * 32)
	
	# Move the opponent paddle towards the ball position
	var direction_y = sign(ball.position.y - opponent.position.y)
	opponent.position.y += direction_y * PADDLE_SPEED * delta
	# Clamp the opponent paddle position to the screen boundaries
	opponent.position.y = clamp(opponent.position.y, opponent.scale.y * 32, SCREEN_HEIGHT - opponent.scale.y * 32)
	
	# Move the ball according to its velocity
	ball.position += ball_velocity * delta
	
	# Check for collisions with the paddles
	if ball.position.x < player.position.x + player.scale.x * 32 and abs(ball.position.y - player.position.y) < player.scale.y * 32:
		# The ball hit the player paddle, reflect the velocity and increase the speed
		ball_velocity.x = -ball_velocity.x
		ball_velocity *= 1.1
	elif ball.position.x > opponent.position.x - opponent.scale.x * 32 and abs(ball.position.y - opponent.position.y) < opponent.scale.y * 32:
		# The ball hit the opponent paddle, reflect the velocity and increase the speed
		ball_velocity.x = -ball_velocity.x
		ball_velocity *= 1.1
	
	# Check for collisions with the walls
	if ball.position.y < ball.scale.y * 32 or ball.position.y > SCREEN_HEIGHT - ball.scale.y * 32:
		# The ball hit the top or bottom wall, reflect the velocity
		ball_velocity.y = -ball_velocity.y
	
	# Check for scoring conditions
	if ball.position.x < 0:
		# The ball went past the left edge, the opponent scored
		opponent_score += 1
		reset_ball()
	elif ball.position.x > SCREEN_WIDTH:
		# The ball went past the right edge, the player scored
		player_score += 1
		reset_ball()
	
	# Check for game over conditions
	if player_score == SCORE_LIMIT:
		# The player reached the score limit, the player won
		print("You win!")
		set_process(false)
	elif opponent_score == SCORE_LIMIT:
		# The opponent reached the score limit, the opponent won
		print("You lose!")
		set_process(false)

func reset_ball():
	# Reset the ball position and velocity to the center
	ball.position = Vector2(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	ball_velocity = Vector2(BALL_SPEED, 0)
	# Randomize the ball direction
	if randf() < 0.5:
		ball_velocity.x = -ball_velocity.x
	if randf() < 0.5:
		ball_velocity.y = -ball_velocity.y
