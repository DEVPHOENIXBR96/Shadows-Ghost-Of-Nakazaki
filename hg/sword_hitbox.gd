# Hitbox.gd
extends Area2D

# ضرر الضربة (تقدر تعدله من المحرر)
@export var damage: int = 25

func _ready():
	# نعطل المنطقة عشان ما تضرب طول الوقت
	monitoring = false  

# هذه الدالة تشتغل لما الهيتبوكس يلمس جسم ثاني (Enemy مثلاً)
func _on_body_entered(body):
	# نتأكد أن الجسم اللي لمسناه يقدر يتلقى ضرر
	if body.has_method("apply_damage"):
		body.apply_damage(damage)


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
