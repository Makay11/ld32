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

		@enemies = []

		@enemyPool = []

		@transparentObjects = []

		@movementQueue = []

		@nextSpawn = 0

		@createScene()

	createScene: ->
		@scene = new THREE.Scene()

		geometry = new THREE.PlaneBufferGeometry(6, 1000)
		material = new THREE.MeshBasicMaterial({color: 0xffff00, side: THREE.DoubleSide})
		plane = new THREE.Mesh(geometry, material)
		@scene.add(plane)

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
		switch event.keyCode
			when keyCodes.left
				if @movementQueue.length < 2 and not (@player.position == 0 and @player.moving == "left")
					@movementQueue.push("left")
			when keyCodes.right
				if @movementQueue.length < 2 and not (@player.position == 0 and @player.moving == "right")
					@movementQueue.push("right")

	generateNextSpawn: ->
		@nextSpawn = Math.random() * 2 * 1000 // 1

	render: ->
		THREEx.Transparency.update(@transparentObjects, @camera)
		@renderer.render(@scene, @camera)

	update: (delta) ->
		if not @player.moving and @movementQueue.length > 0
			switch @movementQueue[0]
				when "left"
					@player.moveLeft()
				when "right"
					@player.moveRight()
			@movementQueue.splice(0, 1)

		@player.update(delta)

		deadEnemies = []

		for enemy in @enemies
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
				@enemyPool.push(enemy)
				@scene.remove(enemy.mesh)
				deadEnemies.push(enemy)

		for enemy in deadEnemies
			@enemies.splice(@enemies.indexOf(enemy), 1)

		@nextSpawn -= delta or 0
		if @nextSpawn <= 0
			if @enemyPool.length > 0
				enemy = @enemyPool.pop()
				enemy.reset()
			else
				enemy = new Enemy_C69(@renderer)
				@addTransparentObject(enemy)
			@enemies.push(enemy)
			@scene.add(enemy.mesh)
			@generateNextSpawn()
