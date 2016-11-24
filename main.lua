require("values")


screen = { width = 1440, height = 900, flags = nil}
player = { x = screen.width / 2, y = screen.height - 20, size = 20, width = 20, height = 20, image = nil, texture = nil, shootDelay = 0.4, lastShot = 0, movementSpeed = 500 }
constBullet = { image = nil, size = 5, width = 5, height = 5, movementSpeed = 500 }

constEnemies = { enemy1 = nil, enemy2 = nil, enemy3 = nil }

constEnemies.enemy1 = { image = nil, size = 20, width = 20, height = 20, movementSpeed = 250, shootDelay = 1.2}
score = 0
lastEnemy = 0
enemyDelay = 3
enemiesC = 0
enemies = {}
bullets = {}
powerUps = {}
startingTime = love.timer.getTime()
love.window.setMode( screen.width, screen.height, { resizable = false, vsync = true, minwidth = 800, minheight=600, fullscreen=false })
love.window.setTitle( "Generic Space Shooter" )
up = 1;
down = -1;
collisions = 0;
acceleration = { speedX = 0, speedY = 0, max = 15, min = -15, delta = 10 }


function love.load()
	love.graphics.setBackgroundColor( 0, 0, 25 ) -- 0, 0, 25
	player.image = love.graphics.newImage("assets/player.png")
	constBullet.image = love.graphics.newImage("assets/bullet.png")
	constEnemies.enemy1.image = love.graphics.newImage("assets/enemy1.png")
end

function love.update(delta_time)
    handleInput(delta_time)
    updateBullets(delta_time)
    updateEnemies(delta_time)
    updatePowerUps(delta_time)
end

function love.draw()
	love.graphics.draw(player.image, player.x, player.y, 0, 1, 1, player.width / 2, player.height / 2, 0, 0)
	love.graphics.printf(table.getn(bullets), 20, 20, 100, "left" )
	love.graphics.printf(love.timer.getFPS(), 20, 30, 100, "left" )
	love.graphics.printf(acceleration.speedX, 20, 50, 100, "left" )
	love.graphics.printf(acceleration.speedY, 20, 60, 100, "left" )

	love.graphics.printf(score, 20, 70, 50, "left" )

	for i = #enemies, 1, -1 do
		if (enemies[i].type == 1) then
			love.graphics.draw(constEnemies.enemy1.image, enemies[i].x, enemies[i].y, 0, 1, 1, enemies[i].size / 2, enemies[i].size / 2, 0, 0)
		end
	end
	for i = #bullets, 1, -1 do
		love.graphics.draw(constBullet.image, bullets[i].x, bullets[i].y, 0, 1, 1, constBullet.width / 2, constBullet.height / 2, 0, 0)
	end
end

function handleInput(delta_time)

	if love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
		acceleration.speedX = acceleration.speedX - acceleration.delta * delta_time
	elseif acceleration.speedX < 0 then 
		acceleration.speedX = math.min(acceleration.speedX + (acceleration.delta * 2 * delta_time), 0)
	end
	if love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
		acceleration.speedX = acceleration.speedX + (acceleration.delta * delta_time) 
	elseif acceleration.speedX > 0 then 
		acceleration.speedX = math.max(acceleration.speedX - (acceleration.delta * 2 * delta_time), 0)
	end

	if love.keyboard.isDown("escape") then
		love.event.quit();
	end
	if love.keyboard.isDown("lctrl") or love.keyboard.isDown("space") then
		shoot(player, true)
	end
	if love.keyboard.isDown("r") then
		love.event.quit("restart")
	end

	acceleration.speedX = math.max(math.min(acceleration.speedX, acceleration.max), acceleration.min)
	
	player.x = math.min(math.max(player.x + acceleration.speedX, 0 + player.width / 2), screen.width - player.width / 2)
	--player.y = math.min(math.max(player.y + acceleration.speedY, 0 + player.height / 2), screen.height - player.height / 2)
end

function shoot(entity, isPlayer)
	local canShoot = (love.timer.getTime() - entity.lastShot) > entity.shootDelay
	if (canShoot) then
		local direction = (isPlayer and up or down)
		local deltaY = (isPlayer and -30 or 30)
		bullet = { x = entity.x, y = entity.y + deltaY, direction = direction }
		table.insert(bullets, bullet)
		entity.lastShot = love.timer.getTime()
	end
end


function updateBullets(delta_time)
	for i = #bullets, 1, -1 do
		local hit = false;
		local playerCollision = false;
		local bulletRemoved
		local y = bullets[i].y - (delta_time * constBullet.movementSpeed * 1.5) * bullets[i].direction;
		playerCollision = checkBulletCollision(player, bullets[i])
		if (y < 0) then -- reverse direction if top hit
			bullets[i].direction = down;
		elseif (y > screen.height) then -- remove if below bottom
			table.remove(bullets, i)
			bulletRemoved = true
		else
			bullets[i].y = y
		end
		if (not playerCollision and not bulletRemoved) then
			for j = #enemies, 1, -1 do
				hit = checkBulletCollision(enemies[j], bullets[i])
				if (hit) then
					table.remove(enemies, j)
					score = score + 1 
				end
			end
		end
		if (playerCollision or hit) then
			table.remove(bullets, i)
		end
	end
end

function updateEnemies(delta_time)
	if (lastEnemy + enemyDelay < love.timer.getTime() and math.random() > 0.20) then
		createEnemy(1)
		lastEnemy = love.timer.getTime()
	end
	for i = #enemies, 1, -1 do
		local canShoot = enemies[i].lastShot + enemies[i].shootDelay < love.timer.getTime()
		if (canShoot and math.random() > 0.10) then
			shoot(enemies[i], false)
		end
		enemies[i].y = enemies[i].y + delta_time * constEnemies.enemy1.movementSpeed
		local hit = checkEnemyCollision(player, enemies[i])
		if (hit or enemies[i].y > screen.height) then
			table.remove(enemies, i)
		end
	end
end

function updatePowerUps(delta_time)
	for i = #powerUps, 1, -1 do
		print("POWER")
	end
end

function checkPowerupCollision(this, powerup)

end

function checkEnemyCollision(this, enemy)
	if ( math.abs((this.x + this.size) / 2 - (enemy.x + enemy.size) / 2) < math.max(enemy.size/2, this.size / 2) ) then
		if ( math.abs((this.y + this.size) / 2 - (enemy.y + enemy.size) / 2) < math.max(enemy.size/2, this.size / 2) ) then
			return true
		end
	end
end

--[[function checkBulletCollision(this, bullet)
	if ( math.abs((this.x + this.size) / 2 - (bullet.x + constBullet.size) / 2) < math.max(constBullet.size/2, this.size / 2) ) then
		if ( math.abs((this.y + this.size) / 2 - (bullet.y + constBullet.size) / 2) < math.max(constBullet.size/2, this.size / 2) ) then
			return true
		end
	end
end]]--

function checkBulletCollision(this, bullet) --  oh geez
	if ((this.x < bullet.x and this.x + this.size > bullet.x) 
	or (this.x < bullet.x + constBullet.size and this.x + this.size > bullet.x + constBullet.size)) then
		if (((this.y < bullet.y and this.y + this.size > bullet.y)
		or (this.y < bullet.y + constBullet.size and this.y + this.size > bullet.y + constBullet.size))) then
			return true;
		end
	end
end

function createEnemy(type)
	if (type == 1) then
		table.insert(enemies, { x = math.random(0, screen.width), shootDelay = 0.8, lastShot = 0, y = 0, health = 3, type = 1, damage = 5, size = 20})
	elseif (type == 2) then
		table.insert(enemies, {})
	end
end