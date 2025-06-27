extends Node

signal phase_changed
var syncing_datapad = true
@export var scene_structure : SceneStructure

func _on_timer_timeout() -> void:
	$FetchGameData.get_game()
	# $FetchPlaylist.get_playlist()


var previous_societies_hash = null


func _on_fetch_game_data_game_fetched(game) -> void:
	$Timer.start()
	if game:
		### PHASEs ###
		var phase_index = 0
		for phase in game.phases[0]:
			# print(phase)

			if State.phases.size()>phase_index:
				State.phases[phase_index].id = phase.id
				State.phases[phase_index].sp_round = phase.round
				State.phases[phase_index].status = phase.status
				State.phases[phase_index].time.elapsed= phase.timeElapsed
				State.phases[phase_index].time.duration= phase.duration
				if State.phases[phase_index].type != phase.type:
					prints(State.phases[phase_index].type ,phase.type)
					State.phases[phase_index].type = phase.type
					State.phases[phase_index].scene_data = scene_structure.scene_data[phase.type]

			else:
				var new_phase = Phase.new()
				new_phase.id = phase.id
				new_phase.type = phase.type
				new_phase.sp_round = phase.round
				new_phase.status = phase.status
				new_phase.scene_data = scene_structure.scene_data[phase.type]
				new_phase.time.elapsed= phase.timeElapsed
				new_phase.time.duration= phase.duration
				State.phases.append(new_phase)

			phase_index += 1

				

		var datapad_currentPhase_id = game.currentPhase.id
		if State.active_phase.id != datapad_currentPhase_id:
			var matches = State.phases.filter(func(elem):
				return elem["id"] == datapad_currentPhase_id
				)
			if matches.size()>0:
				print("phase found")
				print(matches)
				State.active_phase = matches[0]
				phase_changed.emit(State.active_phase)

		State.active_phase.time = game.currentPhase.time

		# var new_phase = Phase.new()
		# new_phase.id = phase.id

		# new_phase.id = phase.id
		# new_phase.type = phase.type
		# new_phase.status = phase.status
		# new_phase.sp_round = phase.round

		# new_phase.time.duration = phase.time.duration
		# new_phase.time.elapsed = phase.time.elapsed
		# new_phase.time.remaining = phase.time.remaining
		# new_phase.time.remainingFormatted = phase.time.remainingFormatted

		# 	state.phases[phase.id] = new_phase

		# if !State.active_phase:
		# 	phase_changed.emit(new_phase)

		# elif new_phase.id != State.active_phase.id:
		# 	phase_changed.emit(new_phase)
		# State.active_phase = new_phase

	### SOCIETIES ###

	var societies_hash = game.societies.hash()
	# prints(societies_hash, previous_societies_hash)
	if societies_hash != previous_societies_hash:
		# State.resources = {}
		State.actions_queued.clear()

		var current_societies = []

		for society in game.societies:
			if not State.societies.has(society.id):
				State.societies[society.id] = Society.new()
			var this_society = State.societies[society.id]
			# this_society.title = society.name
			this_society.archetype = State.archetypes[society.archetype]
			this_society.turn.risk = society.turn.risk
			this_society.turn.advantage = society.turn.advantage
			this_society.turn.disadvantage = society.turn.disadvantage

			# print(this_society.title)

			# this_society.communities = {}

			### COMMUNITIES ###

			var current_communities = []
			for community in society.communities:
				#print(community)
				if not this_society.communities.has(community.id):
					if not State.communities.has(community.id):
						this_society.communities[community.id] = Community.new()
					else:
						this_society.communities[community.id] = State.communities[community.id]

				var this_community = this_society.communities[community.id]
				this_community.title = community.name
				if community.has("voice"):
					this_community.voice = community.voice
				# this_community.resources = {}

				# print("- " + this_community.title)

				### RESOURCES ###

				var current_resources = []
				for resource in community.resources:
					if not this_community.resources.has(resource.id):
						if not State.resources.has(resource.id):
							this_community.resources[resource.id] = SPResource.new()
						else:
							this_community.resources[resource.id] = State.resources[resource.id]

					var this_resource = this_community.resources[resource.id]
					this_resource.title = resource.name
					#this_resource.vital = resource.vital
					this_resource.exhausted = resource.exhausted

					# print("-- " + this_resource.title)

					current_resources.append(resource.id)
					State.resources.set(resource.id, this_resource)

				for key in this_community.resources.keys():
					if not current_resources.has(key):
						this_community.resources.erase(key)

				current_communities.append(community.id)
				State.communities[community.id] = this_community

			for key in this_society.communities.keys():
				if not current_communities.has(key):
					this_society.communities.erase(key)

			current_societies.append(society.id)

			### ACTIONS ###

			# prints(this_society.actions.size(), society.actions.size())
			print(society.actions)
			this_society.actions.clear()


			var action_to_push : SocietyAction
			for action in society.actions:
				# print(action)
				var new_action = SocietyAction.new()
				new_action.game_round = action.round
				new_action.voted = action.voted
				if new_action.voted:
					new_action.voteTime = Time.get_unix_time_from_datetime_string(action.voteTime)

				new_action.parent_society = society.id

			
				for component in action.components:
					var new_component = SocietyActionComponent.new()
					new_component.text = component.text
					new_component.statement = component.statement
					new_component.spresource = State.resources[component.resource.id]
					new_action.components.append(new_component)



				
				if new_action.voted and new_action.components.size():
					# print(new_action.components[0].statement)
					if State.active_phase.sp_round == new_action.game_round:
						action_to_push = new_action
						var previous_actions_from_society = State.actions_queued.filter(func(elem):
							return elem["parent_society"] == action_to_push.parent_society
						)
						for prev_action in previous_actions_from_society:
							# print(prev_action)

							if prev_action.voteTime < action_to_push.voteTime and prev_action.parent_society == action_to_push.parent_society:
								State.actions_queued.erase(prev_action)
						State.actions_queued.append(action_to_push)

						# if !State.actions_queued.has(action_to_push):
							# State.actions_queued.append(action_to_push)
							# print(new_action.components[0].statement)

				this_society.actions.append(new_action)


		State.actions_queued.sort_custom(func(a,b):
			if a.voteTime < b.voteTime:
				return true
			return false
		)

		for action in State.actions_queued:
			print(action.components[0].text)
		for key in State.societies.keys():
			if not current_societies.has(key):
				State.societies.erase(key)

	previous_societies_hash = societies_hash
	# State.save()

func _on_control_datapad_sync_changed(bool: Variant) -> void:
	if bool:
		$Timer.start()
	else:
		$Timer.stop()


var previous_phase_keys = null


# func _on_fetch_playlist_playlist_fetched(playlist) -> void:
# 	var current_hash = playlist.hash()
# 	if previous_phase_keys != current_hash:
# 		print("Playlist hash changed")
# 		State.phases = []
# 		previous_phase_keys = current_hash

# 		for phase in playlist:
# 			#print(phase)
# 			# if State.phases.has(phase.id):
# 			# 	return
# 			#TODO: make this edit existing phases instead of just creating new ones
# 			var new_phase = Phase.new()
# 			new_phase.id = phase.id
# 			new_phase.type = phase.type
# 			new_phase.sp_round = phase.round
# 			new_phase.status = phase.status
# 			new_phase.scene_data = scene_structure.scene_data[phase.type]
# 			# new_phase.time = phase.time
# 			State.phases.append(new_phase)
# 			State.save()


func _on_save_timer_timeout() -> void:
	State.save()
