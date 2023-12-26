extends CharacterBody3D

@export var speed: int = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var velocity = Vector3.ZERO # start with zero velocity
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += .05
	if Input.is_action_pressed("ui_left"):
		velocity.x -= .05
	if Input.is_action_pressed("ui_down"):
		velocity.z += .05
	if Input.is_action_pressed("ui_down"):
		velocity.z -= .05
		
	if Input.is_action_pressed("jump"):
		# Handle jumping logic here
		pass
		
	velocity = velocity.normalized() * speed # Normalize for consistent speed so that diagonal movement is not faster
	translate(velocity * delta) # Manually updatee position
	
	# Handle collisions and gravity manually if needed
	
