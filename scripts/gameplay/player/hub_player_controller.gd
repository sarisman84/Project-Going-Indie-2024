extends CharacterBody3D


const SPEED = 5.0

@onready var collider = $collider

@export var model : Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func rotate_model_towards(forwardDir : Vector3):
	if is_equal_approx(forwardDir.length(), 0):
		return
	model.look_at(forwardDir)
	collider.look_at(forwardDir)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	#rotation was too low so I just multiplied it by a high number to get this working
	#direciton needs to be negative since the model is backwards for some reason normally
	rotate_model_towards(-direction * 999)

	move_and_slide()
