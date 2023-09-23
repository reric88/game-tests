extends CharacterBody2D
var hp: int = 50
var hspd: int = 3
var vspd: int = 200
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var walkTimer = false
var waitTimer = false
var res
var xpos
var ypos
var xprev
var yprev
var rayUp
var rayDown
var rayLeft
var rayRight
var yDown
var yUp
var xRight
var xLeft
var rjRight
var rjLeft
var chasing

func _ready():
	set_process(true)

#func _draw():
#	draw_line(Vector2(-8,16), global_position + Vector2(-1500, -3000), Color("green"))
#	draw_line(Vector2(8,16), global_position + Vector2(500, -3000), Color("green"))










func leftRight():
	var rng = RandomNumberGenerator.new()
	var walkWait = floor(rng.randf_range(3.0, 6.0))
	if walkTimer == false:
		walkTimer = true
		await get_tree().create_timer(walkWait).timeout
		if randi() % 2 == 0:
			if xLeft != 0:
				res = "left"
			else:
				res = "right"
		else:
			if xRight != 0:
				res = "right"
			else:
				res = "left"
		waitTimer = true
		print(res)
		return res
	if waitTimer == true:
		waitTimer = false
		res = "wait"
		await get_tree().create_timer(walkWait).timeout
		walkTimer = false
		print(res)
		return res

func _physics_process(delta):
	xpos = self.position.x
	ypos = self.position.y
	xprev = xpos
	yprev = ypos
	rayUp = $RayUp.get_collision_point()
	rayDown = $RayDown.get_collision_point()
	rayLeft = $RayLeft.get_collision_point()
	rayRight = $RayRight.get_collision_point()
	yDown = floor(rayDown.y - (ypos + 18))
	yUp = floor(rayUp.y - (ypos - 7))
	xRight = floor(rayRight.x - (xpos + 4))
	xLeft = floor(rayLeft.x - (xpos - 10))
	rjRight = $RayJumpRight.is_colliding()
	rjLeft = $RayJumpLeft.is_colliding()
	var dir = await leftRight()
	var isJumping = false
	var player = %player2
	var distanceToPlayer = global_position.distance_to(player.position)
#	print("Top:", yUp, ", Bottom:", yDown, ", Left:", xLeft, ", Right:", xRight)
	velocity.x = hspd
	
	if hspd > 0:
		$AnimatedSprite2D.set_flip_h(false)
		$AnimatedSprite2D.play("walk")
	if hspd < 0:
		$AnimatedSprite2D.set_flip_h(true)
		$AnimatedSprite2D.play("walk")
	if hspd == 0:
		$AnimatedSprite2D.play("idle")
	if hspd > 0 && xRight == 0 && isJumping == false:
		hspd = -50	
	if hspd < 0 && xLeft == 0 && isJumping == false:
		hspd = 50
	
	if distanceToPlayer < 100:
		chasing = true
	else:
		chasing = false
	
	if chasing == true:
		if player.position.x < global_position.x:
			hspd = -50
		if player.position.x > global_position.x:
			hspd = 50
			
	if chasing == false:	
		# MOVE RIGHT
		if dir == "right":
			if xRight >= 10:
				hspd = 50
			
		# MOVE LEFT
		if dir == "left":
			if xLeft != 0:
				hspd = -50
				if hspd <= -100:
					hspd = -100
			if xLeft >= 0 && hspd <= -50:
				hspd = -50
#		print(xLeft)
	
	if isJumping == false:
		if yDown == 0:
			if hspd != 0:
				if rjRight == false && xRight < 5:
					isJumping = true
					velocity.y -= 250
					$AnimatedSprite2D.play("jump")
					print("jump")
			
				if rjLeft == false && xLeft > -5:
					isJumping = true
					velocity.y -= 250
					$AnimatedSprite2D.play("jump")
					print("jump")
	
	if yDown > 0 && isJumping == true:
		isJumping = false
		
	# WAITING
	if dir == "wait":
		hspd = 0	

#	if self.position.y >= %player.position.y - 50 || self.position.y <= %player.position.y + 50 && self.position.x 

#	if self.global_position.y - %player2.global_position.y < 50 && self.global_position.x - %player2.global_position.x < 50:
#		chasing = true
#		hspd = 50
#		print("chase left")
#	else:
#		chasing = false
#
#	if %player2.global_position.y - self.global_position.y < 50 && %player2.global_position.x - self.global_position.x < 50:
#		chasing = true
#		hspd = 50
#		print("chase right")
#	else: 
#		chasing = false
				
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
