extends KinematicBody2D

onready var animationPlayer:AnimationPlayer = $AnimationPlayer
onready var animationTree: AnimationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var commander:Node = $Commander

signal action_finished

var velocity:Vector2
var max_speed:int = 100
var last_input_direction:Vector2
var commands:Array
	
func _physics_process(delta: float) -> void:
	
	if commands.size() > 0:
		print("there is now a command")
		yield(commands.front().execute(self), "completed")
	else:
		move(delta)
		
	velocity = move_and_slide(velocity)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		var attack_command = AttackCommand.new()
		attack_command.mouse_position = get_local_mouse_position()
		add_command(attack_command)

func get_input() -> Vector2:
	var input_vector:Vector2
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vector.normalized()
	get_local_mouse_position()
	
func move(delta: float) -> void:
	velocity = get_input() * max_speed
	if get_input() != Vector2.ZERO:
		set_animation("Walk", get_input())
		last_input_direction = get_input()
	else:
		set_animation("Idle", last_input_direction)
		
func attack(mouse_position):
	velocity = Vector2.ZERO
	set_animation("Attack", mouse_position)
	
func action_finishde():
	emit_signal("action_finished")
	print("action_finished")
	
func add_command(command: BaseCommand):
	commander.add_child(command)
	commands = commander.get_children()
	
func set_animation(animation_2Dblend_name:String, blend_vector:Vector2) -> void:
	animationState.travel(animation_2Dblend_name)
	animationTree.set("parameters/" + animation_2Dblend_name + "/blend_position", blend_vector)
