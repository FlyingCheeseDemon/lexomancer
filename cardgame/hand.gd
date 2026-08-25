extends HBoxContainer

class_name Hand

@export_group("Gameplay")
@export var max_hand_size:int = 5

@export_group("Card interaction")
@export var hover_to_peek:bool = true
@export var hover_scaling:float = 1.3

@export_group("Visuals")
@export var standard_spacing:int = -40
@export var arch_angle:float = 0.

var full:bool = false

@onready var max_width:float = self.size.x
var card_boundaries:Array[float] = []
var dummy_card:DummyCard

signal card_dragged_in_hand
signal dummy_card_clicked_in_hand
var card_hovered_over_hand:bool = false

func _process(_delta: float) -> void:
	if card_hovered_over_hand:
		var relative_mouse_position:Vector2 = get_local_mouse_position()
		var hovered_card_slot:int
		var j:int = 0
		for i in range(len(card_boundaries)):
			j = i
			if card_boundaries[i] > relative_mouse_position.x:
				break
		hovered_card_slot = j
		self.move_child(dummy_card,hovered_card_slot)
		
func add_card(card:Card) -> bool:
	if not full:
		var card_obj:CardCtrl = CardCtrl.constructor(card)
		card_obj.hover_to_peak = hover_to_peek
		card_obj.hover_scaling = hover_scaling
		self.add_child(card_obj)
		card_obj.connect("card_drag_start",card_drag_start)
		update_full()
		return true
	else:
		return false
		
func replace_dummy_with_card_ctrl(dummy:DummyCard,card_to_add:CardCtrl) -> void:
	card_to_add.mouse_filter = Control.MOUSE_FILTER_PASS
	card_to_add.connect("card_drag_start",card_drag_start)
	dummy.add_sibling(card_to_add)
	self.hover_card_stop()
		
func remove_card(card:CardCtrl) -> bool:
	if card in self.get_children():
		self.remove_child(card)
		card.disconnect("card_drag_start",card_drag_start)
		return true
	else:
		return false

func drag_card_out(card:CardCtrl) -> bool:
	if remove_card(card):
		hover_card_start()
		return true
	return false

func hover_card_start() -> void:
	card_hovered_over_hand = true
	add_dummy_card()
	self.propagate_hover_to_peek(false)

func add_dummy_card() -> void:
	dummy_card = DummyCard.constructor()
	dummy_card.connect("dummy_clicked",on_dummy_clicked)
	self.add_child(dummy_card)

func hover_card_stop() -> void:
	card_hovered_over_hand = false
	remove_dummy_card()
	self.propagate_hover_to_peek(true)
	
func remove_dummy_card() -> void:
	if dummy_card:
		dummy_card.queue_free()
	dummy_card = null
	
func propagate_hover_to_peek(value:bool) -> void:
	for child in self.get_children():
		if child is CardCtrl:
			child.hover_to_peak = value
			
func card_drag_start(card:CardCtrl ) -> void:
	card_dragged_in_hand.emit(card,self)

func on_dummy_clicked(dummy:DummyCard) -> void:
	dummy_card_clicked_in_hand.emit(dummy,self)

func update_full() -> void:
	if self.get_child_count() >= max_hand_size:
		self.full = true
		
func _ready() -> void:
	sort_children.connect(_on_sort_children)

func _on_sort_children() -> void:
	var children:Array[Node] = self.get_children()
	var amount_children = len(children)
	
	var available_space:float = self.max_width
	var used_space:float = 0.0
	var spacing:float = standard_spacing
	var padding:float = 0.
	for crd:Control in children:
		used_space += crd.size.x
	if used_space + (amount_children-1)*standard_spacing >= available_space: # available space now grows on it's own aagh
		spacing = (available_space-used_space)/(amount_children-1)
	else:
		padding = (available_space-used_space-(amount_children-1)*standard_spacing)/2
	
	var step:float = 2*self.arch_angle/amount_children
	var angles:Array = range(amount_children).map(func(n): return (float(n)-float(amount_children-1)/2)*step)
	
	card_boundaries = []
	var cumulative_x := padding
	for i in range(amount_children):
		var child = children[i]
		# Position child if it is a Control
		var control := child as Control
		if control:
			# Rotate control
			control.pivot_offset.x = control.size.x / 2
			control.pivot_offset.y = control.size.y
			control.rotation_degrees = angles[i]
			# Position control
			var offset = (cumulative_x-available_space/2+control.size.x / 2)*angles[i]/180*PI/2
			control.position = Vector2(cumulative_x, offset)
			cumulative_x += control.size.x + spacing
			card_boundaries.append(cumulative_x)
