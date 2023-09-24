extends CharacterBody2D
var hp: int = 5
var hspd: int = 3
var vspd: int = 200
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var walkTimer = false
var waitTimer = false
var res = "wait"
var xpos
var ypos
var xprev
var yprev
var rayUp
var rayUp2
var rayDown
var rayDown2
var rayLeft
var rayLeft2
var rayRight
var rayRight2
var yDown
var yDown2
var yUp
var yUp2
var xRight
var xRight2
var xLeft
var xLeft2
var rjRight
var rjLeft
var chasing
var contactTimeout
var face

func _ready():
	contactTimeout = false
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
		return res
	if waitTimer == true:
		waitTimer = false
		res = "wait"
		await get_tree().create_timer(walkWait).timeout
		walkTimer = false
		return res
		
func touchTimer():
		await get_tree().create_timer(3).timeout
		contactTimeout = false

func _physics_process(delta):
	xpos = self.position.x
	ypos = self.position.y
	xprev = xpos
	yprev = ypos
	rayUp = $RayUp.get_collision_point()
	rayUp2 = $RayUp2.get_collision_point()
	rayDown = $RayDown.get_collision_point()
	rayDown2 = $RayDown2.get_collision_point()
	rayLeft = $RayLeft.get_collision_point()
	rayLeft2 = $RayLeft2.get_collision_point()
	rayRight = $RayRight.get_collision_point()
	rayRight2 = $RayRight2.get_collision_point()
	yDown = floor(rayDown.y - (ypos + 15))
	yDown2 = floor(rayDown2.y - (ypos + 15))
	yUp = floor(rayUp.y - (ypos - 7))
	yUp2 = floor(rayUp2.y - (ypos - 7))
	xRight = floor(rayRight.x - (xpos + 4))
	xRight2 = floor(rayRight2.x - (xpos + 4))
	xLeft = floor(rayLeft.x - (xpos - 10))
	xLeft2 = floor(rayLeft2.x - (xpos - 10))
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
		face = "right"
	if hspd < 0:
		$AnimatedSprite2D.set_flip_h(true)
		$AnimatedSprite2D.play("walk")
		face = "left"
	if hspd == 0:
		$AnimatedSprite2D.play("idle")
		
	if contactTimeout == false:
		if hspd > 0 && xRight == 0 && isJumping == false:
			hspd = -50	
		if hspd < 0 && xLeft == 0 && isJumping == false:
			hspd = 50
		
		if distanceToPlayer < 200 && %player2.get_collision_layer_value(2) == true:
			chasing = true
		else:
			chasing = false
			contactTimeout = false
			if distanceToPlayer < 200 && %player2.get_collision_layer_value(2) == false:
				hspd = 0
		
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
		
		if isJumping == false:
#			print("yDown: ", yDown, ", player distance: ", distanceToPlayer)
#			print("pinky y: ", self.position.y)
			
			if yDown == 0:
				if hspd != 0:
					#NEED TO FIX THE RAYS SINCE THEY AREN'T ALIGNED ANYMORE
					if rjRight == false && xRight < 5 && $RayRight.get_collider_rid() != %player2.get_rid():
						isJumping = true
						velocity.y -= 250
						$AnimatedSprite2D.play("jump")
#						print("jump")
				
					if rjLeft == false && xLeft > -5 && $RayLeft.get_collider_rid() != %player2.get_rid():
						isJumping = true
						velocity.y -= 250
						$AnimatedSprite2D.play("jump")
#						print("jump")
						
						
		
		if yDown > 0 && isJumping == true:
			isJumping = false
			
		# WAITING
		if dir == "wait":
			hspd = 0	
		
		if $RayDown.get_collider_rid() != %player2.get_rid() && distanceToPlayer < 25 || $RayDown2.get_collider_rid() != %player2.get_rid() && distanceToPlayer < 25:
			print("hit from top")
			isJumping = true
			velocity.y -= 200
			if face == "left":
				hspd = 100
			else:
				hspd = -100
	#		print(distanceToPlayer)

	else: 
		contactTimeout == true
#		hspd = 0
		await touchTimer()
	print(distanceToPlayer)

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
