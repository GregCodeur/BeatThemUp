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
    hero.animations = {};
    hero.animations["idle"] = {1};
    hero.animations["walk"] = {2,3,4,5,6,7};
    
    hero.lstFrame = {};
    table.insert(hero.lstFrame,1,love.graphics.newImage("images/blaze_idle_1.png"));
    for i = 2,7 do
      table.insert(hero.lstFrame,i,love.graphics.newImage("images/blaze_walk_"..i..".png"));
    end

    hero.animations["combo"] = love.graphics.newImage("images/blaze_combo_1.png");
    
    hero.frame = 1;
    
    --for i = 1,9 do
    --  table.insert(lstCombo,i,love.graphics.newImage("images/blaze_combo_"..i..".png"));
    --end
    --hero.animations["combo"] = lstCombo;
    --Fin animation
    
    
    hero.image = {};
    hero.image["idle"] = love.graphics.newImage("images/blaze_idle_1.png");
    hero.image["punch"] = love.graphics.newImage("images/blaze_combo_1.png");
    hero.image["kick"] = love.graphics.newImage("images/blaze_combo_8.png");
    hero.state = "idle";
    
    
    hero.timerAnimation = 0;
    hero.animationSpeed = 0.2;
    
    --hero.spriteAAfficher = hero.images["idle"];
    
    hero.x = pX;
    hero.y = pY;
    hero.vx = 60;
    hero.vy = 60;
    hero.pv = 200;
  elseif(pType == TYPE_SPRITE.ENNEMI) then
    
  end
  
end

function ChangerAnimation(pSprite, pState)
  if(pSprite.state ~= pState) then
    pSprite.state = pState;
    pSprite.frame = 1;
    
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

function UpdateCamera()
  local dif = camera.x + hero.x;
  if(dif < 70) then
    camera.x = camera.x + 1;
  elseif(dif > (love.graphics.getWidth()/2)-70) then
    camera.x = camera.x - 1;
  end
end

function love.update(dt)
  local tick = false;
  hero.timerAnimation = hero.timerAnimation + dt
  if(hero.timerAnimation >= hero.animationSpeed) then
    tick = true;
    hero.timerAnimation = 0;
  end
  
  if(tick == true) then
    hero.frame = hero.frame + 1;
    if(hero.frame > #hero.animations[hero.state]) then
      hero.frame = 1;
    end
  end
  
  updateKeyboard(dt);
  UpdateCamera();
  barSize = 200 * (hero.pv / 200);
end

function updateKeyboard(dt)
  if(love.keyboard.isDown("right")) then
      ChangerAnimation(hero,"walk");
      hero.x = hero.x + hero.vx * dt
  end
  
  if(love.keyboard.isDown("left")) then
    ChangerAnimation(hero,"walk");
    hero.x = hero.x - hero.vx * dt;
  end
  
  if(love.keyboard.isDown("a")) then
    ChangerAnimation(hero,"punch");
    --if(hero.state == "combo") then
      --local sprite = hero.images["combo"][hero.spriteAAfficher];
    --else
      --hero.state = "combo";
    --end
  end
  
  if(love.keyboard.isDown("z")) then
    ChangerAnimation(hero,"kick");
  end
  
  if(love.keyboard.isDown("r")) then
    hero.pv = hero.pv - 10;
  end
  
  if(action == false) then
    ChangerAnimation(hero,"idle");
  end
  
end

function love.draw()
  love.graphics.scale(2,2); 
  love.graphics.draw(backgrdStage,camera.x,0);
  
  local imageNumber = hero.animations[hero.state][hero.frame]
  local imageFrame = hero.lstFrame[imageNumber]
  love.graphics.draw(imageFrame,hero.x + camera.x,hero.y);
  
  
  love.graphics.setColor(255,000,000);
  love.graphics.rectangle("fill",2,2,200,8);
  love.graphics.setColor(255,255,000);
  love.graphics.rectangle("fill",2,2,barSize,8);
  love.graphics.setColor(255,255,255);
  love.graphics.print("barSize "..barSize,230,0);
end

function love.keypressed(key)

  
end
  