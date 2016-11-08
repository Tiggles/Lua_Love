require "variables"

player = { x = 0, y = 0, width = 20, height = 20, image = nil, texture = nil }
constBullet = { image = nil, width = 5, height = 5, movementSpeed = 900 }
constEnemies = { enemy1 = nil, enemy2 = nil, enemy3 = nil }
constEnemies.enemy1 = { image = nil, width = 20, height = 20, movementSpeed = 450 }
shootDelay = 0.4
lastShot = 0
enemies = {}
bullets = {}
powerUps = {}
movementSpeed = 500
screen = { width = 1440, height = 900, flags = nil}
love.window.setMode( screen.width, screen.height, { resizable = false, vsync = true, minwidth = 800, minheight=600, fullscreen=false })
love.window.setTitle( "title" )
up = 1;
down = -1;


function love.load()
	love.graphics.setBackgroundColor( 0, 0, 25 )
	player.image = love.graphics.newImage("assets/player.png")
	constBullet.image = love.graphics.newImage("assets/bullet.png")
	--constEnemy.enemy1.image = love.graphics.newImage("assets/enemy1.png")
end

function love.update(delta_time)
    handleInput(delta_time)
    updateBullets(delta_time)
    updateEnemies(delta_time)
    updatePowerUps(delta_time)
end

function love.draw()

	love.graphics.draw(player.image, player.x, player.y, 0, 1, 1, player.width / 2, player.height / 2, 0, 0)
	love.graphics.printf(table.getn(bullets), 20, 20, 50, "left" )
	love.graphics.printf(love.timer.getFPS(), 20, 30, 50, "left" )
	local bulletsSize = #bullets
	for i = bulletsSize, 1, -1 do
		love.graphics.draw(constBullet.image, bullets[i].x, bullets[i].y, 0, 1, 1, constBullet.width / 2, constBullet.height / 2, 0, 0)
	end
end

function handleInput(delta_time)

	local movementY = 0
	local movementX = 0
	
	if love.keyboard.isDown("up") then
	    movementY = -delta_time * movementSpeed
	end
	if love.keyboard.isDown("down") then
		movementY = movementY + delta_time * movementSpeed
	end
	if love.keyboard.isDown("left") then
	    movementX = -delta_time * movementSpeed
	end
	if love.keyboard.isDown("right") then
	    movementX = movementX + delta_time * movementSpeed
	end
	if love.keyboard.isDown("escape") then
		love.event.quit();
	end
	if love.keyboard.isDown("lctrl") or love.keyboard.isDown("space") then
		shoot()
	end
	if love.keyboard.isDown("r") then
		love.event.quit("restart")
	end

	player.x = math.min(math.max(player.x + movementX, 0 + player.width / 2), screen.width - player.width / 2)
	player.y = math.min(math.max(player.y + movementY, 0 + player.height / 2), screen.height - player.height / 2)

end

function shoot()
	local canShoot = (love.timer.getTime() - lastShot) > shootDelay
	if (canShoot) then
		bullet = { x = player.x, y = player.y - 30, direction = up }
		table.insert(bullets, bullet)
		lastShot = love.timer.getTime()
	end
end


function updateBullets(delta_time)
	local bulletsSize = #bullets -- øhh
	local enemiesSize = #enemies -- øhh

	for i = bulletsSize, 1, -1 do
		local y = bullets[i].y - (delta_time * movementSpeed * 1.5) * bullets[i].direction;
		local playerCollision =	checkBulletCollision(player, bullet[i])
		if (y < 0) then
			bullets[i].direction = down;
		else
			bullets[i].y = y
		end
		for i = enemiesSize, 1, -1 do
			checkCollision(enemies[i], bullet[i])
		end
	end
end

function updateEnemies(delta_time)

end

function updatePowerUps(delta_time)

end

function checkBulletCollision(this, bullet) -- other is usually smaller than this, så check if other is inside
	if (bullet.x > this.x and this.size + this.x > constBullet.width + bullet.x) then

	end
end