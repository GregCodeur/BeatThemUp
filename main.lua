-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local backgrdStage = {};
local hero = {};
local barSize = 200;
local camera = {};
camera.x = 0;
local TYPE_SPRITE = {};
TYPE_SPRITE.HERO = "hero";
TYPE_SPRITE.ENNEMI = "ennemi";

function loadStage(numStage)
  backgrdStage = love.graphics.newImage("images/stages/"..numStage..".jpeg");
end

function CreateSprite(pType,pX,pY)
  if(pType == TYPE_SPRITE.HERO) then
    
    
    --Todo animation
    hero.images = {};
    hero.images["idle"] = love.graphics.newImage("images/blaze_idle_1.png");
    hero.images["combo"] = love.graphics.newImage("images/blaze_combo_1.png");
    lstCombo = {};
    for i = 1,9 do
      table.insert(lstCombo,i,love.graphics.newImage("images/blaze_combo_"..i..".png"));
    end
    hero.images["combo"] = lstCombo;
    --Fin animation
    
    
    hero.image = {};
    hero.image["idle"] = love.graphics.newImage("images/blaze_idle_1.png");
    hero.image["punch"] = love.graphics.newImage("images/blaze_combo_1.png");
    hero.image["kick"] = love.graphics.newImage("images/blaze_combo_8.png");
    hero.state = "idle";
    
    hero.spriteAAfficher = hero.images["idle"];
    
    hero.x = pX;
    hero.y = pY;
    hero.vx = 60;
    hero.vy = 60;
    hero.pv = 200;
  elseif(pType == TYPE_SPRITE.ENNEMI) then
    
  end
  
end

function love.load()
  love.window.setMode(800,448);
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  camera.x = -90;
  loadStage(2);
  
  CreateSprite(TYPE_SPRITE.HERO,largeur/4,hauteur/3);
  
  love.window.setMode(440 * 2,220*2)
  love.window.setTitle("")
  
end

function love.update(dt)
  updateKeyboard(dt);
  
  barSize = 200 * (hero.pv / 200);
end

function updateKeyboard(dt)
  if(love.keyboard.isDown("right")) then
      hero.state = "idle";
      hero.x = hero.x + hero.vx * dt
  end
  
  if(love.keyboard.isDown("left")) then
    hero.state = "idle";
    hero.x = hero.x - hero.vx * dt;
  end
  
  if(love.keyboard.isDown("a")) then
    hero.state = "punch"; 
    --if(hero.state == "combo") then
      --local sprite = hero.images["combo"][hero.spriteAAfficher];
    --else
      --hero.state = "combo";
    --end
  elseif(love.keyboard.isDown("z")) then
    hero.state = "kick";
  else
    hero.state = "idle";
  end
  
  if(love.keyboard.isDown("r")) then
    hero.pv = hero.pv - 10;
  end
  
end

function love.draw()
  love.graphics.scale(2,2); 
  love.graphics.draw(backgrdStage,0,0);
  love.graphics.draw(hero.image[hero.state],hero.x + camera.x,hero.y);
  love.graphics.setColor(255,000,000);
  love.graphics.rectangle("fill",2,2,200,8);
  love.graphics.setColor(255,255,000);
  love.graphics.rectangle("fill",2,2,barSize,8);
  love.graphics.setColor(255,255,255);
  love.graphics.print("barSize "..barSize,230,0);
end

function love.keypressed(key)

  
end
  