extends CharacterBody2D
var hp: int = 50
var hspd: int = 3
var vspd: int = 200
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var isJumping = false
var walkTimer = false
var waitTimer = false
var res






func leftRight():
	var rng = RandomNumberGenerator.new()
	var walkWait = floor(rng.randf_range(3.0, 6.0))
	if walkTimer == false:
		walkTimer = true
		
		await get_tree().create_timer(walkWait).timeout
		if randi() % 2 == 0:
			res = "left" 
		else:
			res = "right"
		waitTimer = true
		print(res)
		queue_free()
		return res
	if waitTimer == true:
		waitTimer = false
		res = "wait"
		await get_tree().create_timer(walkWait).timeout
		walkTimer = false
		print(res)
		queue_free()
		return res
		
		
		
#func waiting():
#	var rng = RandomNumberGenerator.new()
#	var walkWait = floor(rng.randf_range(1.0, 2.0))
#	if waitTimer == true:
#		waitTimer = false
#		res = "wait"
#		await get_tree().create_timer(walkWait).timeout
#		waitTimer = true
#		print(res)
#		return res
#		queue_free()

func direction(dir):
	if dir == "left":
#		self.position.x -= 20
		velocity.x -= 200
#		print("left")
	if dir == "right":
#		self.position.x += 20
		velocity.x += 200
#		print("right")
		
#func patrol(v):
#	var patrolTimer = Timer.new()
#	patrolTimer.connect("timeout", )
#	patrolTimer.wait_time = 3
#	add_child(patrolTimer)
#	patrolTimer.start()

#
#func _ready():
#	var lR = leftRight()
#	direction(leftRight())

func _physics_process(delta):
	var xpos = self.position.x
	var ypos = self.position.y
	var xprev = xpos
	var yprev = ypos
	var rayUp = $RayUp.get_collision_point()
	var rayDown = $RayDown.get_collision_point()
	var rayLeft = $RayLeft.get_collision_point()
	var rayRight = $RayRight.get_collision_point()
	var yDown = floor(rayDown.y - (ypos + 18))
	var yUp = floor(rayUp.y - (ypos - 7))
	var xRight = floor(rayRight.x - (xpos + 4))
	var xLeft = floor(rayLeft.x - (xpos - 10))
	var dir = await leftRight()
#	var rng = RandomNumberGenerator.new()
#	var randomRange = floor(rng.randf_range(1.0, 11.0))
#
#	var changeDirection = "p"
#	print("Top:", yUp, ", Bottom:", yDown, ", Left:", xLeft, ", Right:", xRight)
#	var ypos = 10
	velocity.x = hspd
	

		
	
	if hspd > 0:
		$AnimatedSprite2D.set_flip_h(false)
		$AnimatedSprite2D.play("walk")
	if hspd < 0:
		$AnimatedSprite2D.set_flip_h(true)
		$AnimatedSprite2D.play("walk")
	if hspd == 0:
		$AnimatedSprite2D.play("idle")
	
	# move right
	if dir == "right":
		if xRight != 0:
			hspd = 50
			if hspd >= 100:
				hspd = 100
		if xRight <= 0 && hspd >= 50:
			hspd = 50

	# move left
	if dir == "left":
		if xLeft != 0:
			hspd = -50
			if hspd <= -100:
				hspd = -100
		if xLeft >= 0 && hspd <= -50:
			hspd = -50
	if dir == "wait":
		hspd = 0

	if isJumping:
		$AnimatedSprite2D.play("jump")
	else:
		if dir == "right" && hspd >= 5 && velocity.y == 0 || dir == "left" && hspd <= -5 && velocity.y == 0:
			$AnimatedSprite2D.play("run")
		else:
			if not isJumping && xLeft == 0 || not isJumping && xRight == 0 || not isJumping && hspd == 0:
				$AnimatedSprite2D.play("idle")
				
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
