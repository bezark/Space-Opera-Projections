extends Node

signal phase_changed
var syncing_datapad = true


func _on_timer_timeout() -> void:
	$FetchGameData.get_game()


var previous_societies_hash = null


func _on_fetch_game_data_game_fetched(game) -> void:
	$Timer.start()
	if game:
		### PHASE ###
		var phase = game.currentPhase
		var new_phase = Phase.new()
		# new_phase.id = phase.id

		new_phase.type = phase.type
		new_phase.status = phase.status
		new_phase.round = phase.round

		new_phase.time.duration = phase.time.duration
		new_phase.time.elapsed = phase.time.elapsed
		new_phase.time.remaining = phase.time.remaining
		new_phase.time.remainingFormatted = phase.time.remainingFormatted

		# 	state.phases[phase.id] = new_phase

		if !State.active_phase:
			phase_changed.emit(new_phase)

		elif new_phase.type != State.active_phase.type:
			phase_changed.emit(new_phase)
		State.active_phase = new_phase

	### SOCIETIES ###

	var societies_hash = game.societies.hash()
	# prints(societies_hash, previous_societies_hash)
	if societies_hash != previous_societies_hash:
		var current_societies = []

		for society in game.societies:
			if not State.societies.has(society.id):
				State.societies[society.id] = Society.new()
			var this_society = State.societies[society.id]
			this_society.title = society.name
			this_society.archetype = State.archetypes[society.archetype]

			print(this_society.title)
			# this_society.communities = {}

			### COMMUNITIES ###

			var current_communities = []
			for community in society.communities:
				# print(community)
				if not this_society.communities.has(community.id):
					if not State.communities.has(community.id):
						this_society.communities[community.id] = Community.new()
					else:
						this_society.communities[community.id] = State.communities[community.id]

				var this_community = this_society.communities[community.id]
				this_community.title = community.name
				this_community.voice = community.voice
				# this_community.resources = {}

				print("- " + this_community.title)

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

					print("-- " + this_resource.title)

					current_resources.append(resource.id)
					State.resources[resource.id] = this_resource

				for key in this_community.resources.keys():
					if not current_resources.has(key):
						this_community.resources.erase(key)

				current_communities.append(community.id)
				State.communities[community.id] = this_community

			for key in this_society.communities.keys():
				if not current_communities.has(key):
					this_society.communities.erase(key)

			current_societies.append(society.id)
		for key in State.societies.keys():
			if not current_societies.has(key):
				State.societies.erase(key)

	previous_societies_hash = societies_hash
	State.save()


func _on_control_datapad_sync_changed(bool: Variant) -> void:
	if bool:
		$Timer.start()
	else:
		$Timer.stop()
