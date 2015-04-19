class GameManager
	constructor: (width, height) ->
		@width = width or window.innerWidth
		@height = height or window.innerHeight

		@renderer = new THREE.WebGLRenderer()
		@renderer.setSize(@width, @height - 4)

		@camera = new THREE.PerspectiveCamera(75, @width / @height, 0.1, 1000)
		@camera.position.y = -2.5
		@camera.position.z = 2
		@camera.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2.2)

		@paused = true

		@enemies = []

		@enemyPool = []

		@transparentObjects = []

		@movementQueue = []

		@nextSpawn = 0

		@soundSequence = []

		@createScene()

	createScene: ->
		@scene = new THREE.Scene()
		@scene.fog = new THREE.Fog(0x000000, 10, 30)

		@road = new Road(@scene, @renderer)

		@player = new Player(@renderer)
		@scene.add(@player.mesh)

		@addTransparentObject(@player)

	addTransparentObject: (o) ->
		@transparentObjects.push(o.mesh)
		THREEx.Transparency.init(@transparentObjects)

	resize: (width, height) ->
		@width = width or window.innerWidth
		@height = height or window.innerHeight

		@renderer.setSize(@width, @height - 4)

		@camera.aspect = @width / @height
		@camera.updateProjectionMatrix()

	keyDown: (event) ->
		key = event.keyCode
		#console.log key
		if key == keyCodes.space
			@paused = not @paused
		else if not @paused
			switch key
				when keyCodes.left
					if @movementQueue.length < 2 and not (@player.position == 0 and @player.moving == "left")
						@movementQueue.push("left")
				when keyCodes.right
					if @movementQueue.length < 2 and not (@player.position == 0 and @player.moving == "right")
						@movementQueue.push("right")

			if 49 <= key <= 52
				@playSound(key)

	playSound: (key) ->
		@soundSequence.push(key)

		if not @player.moving
			for enemy, index in @enemies
				if enemy.mesh.position.x == @player.mesh.position.x
					if energy = enemy.attack(@soundSequence)
						@enemies.splice(index, 1)
						@enemyPool.push(enemy)
						@scene.remove(enemy.mesh)
						enemy.reset()

						@player.updateEnergy(energy)
						$(".score .text").text(parseInt($(".score .text").text()) + energy)
						$(".monstersKilled .text").text(parseInt($(".monstersKilled .text").text()) + 1)
					break

	render: ->
		if @paused then return

		THREEx.Transparency.update(@transparentObjects, @camera)
		@renderer.render(@scene, @camera)

	update: (delta) ->
		if @paused then return

		@road.update(delta)

		if not @player.moving and @movementQueue.length > 0
			switch @movementQueue[0]
				when "left"
					@player.moveLeft()
				when "right"
					@player.moveRight()
			@movementQueue.splice(0, 1)

		@player.update(delta)

		for enemy, index in @enemies
			if not enemy.collided and enemy.mesh.position.y > 0
				canCollide = true

			enemy.update(delta)

			if canCollide and enemy.mesh.position.y < 0.2
				enemyX = enemy.mesh.position.x
				playerX = @player.mesh.position.x
				if enemyX - enemy.width / 2 <= playerX + @player.width / 2 and playerX - @player.width / 2 <= enemyX + enemy.width / 2
					enemy.collided = true
					console.log "ded"

			if enemy.mesh.position.y <= @camera.position.y
				@enemies[index] = null
				@enemyPool.push(enemy)
				@scene.remove(enemy.mesh)

		@enemies = @enemies.filter (o) -> !!o

		@nextSpawn -= delta or 0
		if @nextSpawn <= 0
			if @enemyPool.length > 0
				enemy = @enemyPool.pop()
				enemy.reset()
			else
				if Math.random() < 0.7
					enemy = new Enemy_Minibot(@renderer)
				else
					enemy = new Enemy_C69(@renderer)
				@addTransparentObject(enemy)
			@enemies.push(enemy)
			@scene.add(enemy.mesh)
			@generateNextSpawn()

	generateNextSpawn: ->
		@nextSpawn = Math.random() * 2 * 1000 // 1
