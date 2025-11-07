class_name Player
extends CharacterBody2D

#Físicas
@export var max_speed = 150
@export var jump_speed = 200
@export var gravity = 500
@export var acceleration = 1000
var peso: float=1

#Dash
var can_dash: bool=false
var is_dashing: bool=false
var dash_timer: float=0
const dash_dura:= 0.2
const dash_speed:= 500
const dash_cooldown:= 0.5
var dash_cooldown_timer: float=0

#Wall Grab
const wall_jump_pushback = 150
const wall_friction = 35
var is_wall_sliding: bool = false

#Habilidades
var habilidades: Array=[]
const max_habilities:=2
var fusion: Habilidad=null
var fusionadas: Array=[]

#diccionario de combinaciones
var combo={
	"Dash+Grab": "Kick",
	"Dash+Dash": "Super Dash",
	"Grab+Grab": "Wallgrab"
}

#Grab/Kick
var can_grab: bool = false
var can_kick: bool=false
var in_range: bool=false
var holding: Node2D=null
var target_object: Node2D
var throw_force:= 300
var kick_force:= 600

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
@onready var hand_position: Marker2D=$Pivot/Hand_pos
@onready var kick_position: Marker2D=$Pivot/Kick_pos


func _ready() -> void:
	if velocity==null:
		velocity=Vector2.ZERO
	animation_tree.active=false
	playback=animation_tree.get("parameters/playback")
	animation_tree.active=true
	pass

func equipar_habilidad(habilidad:Habilidad):
	if habilidades.size() >= max_habilities:
		var habilidad_a_remover = habilidades[0]
		print("Reemplazando",habilidad_a_remover.nombre,"por",habilidad.nombre)
		remover_habilidad(habilidad_a_remover)
	habilidades.append(habilidad)
	habilidad.aplicar(self)
	if habilidades.size()==2:
		combinar_habilidades()

func tiene_habilidad(nombre_habilidad:String):
	for h in habilidades:
		if h.nombre == nombre_habilidad:
			return true
	return false

func remover_habilidad(habilidad:Habilidad):
	habilidad.remover(self)
	habilidades.erase(habilidad)

func clave_combinacion(nombre1:String,nombre2:String):
	var lista=[nombre1,nombre2]
	lista.sort()
	return lista[0]+"+"+lista[1]

func combinar_habilidades() -> void:
	if habilidades.size()<2:
		return
	var hab1=habilidades[0].nombre
	var hab2=habilidades[1].nombre
	var clave=clave_combinacion(hab1,hab2)
	print("Clave generada:", clave)
	print("Claves disponibles:", combo.keys())
	if combo.has(clave):
		var resultado_nombre=combo[clave]
		print("Combinación encontrada:", hab1, "+", hab2, "=>", resultado_nombre)
		fusion=Habilidad.new()
		fusion.nombre=resultado_nombre
		fusion.aplicar(self)
		fusionadas=[habilidades[0],habilidades[1]]
	else:
		print("❌ No hay combinación para:", clave)

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

func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("bloques"):
		in_range=true
		target_object=body

func _on_range_body_exited(body: Node2D) -> void:
	if body==target_object:
		in_range=false
		target_object=null

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta 
	if (is_on_floor() ) and Input.is_action_just_pressed("jump"): #or not coyote_timer.is_stopped()
		velocity.y = -jump_speed
		was_on_floor = false
	####ESTO ES WALLGRAB####
	
	####ESTO ES WALLGRAB####
	var move_input: float = Input.get_axis("move_left", "move_right")
	if move_input!=0:
		pivot.scale.x=sign(move_input)
	velocity.x = move_toward(velocity.x, move_input * max_speed, acceleration * delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("skill"):
		if fusion!=null:
			match fusion.nombre:
				"Kick":
					print("pateando piedras")
					if holding==null and in_range and target_object and target_object.is_in_group("bloques"):
						var bloque: Bloque=target_object
						if peso>=bloque.peso_bloque:
							holding=bloque
							if holding and holding.is_inside_tree():
								holding.set_held(true)
								holding.velocity=Vector2.ZERO
								print("holding:", holding)
								print("kick_position:", kick_position)
								if tiene_habilidad("Grab"):
									holding.global_position=kick_position.global_position
						else:
							print("Ta pesao!")
					elif holding:
						var direction = Vector2.RIGHT if pivot.scale.x>0 else Vector2.LEFT
						if holding is Bloque:
							holding.set_held(false)
							holding.velocity= direction*kick_force
						holding=null
				"Super Dash":
					print("SUPERMÁXIMAVELOSIDAAAAAAD!!!")
				"Wallgrab":
					print("Puerco Araña")
					if is_on_wall_only() and Input.is_action_pressed("move_right") and Input.is_action_just_pressed("jump"):
						velocity.y = -jump_speed
						velocity.x = -wall_jump_pushback
					if is_on_wall_only() and Input.is_action_pressed("move_left") and Input.is_action_just_pressed("jump"):
						velocity.y = -jump_speed
						velocity.x = wall_jump_pushback
			return
		if tiene_habilidad("Dash"):
			if can_dash:
				start_dash(move_input)
		elif tiene_habilidad("Grab"):# or tiene_habilidad("Kick")
			if holding==null and in_range and target_object and target_object.is_in_group("bloques"):
				var bloque: Bloque=target_object
				if peso>=bloque.peso_bloque:
					holding=bloque
					if holding and holding.is_inside_tree():
						holding.set_held(true)
						holding.velocity=Vector2.ZERO
						print("holding:", holding)
						print("hand_position:", hand_position)
						#print("kick_position:", kick_position)
						if tiene_habilidad("Grab"):
							holding.global_position=hand_position.global_position
						#else:
						#	holding.global_position=kick_position.global_position
				else:
					print("Ta pesao!")
			elif holding:
				var direction = Vector2.RIGHT if pivot.scale.x>0 else Vector2.LEFT
				if holding is Bloque:
					holding.set_held(false)
					holding.velocity= direction*throw_force
				holding=null
	
	if holding:
		if fusion!=null:
			match fusion.nombre:
				"Kick":
					holding.global_position=kick_position.global_position
		else:
			holding.global_position=hand_position.global_position
	
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
			playback.travel("Idle")
			show_sprite(idle)
	else:
		if velocity.y<0:
			playback.travel("jump_up")
			show_sprite(jump)
		else:
			playback.travel("fall")
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

#Daño y muerte
func take_damage(damage):
	print("auch")
	if is_dead:
		return
	is_dead = true
	die()

func die():
	playback.travel("damage")
	show_sprite(damage)
	velocity.y=-300
	set_collision_mask_value(1,false)
	set_collision_mask_value(2,false)

#func _on_death_finished():
#	queue_free()

#func _on_damage_dealt():
#	velocity.y = -jump_speed
#	audio_jump_player.play()



			
#func _on_coyote_timeout():	
#	pass
