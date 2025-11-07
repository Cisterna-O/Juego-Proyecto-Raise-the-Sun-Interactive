extends CanvasLayer

@onready var player: Player=null
@onready var skill_slots = [
	{ "color_rect": $VBoxContainer/HBoxContainer/Skill1/Skill1Color, "label": $VBoxContainer/HBoxContainer/Skill1/Skill1Name },
	{ "color_rect": $VBoxContainer/HBoxContainer/Skill2/Skill2Color, "label": $VBoxContainer/HBoxContainer/Skill2/Skill2Name }
]

var habilidad_colores={
	"Peso": Color(0.8, 0.6, 0.2),
	"Light": Color(0.7, 1.0, 1.0),
	"Dash": Color(1.0, 0.4, 0.4),
	"Grab": Color(.1,1,.05)
	}

func _ready() -> void:
	await get_tree().process_frame
	player= get_tree().get_root().get_node("Main/Player")
	if player==null:
		print("HUD: No se encontró el player en el main")
	else:
		print("HUD:player encontrado")
	_update_habilidades()
	set_process(true)

func _process(_delta) -> void:
	if player:
		_update_habilidades()

func _update_habilidades():
	if player==null:
		return
	for i in range(skill_slots.size()):
		if i<player.habilidades.size():
			var hab = player.habilidades[i]
			skill_slots[i]["color_rect"].color = habilidad_colores.get(hab.nombre, Color.WHITE)
			skill_slots[i]["label"].text = hab.nombre
			skill_slots[i]["color_rect"].visible = true
			skill_slots[i]["label"].visible = true
		else:
			skill_slots[i]["color_rect"].visible = false
			skill_slots[i]["label"].visible = false
