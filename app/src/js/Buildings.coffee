class Buildings
	constructor: (renderer, @scene) ->
		@width = 3

		@heights =
			small: @width * 1200 / 750
			medium: @width * 1500 / 750
			large: @width * 1700 / 750

		@interval = 2

		@buildingsNumber = Math.ceil(30 / (@width + @interval))

		@buildings = []

		@buildingPool =
			small: []
			medium: []
			large: []

		createMaterial = (textureName) ->
			texture = THREE.ImageUtils.loadTexture("/images/building_#{textureName}.png")
			texture.minFilter = THREE.LinearFilter
			texture.anisotropy = renderer.getMaxAnisotropy()
			new THREE.MeshBasicMaterial(map: texture)

		@components =
			small:
				material: createMaterial("small")
				geometry: new THREE.BoxGeometry(@width, @heights.small, @width)
			medium:
				material: createMaterial("medium")
				geometry: new THREE.BoxGeometry(@width, @heights.medium, @width)
			large:
				material: createMaterial("large")
				geometry: new THREE.BoxGeometry(@width, @heights.large, @width)

		@sizes = Object.keys(@heights)

		for xOffset in [-1, 1]
			for yOffset in [0...@buildingsNumber]
				@spawnBuilding(xOffset, yOffset)

	spawnBuilding: (xOffset, yOffset) ->
		size = @sizes[Math.random() * @sizes.length // 1]

		building = @buildingPool[size].pop() or @createBuilding(size)
		building.mesh.position.x = xOffset * (3 + 1.5 + @width / 2)
		building.mesh.position.y = @width / 2 + yOffset * (@width + @interval)

		@buildings.push(building)
		@scene.add(building.mesh)

	createBuilding: (size) ->
		building = new Building(size, @components[size])
		building.mesh.position.z = @heights[size] / 2
		building.mesh.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2)
		building

	update: (delta) ->
		for building, index in @buildings
			building.mesh.position.y -= 3 / 1000 * delta
			if building.mesh.position.y <= @width / 2 - (@width + @interval)
				removedBuilding = true
				@buildings[index] = null
				@scene.remove(building.mesh)
				@buildingPool[building.size].push(building)
				@spawnBuilding(Math.sign(building.mesh.position.x), @buildingsNumber-1)

		if removedBuilding
			@buildings = @buildings.filter (o) -> !!o

class Building
	constructor: (@size, components) ->
		@mesh = new THREE.Mesh(components.geometry, components.material)
