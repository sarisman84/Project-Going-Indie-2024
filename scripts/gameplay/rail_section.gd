extends Path3D

@export var hitbox : Area3D

var isPlayerDetected : bool
var playerDirection : float
var player : PlayerController


func _ready():
	hitbox.connect("body_entered", _on_hitbox_body_entered)
	hitbox.connect("body_exited", _on_hitbox_body_exited)

		
func _physics_process(delta):
	if not isPlayerDetected:
		return
	var offset = get_closest_offset(player.position)
	var pos = curve.sample_baked(offset, true)
	
	var playerDir = player.velocity.normalized()
	
	var forward = pos.direction_to(curve.sample_baked(offset + playerDirection, true))
	DebugDraw3D.draw_arrow(player.position, player.position + forward,Color.BLUE,0.15)
	var up = curve.sample_baked_up_vector(offset, true)
	
	if forward == Vector3.ZERO:
		_on_hitbox_body_exited(player)
		return
	
	player.velocity = forward * player.get_current_speed()
	player.basis.y = up
	player.move_and_slide()
	
# Assuming the player is masked to layer 2,
# it should only detect the player
func _on_hitbox_body_entered(body):
	player = body as PlayerController
	
	if player.currentState == PlayerController.States.Grinding:
		return
	player.currentState = PlayerController.States.Grinding
	
	var offset = get_closest_offset(player.position)
	var railPos = curve.sample_baked(offset, true)
	var playerHeight = Vector3.UP * player.scale.y
	player.position = railPos + position + playerHeight
	

	DebugDraw3D.draw_sphere(player.position,0.15,Color.CYAN,1.0)
	
	player.set_default_controls(false)
	isPlayerDetected = true
	
	var endingRailPos = position + curve.get_point_position(get_next_closest_point_index(player.position))
	DebugDraw3D.draw_sphere(endingRailPos, 0.15, Color.RED, 1.0)
	
	var dirToEnd = (endingRailPos - player.position).normalized()
	
	var playerVelDir = player.velocity.normalized()
	
	DebugDraw3D.draw_arrow(player.position, player.position + playerVelDir,Color.GREEN,0.15, 1,10.0)
	DebugDraw3D.draw_arrow(player.position, player.position + dirToEnd,Color.MAGENTA,0.15, 1,10.0)
	
	if playerVelDir.dot(dirToEnd) > 0.9:
		playerDirection = 0.1
	else:
		playerDirection = -0.1
		


# Same as above!
func _on_hitbox_body_exited(body):
	player = body as PlayerController
	player.basis.y = Vector3.UP
	isPlayerDetected = false
	player.set_default_controls(true)

func get_closest_offset(globalPosition : Vector3):
	var localPosition = globalPosition - position
	return curve.get_closest_offset(localPosition)

func get_closest_point_index(globalPosition : Vector3):
	var minDist = 1.79769e308
	var result : int
	for i in range(0, curve.point_count):
		var pointPos = position + curve.get_point_position(i)
		var dist = (pointPos - globalPosition).length()
		if minDist > dist:
			minDist = dist
			result = i
	return result

func get_next_closest_point_index(globalPosition : Vector3):
	var closestPoint  = min(get_closest_point_index(globalPosition) + 1, curve.point_count - 1)
	return closestPoint

