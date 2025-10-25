class_name Player
extends CharacterBody2D

@export var max_speed = 200
@export var jump_speed = 200
@export var gravity = 500
@export var acceleration = 1000
var peso: float=1
var can_dash: bool=false
var is_dashing: bool=false
var dash_timer: float=0
const dash_dura:= 0.2
const dash_speed:= 500
const dash_cooldown:= 0.5
var dash_cooldown_timer: float=0

const wall_jump_pushback = 150
const wall_friction = 35
var is_wall_sliding: bool = false

var habilidades: Array=[]
const max_habilities:=2

var was_on_floor = false
var is_dead := false

@onready var pivot: Node2D = $Pivot
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var idle: Sprite2D=$Pivot/Idle
@onready var walk: Sprite2D=$Pivot/Walk
@onready var jump: Sprite2D=$Pivot/Jump
@onready var fall: Sprite2D=$Pivot/Fall
@onready var dash: Sprite2D=$Pivot/Dash
@onready var damage: Sprite2D=$Pivot/Hurt
@onready var animation_player: AnimationPlayer=$AnimationPlayer
@onready var animation_tree: AnimationTree=$AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback


func _ready() -> void:
	animation_tree.active=true
	playback=animation_tree.get("parameters/playback")
	pass

func equipar_habilidad(habilidad:Habilidad):
	for h in habilidades:
		if h.nombre == habilidad.nombre:
			print("Ya tienes esta habilidad",h.nombre)
			return
	if habilidades.size() >= max_habilities:
		var habilidad_a_remover = habilidades[0]
		print("Reemplazando",habilidad_a_remover.nombre,"por",habilidad.nombre)
		remover_habilidad(habilidad_a_remover)
	habilidades.append(habilidad)
	habilidad.aplicar(self)

func remover_habilidad(habilidad:Habilidad):
	habilidad.remover(self)
	habilidades.erase(habilidad)

func tiene_habilidad(nombre_habilidad:String):
	for h in habilidades:
		if h.nombre == nombre_habilidad:
			return true
	return false

func start_dash(move_input:float):
	is_dashing=true
	dash_timer=dash_dura
	can_dash=false
	
	#Dirección del dash
	var direction= sign(move_input)
	if direction==0:
		direction=sign(pivot.scale.x)
	velocity.x=direction*dash_speed

func show_sprite(active_sprite: Sprite2D) -> void:
	var sprites = [idle, walk, jump, damage, dash, fall]
	for s in sprites:
		s.visible=(s==active_sprite)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta 
	if (is_on_floor() ) and Input.is_action_just_pressed("jump"): #or not coyote_timer.is_stopped()
		velocity.y = -jump_speed
		was_on_floor = false
	####ESTO ES WALLGRAB####
	if is_on_wall_only() and Input.is_action_pressed("move_right") and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
		velocity.x = -wall_jump_pushback
	if is_on_wall_only() and Input.is_action_pressed("move_left") and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
		velocity.x = wall_jump_pushback
	####ESTO ES WALLGRAB####
	var move_input: float = Input.get_axis("move_left", "move_right")
	if move_input!=0:
		pivot.scale.x=sign(move_input)
	velocity.x = move_toward(velocity.x, move_input * max_speed, acceleration * delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("skill") and can_dash and tiene_habilidad("Dash"):
		start_dash(move_input)
	if is_dashing:
		dash_timer-=delta
		if dash_timer<=0:
			is_dashing=false
			dash_cooldown_timer=dash_cooldown
			
	if not can_dash:
		if dash_cooldown_timer>0:
			dash_cooldown_timer-=delta
		else:
			can_dash=true
	wall_slide(delta)
	#if ray_cast_2d.is_colliding():
		
	#if was_on_floor and not is_on_floor():
	#	coyote_timer.start()
	#if is_on_floor():
	#	coyote_timer.stop()
	was_on_floor = is_on_floor()
	
	#animation
	if move_input:
		pivot.scale.x=sign(move_input)
	if is_on_floor():
		if move_input or abs(velocity.x)>10:
			playback.travel("walk")
			show_sprite(walk)
		else:
			playback.travel("idle")
			show_sprite(idle)
	else:
		if velocity.y<0:
			playback.travel("jump_up")
			show_sprite(jump)
		else:
			playback.travel("drop")
			show_sprite(fall)

#func take_damage(damage):
#	if is_dead: return
#	is_dead = true

#	sprite.visible = false
#	collision_main.disabled = true
#	collision_hitbox.disabled = true
#	collision_hurtbox.disabled = true

#	audio_death_player.play()
#	audio_death_player.finished.connect(_on_death_finished, CONNECT_ONE_SHOT)
#########WALL SLIDE ######
func wall_slide(delta):
	var move_input = Input.get_axis("move_left", "move_right")
	if not is_on_floor() and is_on_wall():
		var facing_dir = sign(pivot.scale.x)
		var holding_toward = (move_input * facing_dir) > 0.1
		is_wall_sliding = holding_toward
	else:
		is_wall_sliding = false

	if is_wall_sliding:
		velocity.y = min(velocity.y, wall_friction)
#########WALL SLIDE ######

func _on_death_finished():
	queue_free()

func _on_damage_dealt():
	velocity.y = -jump_speed
#	audio_jump_player.play()



			
func _on_coyote_timeout():	
	pass
