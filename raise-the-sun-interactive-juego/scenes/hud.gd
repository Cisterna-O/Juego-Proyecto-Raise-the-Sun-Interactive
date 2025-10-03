extends CanvasLayer

@onready var player= get_tree().get_root().get_node("Main/Player")
@onready var skill_slots = [
	{ "color_rect": $VBoxContainer/HBoxContainer/Skill1/Skill1Color, "label": $VBoxContainer/HBoxContainer/Skill1/Skill1Name },
	{ "color_rect": $VBoxContainer/HBoxContainer/Skill2/Skill2Color, "label": $VBoxContainer/HBoxContainer/Skill2/Skill2Name }
]

var habilidad_colores={
	"Peso": Color(0.8, 0.6, 0.2),
	"Light": Color(0.7, 1.0, 1.0),
	"Dash": Color(1.0, 0.4, 0.4)
}

func _ready() -> void:
	_update_habilidades()
	set_process(true)

func _process(_delta) -> void:
	_update_habilidades()

func _update_habilidades():
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
