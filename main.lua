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
camera.y = 0;
local TYPE_SPRITE = {};
TYPE_SPRITE.HERO = "hero";
TYPE_SPRITE.ENNEMI = "ennemi";

local ennemi = {};

local coordonneeCollision = {};
coordonneeCollision.x = 0;
coordonneeCollision.y = 0;
coordonneeCollision.h = 0;
coordonneeCollision.w = 0;

local bTestCollision;

function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2)
  return x1 < x2+w2 and
  x2 < x1 + w1 and
  y1 < y2 + h2 and
  y2 < y1 + h1
end


function loadStage(numStage)
  backgrdStage = love.graphics.newImage("images/stages/"..numStage..".jpeg");
end

function CreateSprite(pType,pX,pY)
  if(pType == TYPE_SPRITE.HERO) then
    
    
    --Todo animation
    hero.animations = {};
    hero.animations["idle"] = {1};
    hero.animations["walk"] = {2,3,4,5,6,7};
    hero.animations["combo"] = {8}

    
    hero.lstFrame = {};
    table.insert(hero.lstFrame,1,love.graphics.newImage("images/blaze_idle_1.png"));
    for i = 2,7 do
      table.insert(hero.lstFrame,i,love.graphics.newImage("images/blaze_walk_"..i..".png"));
    end

    --for i = 8,15 do
    --  table.insert(hero.lstFrame,i,love.graphics.newImage("images/blaze_combo_"..i..".png"));
    --end
    table.insert(hero.lstFrame,8,love.graphics.newImage("images/blaze_combo_8.png"));

    
    --hero.animations["combo"] = love.graphics.newImage("images/blaze_combo_1.png");
    
    hero.frame = 1;
    
    --for i = 1,9 do
    --  table.insert(lstCombo,i,love.graphics.newImage("images/blaze_combo_"..i..".png"));
    --end
    --hero.animations["combo"] = lstCombo;
    --Fin animation
    
    
    --hero.image = {};
    --hero.image["idle"] = love.graphics.newImage("images/blaze_idle_1.png");
    --hero.image["punch"] = love.graphics.newImage("images/blaze_combo_1.png");
    --hero.image["kick"] = love.graphics.newImage("images/blaze_combo_8.png");
    hero.state = "idle";
    
    
    hero.timerAnimation = 0;
    hero.animationSpeed = 0.2;
    
    --hero.spriteAAfficher = hero.images["idle"];
    
    hero.x = pX;
    hero.y = pY;
    hero.vx = 60;
    hero.vy = 60;
    hero.pv = 200;
    
    hero.hurtBox = {};
    hero.hurtBox["walk"] = {};
    for i = 2,7 do
      hero.hurtBox["walk"][i-1] = {x=hero.lstFrame[i]:getWidth()/2,y=hero.lstFrame[i]:getHeight()/2,w=hero.lstFrame[i]:getWidth()/1.5,h=hero.lstFrame[i]:getHeight()/2};
    end
    print(#hero.hurtBox["walk"]);
    
    hero.hurtBox["idle"] = {};
    hero.hurtBox["idle"][1] = {x=hero.lstFrame[1]:getWidth()/2,y=hero.lstFrame[1]:getHeight()/2,w=hero.lstFrame[1]:getWidth()/1.5,h=hero.lstFrame[1]:getHeight()/2};
    
    hero.hitBox = {};
    hero.hitBox["combo"] = {};
    hero.hitBox["combo"][1] = {x=hero.lstFrame[8]:getWidth(),y=hero.lstFrame[8]:getHeight(),w=hero.lstFrame[8]:getWidth(),h=31};
    
    
    hero.hurt = false;
    hero.hit = false;
    
    
  elseif(pType == TYPE_SPRITE.ENNEMI) then
      
      ennemi.state = "idle";
      ennemi.animations = {};
      ennemi.animations["idle"] = {1};
      
      ennemi.lstFrame = {};
      table.insert(ennemi.lstFrame,1,love.graphics.newImage("images/blaze_idle_1.png"));
      
      ennemi.frame = 1;
      
      ennemi.x = pX;
      ennemi.y = pY;
      ennemi.vx = 60;
      ennemi.vy = 60;
      ennemi.pv = 200;
      
      
      ennemi.hurtBox = {};
      ennemi.hurtBox["idle"] = {};
      ennemi.hurtBox["idle"][1] = {x=ennemi.lstFrame[1]:getWidth()/2,y=ennemi.lstFrame[1]:getHeight()/2,w=ennemi.lstFrame[1]:getWidth()/1.5,h=ennemi.lstFrame[1]:getHeight()/2};
      
      ennemi.hurt = false;
      ennemi.hit = false;
      
  end
  
end

function ChangerAnimation(pSprite, pState)
  if(pSprite.state ~= pState) then
    pSprite.state = pState;
    pSprite.frame = 1;
    return true;
  end
  return false;
end

function love.load()
  love.window.setMode(800,448);
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  camera.x = -90;
  loadStage(2);
  
  CreateSprite(TYPE_SPRITE.HERO,largeur/4,hauteur/3);
  CreateSprite(TYPE_SPRITE.ENNEMI, largeur/2,hauteur/3);
  
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
  SetBoxes();
  if(bTestCollision) then
    TestCollisions();
  end
  
  barSize = 200 * (hero.pv / 200);
end

function SetBoxes()
  lstHurtBoxes = {};
  lstHitBoxes = {};
  
  if(hero.hurtBox[hero.state] ~= nil) then
    myBox = hero.hurtBox[hero.state][hero.frame];
    if(myBox ~=nil) then
      CreeBox(lstHurtBoxes,myBox, "hero", hero)
    end
  end
  if(hero.hitBox[hero.state]) then
    myBox = hero.hitBox[hero.state][hero.frame];
    if(myBox ~= nil) then
      CreeBox(lstHitBoxes,myBox,"hero",hero);
    end
  end
  
  
  myBox = ennemi.hurtBox["idle"][ennemi.frame];
  CreeBox(lstHurtBoxes,myBox,"ennemi",ennemi);
  
end

function CreeBox(pList,pBox,pWho,pSprite)
  local myBox = {};
  myBox.x = pSprite.x + pBox.x + camera.x;
  myBox.y = pSprite.y + pBox.y + camera.y;
  myBox.w = pBox.w;
  myBox.h = pBox.h;
  myBox.who = pWho;
  table.insert(pList,myBox);
  return myBox;
end

function TestCollisions()
  hero.hit = false;
  for hit=1, #lstHitBoxes do
    local hitb = lstHitBoxes[hit];
    for hurt=1,#lstHurtBoxes do
      local hurtb = lstHurtBoxes[hurt]
      if(CheckCollision(hitb.x,hitb.y,hitb.w,hitb.h,hurtb.x,hurtb.y,hurtb.w,hurtb.h) == true) then
          if(hitb.who ~= hurtb.who) then
            --print(hitb.who.." vient de frapper "..hurtb.who)
            print("x: "..hitb.x.." y: "..hitb.y);
            LastActionBy = hitb.who
            hero.hit = true;
            coordonneeCollision.x = hitb.x;
            coordonneeCollision.y = hitb.y;
            coordonneeCollision.h = hitb.h;
            coordonneeCollision.w = hitb.w;
          end
      end
    end
  end
  
end


function updateKeyboard(dt)
  local action = false;
  
  if(love.keyboard.isDown("right")) then
      ChangerAnimation(hero,"walk");
      action = true;
      hero.x = hero.x + hero.vx * dt
  end
  
  if(love.keyboard.isDown("left")) then
    action = true;
    ChangerAnimation(hero,"walk");
    hero.x = hero.x - hero.vx * dt;
  end
  
  if(love.keyboard.isDown("a")) then
    action = true;
    bTestCollision = ChangerAnimation(hero,"combo");
    --if(hero.state == "combo") then
      --local sprite = hero.images["combo"][hero.spriteAAfficher];
    --else
      --hero.state = "combo";
    --end
  end
  
  if(love.keyboard.isDown("z")) then
    action = true;
    ChangerAnimation(hero,"combo");
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
  
  
  local imageNumberEnnemi = ennemi.animations[ennemi.state][ennemi.frame]
  local imageFrameEnnemi = ennemi.lstFrame[imageNumberEnnemi]
  love.graphics.draw(imageFrameEnnemi,ennemi.x + camera.x,ennemi.y);
  
  
  love.graphics.setColor(255,000,000);
  love.graphics.print("x : "..love.mouse.getX().." y : "..love.mouse.getY(),0,50);
  love.graphics.rectangle("fill",2,2,200,8);
  love.graphics.setColor(255,255,000);
  love.graphics.rectangle("fill",2,2,barSize,8);
  love.graphics.setColor(255,255,255);
  love.graphics.print("barSize "..barSize,230,0);
  
  if(hero.hit) then
    love.graphics.setColor(0,0,1)
    love.graphics.rectangle("fill",coordonneeCollision.x,coordonneeCollision.y,80,80);
  end
  love.graphics.setColor(255,255,255);
  
end

function love.keypressed(key)

  
end
  