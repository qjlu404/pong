extends Node2D

# GIVEN: Ball Velocity, Ball Position, Paddle x position
# FIND : Ball's Y(paddle x)
# y - Py = (Vy/Vx)(x - Px)
# y = (Vy/Vx)(x - Px) + Py

func predict():
	var ballBody = $Game/Ball/RigidBody2D
	if !ballBody: return 1
	var V = ballBody.linear_velocity
	var P = ballBody.global_position
	var paddlePos = $Game/"CPU Paddle".global_position
	var vRatio = V.y/abs(V.x)
	var result = vRatio * (paddlePos.x - P.x) + P.y-50 #-50 so that position is middle of paddl
	return result

func _on_ball_ready():
	var ballBody = $Game/Ball/RigidBody2D
	print("ballReady\n")
	$Game/Ball.position = Vector2(318,188)
	var roll = (-1 if randf() < 0.5 else 1)
	ballBody.linear_velocity = Vector2(roll * 200, float(randi()%400-200))	

func _physics_process(delta):
	if  Input.is_action_pressed("Paddle Up") and $Game/Paddle.global_position.y>0:
		$Game/Paddle.global_position.y -= 200 * delta
	if Input.is_action_pressed("Paddle Down") and $Game/Paddle.global_position.y<430:
		$Game/Paddle.global_position.y += 200 * delta
	var yGoal = predict() + 70
	if $Game/"CPU Paddle".global_position.y < yGoal and $Game/"CPU Paddle".global_position.y < 480:
		$Game/"CPU Paddle".global_position.y += 200*delta
	if $Game/"CPU Paddle".global_position.y > yGoal and $Game/"CPU Paddle".global_position.y > 50:
		$Game/"CPU Paddle".global_position.y -= 200*delta


func _on_paddle_paddle_exit(): #Both Paddles 
	var ballBody = $Game/Ball/RigidBody2D
	print("paddle paddle exit \n")
	ballBody.linear_velocity.y += randf()*400-200 - ballBody.linear_velocity.y
	if randf() < 0.1:
		ballBody.linear_velocity.y += randf()*ballBody.linear_velocity.x*2 - ballBody.linear_velocity.x
	


func _on_left_edge_area_area_entered(area):
	print("left area")
	$Game.visible = false
	$UserInterface/DeathScreen.setEndScreen("GameOver")
	$UserInterface/DeathScreen.visible = true
	get_tree().paused=true


func _on_right_edge_area_area_entered(area):
	print("right area")
	$Game.visible = false
	$UserInterface/DeathScreen.setEndScreen("You Win!")
	$UserInterface/DeathScreen.visible = true
	get_tree().paused=true


func _on_death_screen_restart():
	print("Restart!")
	var ball_instance = $Game/Ball
	if ball_instance:
		ball_instance.queue_free()
	await get_tree().process_frame
	ball_instance = preload("res://Scenes/ball.tscn").instantiate()
	$Game.add_child(ball_instance)
	_on_ball_ready()
	$Game/Ball.position = Vector2(318,188)
	$UserInterface/PlayerScoreCount.reset()
	$UserInterface/CPUScoreCount.reset()
	$UserInterface/DeathScreen.visible = 0
	$Game.visible = 1
	get_tree().paused = false


func _on_cpu_paddle_paddle_exit(): #cpu Paddle only
	$Game/"CPU Paddle"/CpuPaddleSound.play()
	$UserInterface/CPUScoreCount.increase()


func _on_player_paddle_paddle_exit(): #player Paddle Only
	$Game/Paddle/PaddleSound.play()
	$UserInterface/PlayerScoreCount.increase()
