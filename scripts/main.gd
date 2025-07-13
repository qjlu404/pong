extends Node2D

# GIVEN: Ball Velocity, Ball Position, Paddle x position
# FIND : y Paddle Vertical Position 
# y - Py = (Vy/Vx)(x - Px)
# y = (Vy/Vx)(x - Px) + Py
func predict():
	var ballBody = $Ball/RigidBody2D
	var V = ballBody.linear_velocity
	var P = ballBody.global_position
	var paddlePos = $"CPU Paddle".global_position
	var vRatio = V.y/abs(V.x)
	var result = vRatio * (paddlePos.x - P.x) + P.y-50 #-50 so that position is middle of paddl
	return result

func _on_ball_ready():
	var ballBody = $Ball/RigidBody2D
	print("ballReady\n")
	var roll = (-1 if randf() < 0.5 else 1)
	ballBody.linear_velocity = Vector2(roll * 200, float(randi()%400-200))	

func _physics_process(delta):
	if  Input.is_action_pressed("Paddle Up") and $Paddle.global_position.y>0:
		$Paddle.global_position.y -= 200 * delta
	if Input.is_action_pressed("Paddle Down") and $Paddle.global_position.y<540:
		$Paddle.global_position.y += 200 * delta
	var yGoal = predict() + 100
	if $"CPU Paddle".global_position.y < yGoal and $"CPU Paddle".global_position.y < 520:
		$"CPU Paddle".global_position.y += 200*delta
	if $"CPU Paddle".global_position.y > yGoal and $"CPU Paddle".global_position.y > 40:
		$"CPU Paddle".global_position.y -= 200*delta


func _on_paddle_paddle_exit():
	var ballBody = $Ball/RigidBody2D
	print("paddle paddle exit \n")
	ballBody.linear_velocity.y += randf()*400-200 - ballBody.linear_velocity.y
	if randf() < 0.1:
		ballBody.linear_velocity.y += randf()*ballBody.linear_velocity.x*2 - ballBody.linear_velocity.x
	


func _on_left_edge_area_area_entered(area):
	print("left area")


func _on_right_edge_area_area_entered(area):
	print("right area")
