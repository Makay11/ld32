class EnemyManager
	constructor: (@renderer, @scene) ->
		@liveEnemies = []

		@enemyPool =
			c69:
				grey: []
				golden: []
				red: []
				purple: []
			minibot:
				green: []
				grey: []
				blue: []
				golden: []
				red: []
				purple: []

		@probabilities =
			c69:
				any: 0.4				# 0.4
				colors:
					grey: 0.5			# 0.5
					red: 0.8			# 0.3
					purple: 0.95	# 0.15
					golden: 1			# 0.05
			minibot:
				any: 1					# 0.6
				colors:
					green: 0.1    # 0.1
					grey: 0.5     # 0.4
					blue: 0.6     # 0.1
					red: 0.8      # 0.2
					purple: 0.95  # 0.15
					golden: 1     # 0.5

		@nextSpawn = 0

	render: (camera) ->
		for enemy in @liveEnemies
			enemy.render(camera)

	update: (delta, player, camera) ->
		for enemy, index in @liveEnemies
			if not enemy.collided and enemy.mesh.position.y > 0
				canCollide = true

			enemy.update(delta)

			if canCollide and enemy.mesh.position.y < 0.2
				enemyX = enemy.mesh.position.x
				playerX = player.mesh.position.x
				if enemyX - enemy.width / 2 <= playerX + player.width / 2 and playerX - player.width / 2 <= enemyX + enemy.width / 2
					enemy.collided = true
					console.log "ded"

			if enemy.mesh.position.y <= camera.position.y
				enemyDied = true
				@liveEnemies[index] = null
				@stashEnemy(enemy)

		if enemyDied
			@liveEnemies = @liveEnemies.filter (o) -> !!o

		@handleSpawn(delta)

	handleSpawn: (delta) ->
		@nextSpawn -= delta or 0
		if @nextSpawn <= 0
			@nextSpawn = @generateNextSpawn()
			@spawnEnemy()

	generateNextSpawn: -> (Math.random() * 1.5 + 0.5) * 1000 // 1

	spawnEnemy: ->
		r = Math.random()

		if r <= @probabilities.c69.any
			r = Math.random()
			colors = @probabilities.c69.colors

			if r <= colors.grey
				enemy = @enemyPool.c69.grey.pop() or new C69(@renderer, "grey")
			else if r <= colors.red
				enemy = @enemyPool.c69.red.pop() or new C69(@renderer, "red")
			else if r <= colors.purple
				enemy = @enemyPool.c69.purple.pop() or new C69(@renderer, "purple")
			else if r <= colors.golden
				enemy = @enemyPool.c69.golden.pop() or new C69(@renderer, "golden")
		else if r <= @probabilities.minibot.any
			r = Math.random()
			colors = @probabilities.minibot.colors

			if r <= colors.green
				enemy = @enemyPool.minibot.green.pop() or new Minibot(@renderer, "green")
			else if r <= colors.grey
				enemy = @enemyPool.minibot.grey.pop() or new Minibot(@renderer, "grey")
			else if r <= colors.blue
				enemy = @enemyPool.minibot.blue.pop() or new Minibot(@renderer, "blue")
			else if r <= colors.red
				enemy = @enemyPool.minibot.red.pop() or new Minibot(@renderer, "red")
			else if r <= colors.purple
				enemy = @enemyPool.minibot.purple.pop() or new Minibot(@renderer, "purple")
			else if r <= colors.golden
				enemy = @enemyPool.minibot.golden.pop() or new Minibot(@renderer, "golden")

		@liveEnemies.push(enemy)
		@scene.add(enemy.mesh)

	stashEnemy: (enemy) ->
		@scene.remove(enemy.mesh)
		@enemyPool[enemy.type][enemy.color].push(enemy)
		enemy.reset()

	attack: (player, soundSequence) ->
		for enemy, index in @liveEnemies
			if enemy.mesh.position.x == player.mesh.position.x
				if energy = enemy.attack(soundSequence)
					@liveEnemies.splice(index, 1)
					@stashEnemy(enemy)

					player.updateEnergy(energy)
					$(".score .text").text(parseInt($(".score .text").text()) + energy)
					$(".monstersKilled .text").text(parseInt($(".monstersKilled .text").text()) + 1)
				break
