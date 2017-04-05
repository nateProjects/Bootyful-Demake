pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
-- bootyful demake
-- jfc 1984 & nct 2017

-- rough code ahead - proceed at your own risk

function gamedraw()
  cls()
  map(levels[hero.lvl][6],levels[hero.lvl][7],0,0,16,13) -- draw map

  if hero.lvl==1 and first==true then
    color(11)
    centre_print("press z if you get stuck",113)
    color(7)
  else
    first=false
  end
  -- draw ladders if using fading platforms
  if cheat[6]==1 then
      -- add alt ladder number to levels
      for ladnum = 1,levels[hero.lvl][13] do
      -- loop through different ladders for level
        ladx=altladders[hero.lvl][ladnum][1] -- x
        lady=altladders[hero.lvl][ladnum][2] -- y
        for ladraw = 0,2 do
          mset(ladx,lady+ladraw,2)
          -- draw ladder
        end
      end
  end

  objects()

  -- player moving platform movement
  if hero.ron==true then
    hero.x=travs[hero.lvl][1][1]-hero.rx
    -- player x = traveling platform x - riding x
  end
if hero.death==false then
    spr(hero.sp,hero.x,hero.y,hero.w/8,hero.h/8,hero.dr) -- draw hero
  else fall()
end
  if cheat[2]==0 then
  -- draw pirates if present
    if not (levels[hero.lvl][5]==0) then
      for enemies = 1,levels[hero.lvl][5] do -- draw pirates
        spr(pirate.sp,pilocate[hero.lvl][enemies][1],pilocate[hero.lvl][enemies][2],pirate.w,pirate.h,pilocate[hero.lvl][enemies][3])
      end
    end
  end
  -- draw travelators if present - defunct
  if not cheat[6]==1 then
    if not (levels[hero.lvl][8]==0) then
      for travloops = 1,levels[hero.lvl][8] do
        spr(45,travs[hero.lvl][travloops][1],travs[hero.lvl][travloops][2],1,1)
        -- spr,x,y - size1,1 - fixme - account for width
      end
    end
  end
  -- draw lifts if present - defunct
  if not cheat[6]==1 then
    if not (levels[hero.lvl][9]==0) then
      for liftloops = 1,levels[hero.lvl][9] do
        spr(46,lifts[hero.lvl][liftloops][1],lifts[hero.lvl][liftloops][2],1,1)
        -- spr,x,y - size1,1 - fixme - account for width
      end
    end
  end
-- draw fading platforms if present
-- check if flash on - in draw section
  if (tempon==true) then
    for fadeloop = 1, levels[hero.lvl][10] do
      if templatforms[hero.lvl][fadeloop][4]==1 or cheat[6]==1 then
        platstart = templatforms[hero.lvl][fadeloop][1]
        platend = platstart + (templatforms[hero.lvl][fadeloop][3]*8)
        for platpart = platstart, platend, 8 do
          if not (templatforms[hero.lvl][fadeloop][4]==2) then
          -- templatforms is also used to mark no go gaps
            spr(1,platpart,templatforms[hero.lvl][fadeloop][2]) -- x,y
            fset(1,1,true)
          end
        end
      end
    end
  end

  stats()
  debug()
  collision() -- collision tests
end -- gamedraw end

function stats()
  -- stats
  color(10)
  print("l",0,106)
  color(7)
  print(hero.lvl,4,106)

  for life = 0,hero.lives-1 do -- show lives
    spr(18,14+life*8,104)
  end
  spr(19,5*8,13*8) -- key
    print(hero.keyheld,55,106)
  spr(30,8*8,13*8) -- booty
    print(hero.treas,78,106)
  spr(14,11*8,13*8) -- treasure
    print(125-hero.treas,102,106)
  spr(31,15*8,13*8) -- exit

  total=0
  for taken = 1,levels[hero.lvl][2] do
    total += booty[hero.lvl][taken][3]
  end
  if total == 0 then
    centre_print("level complete",113)
    first=false
  end

  if (behind==192) then
    -- is there an exit and which one is it?
      for exitloop = 1,levels[hero.lvl][4] do
          if exits[hero.lvl][exitloop][2]==flr(hero.y)
            and (exits[hero.lvl][exitloop][1]>=flr(hero.x)-7
            and exits[hero.lvl][exitloop][1]<=flr(hero.x)+7) then
              -- is player in front of the exit?
            levl=exits[hero.lvl][exitloop][3]
            -- set destination
            if (levl >= 10 and levl <= 99) then
              print(levl,120,106)
              else print (levl,122,106)
            end
            if (btnp(5)) then
              -- is the playter pressing x on the exit?
              -- hero.keyheld=0 -- made some levels impossible!
              hero.lvl=levl
              break
              -- change level to where exit leads
          end
        end
      end
    end
--end

  color(8)
  centre_print("bootyful demake",120)
end

-- doesn't work - needs to be rewritten
function fall()
  if hero.death==true then
    sfx(10)
--    for y=hero.y,hero.y+32 do
      -- slow down?
--      timer(0.25)
--      spr(76,hero.x,y,hero.w/8,hero.h/8)
--      spr(74,hero.x,y,hero.w/8,hero.h/8)
      -- maybe change to fall upside down
--    end
    wait(1)
    hero.lives-=1
    hero.x=levels[hero.lvl][11]
    hero.x=levels[hero.lvl][12]
    hero.death=false
  end
end

function debug() -- fixme - remove at end
--  print ("hx "..flr(hero.x),0,113)
--  print ("hy "..flr(hero.y),25,113)
--  print ("tx "..flr(hero.x/8),50,113)
--  print ("ty "..flr(hero.y/8),75,113)
--  print ("bh "..behind,50,113)
--  print ("bn "..beneath,75,113)
--  print ("fb "..floor_below,110,113)
end

function move(sprite)
  hero.mov = true
  hero.sp += 1
  if hero.sp > sprite+hero.ani then
    hero.sp = sprite
  end
end

function gameupdate() -- swapped with update
  hero.mov = false
  if(btn(0) and platform) then
      climb=false
        if hero.ron == true then
        -- riding platform
          hero.rx+=1 --maybe hero.rx+=hero.spd
        else hero.x-=hero.spd -- left
        end
      hero.dr = true
      if hero.x < 1 then
        hero.x = 1
      end
      move(hero.ini)
  end
  if(btn(1) and platform) then
      climb=false
        if hero.ron == true then
          hero.rx-=1
        else hero.x+=hero.spd -- right
        end
      hero.dr = false
      if hero.x > world.w-hero.w then
        hero.x = world.w-hero.w-1
      end
      move(hero.ini)
   end
    if (btn(3) and ladder_d) then -- down
      climb=true
      hero.y+=1
      move(hero.clisp)
    end
    if (btn(2) and ladder_u) then -- up
      climb=true
      hero.y-=1
      move(hero.clisp)
    end

  if (btnp(4)) then
    if cheat[5]==1 and hero.lvl<20 then
    -- if cheat is on can skip levels
    hero.lvl+=1
    hero.x=levels[hero.lvl][11]
    hero.y=levels[hero.lvl][12]
  else -- if cheat isn't on restart level position
      hero.x=levels[hero.lvl][11]
      hero.y=levels[hero.lvl][12]
      --    was hero.sx=hero.x & hero.sy=hero.y
    end
  end

  if not hero.mov then -- animation
    if climb==false then
      hero.sp = hero.ini
    else hero.sp = hero.cli
    end
  end
  if cheat[2]==0 then
    enemy_update()
  end
  travel_update()

  -- find fading platform wait time
  maxwidth = 3
  for widthloop = 1,levels[hero.lvl][10] do
    width = templatforms[hero.lvl][widthloop][3]
      if width > maxwidth then
        maxwidth = width
        -- find longest fading platform for level
      end
  end
  fadewait = 2+(maxwidth-3)
  -- add platform specific timing later?
  printh(fadewait)
  if (time() % fadewait)==0 then -- was % 3
    tempon=true
  end
  fademax = fadewait*2
  if (time() % (fadewait*2))==0 then -- was % 6
    tempon=false
  end

  if hero.lives==0 then
    mode = 9 -- death screen
  end
  if hero.treas==125 then
    mode =6
  end
--    print("you are dead")
--    wait(30)
--  end
end -- gameupdate / movement end

function deldoor()
  sfx(13)
  fset(dsprite,0) -- remove flag
  doors[hero.lvl][dnum][3]=0 -- change array
  mset(doors[hero.lvl][dnum][1],doors[hero.lvl][dnum][2],1)
  mset(doors[hero.lvl][dnum][1],doors[hero.lvl][dnum][2]+1,0)
  mset(doors[hero.lvl][dnum][1],(doors[hero.lvl][dnum][2])+2,0)
  hero.keyheld=0
end

function enemy_move(pisprite)
  pirate.mov = true
  pirate.sp += 1
  if pirate.sp > pisprite+pirate.ani then
    pirate.sp = pisprite
  end
end

function enemy_update()
-- if (time() % 0.25)==0 then -- too slow
  if slow(5) then
    for enemies = 1,levels[hero.lvl][5] do -- add y
      pirate.mov = false
      if pilocate[hero.lvl][enemies][3]==false then -- facing & moving right
        pilocate[hero.lvl][enemies][1]-=pirate.spd
        enemy_move(pirate.ini)
      end
      if pilocate[hero.lvl][enemies][3]==true then -- facing & moving left
        pilocate[hero.lvl][enemies][1]+=pirate.spd
        enemy_move(pirate.ini)
      end

      piy = pilocate[hero.lvl][enemies][2]
      pix = pilocate[hero.lvl][enemies][1]
      for platloop = 1, levels[hero.lvl][10] do
      -- go through templatforms
        gapy = templatforms[hero.lvl][platloop][2]
        -- account for level +y?
        gapleft = templatforms[hero.lvl][platloop][1] - 4
        -- account for level +x?
        gaplen = templatforms[hero.lvl][platloop][3] * 8
        gapright = gapleft + gaplen
        -- account for level +x?
        if gapy==piy + pirate.h*8 then
        -- if gap on platform pirate walks on
          if pix == gapright then
            pilocate[hero.lvl][enemies][3]=true
          end
          if pix == gapleft then
            pilocate[hero.lvl][enemies][3]=false
          end
        end
      end

--     if at top right ... turn around -- was 4+levels[hero.lvl][6]*8
      if  tile_at(pilocate[hero.lvl][enemies][1]+4+levels[hero.lvl][6]*8,
        pilocate[hero.lvl][enemies][2]-8 + levels[hero.lvl][7]*8)>=60 and
        tile_at(pilocate[hero.lvl][enemies][1]+4+levels[hero.lvl][6]*8,
        pilocate[hero.lvl][enemies][2]-8 + levels[hero.lvl][7]*8)<=68 then
        pilocate[hero.lvl][enemies][3]=false
        test=true
      end -- should have used same function for player & pirate!
--     if at top left ... turn around
      if tile_at(pilocate[hero.lvl][enemies][1]-1+levels[hero.lvl][6]*8,
        pilocate[hero.lvl][enemies][2]-1 + levels[hero.lvl][7]*8)>=60 and
        tile_at(pilocate[hero.lvl][enemies][1]-1+levels[hero.lvl][6]*8,
        pilocate[hero.lvl][enemies][2]-1 + levels[hero.lvl][7]*8)<=68 then
        pilocate[hero.lvl][enemies][3]=true
      end
      if pilocate[hero.lvl][enemies][1] <= 1 then
        pilocate[hero.lvl][enemies][1] = 1
        pilocate[hero.lvl][enemies][3]=true
      end
      if pilocate[hero.lvl][enemies][1] >= 120 then
        pilocate[hero.lvl][enemies][1] = 120-pirate.w -- *8
        pilocate[hero.lvl][enemies][3]=false
      end
      if not pirate.mov then
        pirate.sp = pirate.ini
      end
    end
  end
end

function travel_update()
  -- moving platforms - defunct
  if not cheat[6]==1 then
    for rideloop = 1,levels[hero.lvl][8] do

      if hero.y+hero.h==travs[hero.lvl][rideloop][2] then
      -- if player on same level (y) as platform

        if hero.ron==true then -- test if move off platform
          if travs[hero.lvl][rideloop][6]==1 then
          -- if platform width is 1
            if hero.rx >= 5 or hero.rx <= -5 then
            -- test where player is on platform
            -- 5 assumes 8 width/2+1 - only made for single width
              hero.ron=false
            end
          end
          if travs[hero.lvl][rideloop][6]==2 then -- fixme - add into or or else?
          -- if platform width is 2
            if hero.rx >= 5 or hero.rx <= -15 then
              hero.ron=false
            end
          end
        end -- end of move off platform check

        -- player getting on to traveling platform (still part of if above)
        if hero.ron==false then -- fixme - also need to account for moving between moving platforms?
        -- only works for heading right so far
          if hero.x <= travs[hero.lvl][rideloop][3] then
          -- check if left of traveling platform
            if hero.x == travs[hero.lvl][rideloop][1]-4 then
            -- if player x >= traveling x - player width
              hero.ron=true
              hero.rx=travs[hero.lvl][rideloop][1]-hero.x
              -- riding x = travel platform x - player x
            end
          end
        end -- end of left to right check

        if hero.x >= travs[hero.lvl][rideloop][4] then -- (still part of if above)
        -- check if right of traveling platform
          if travs[hero.lvl][rideloop][6]==1 then
            if hero.x == travs[hero.lvl][rideloop][1]+4 then -- right to left
              hero.ron=true
              hero.rx=travs[hero.lvl][rideloop][1]-hero.x
              -- riding x = travel platform x - player x
            end
          end
          if travs[hero.lvl][rideloop][6]==2 then
            if hero.x-8 == travs[hero.lvl][rideloop][1]+4 then -- right to left
              hero.ron=true
              hero.rx=travs[hero.lvl][rideloop][1]-hero.x
              -- riding x = travel platform x - player x
            end
          end
        end -- end of right to left check
      end -- end of level check
    end -- end of travelator loop
  end
-- fixme - remove when replaced
  if not cheat[6]==1 then
    for liftloop = 1,levels[hero.lvl][9] do
        -- if hero.x==lifts[hero.lvl][liftloop][1] then
        -- if at x co-ord - fixme needs larger range
        if hero.x == lifts[hero.lvl][liftloop][1]-4 then
        -- if to left moving right and stepping over edge
          if hero.y+hero.h==lifts[hero.lvl][liftloop][2] then
          -- if at y co-ord - fixme needs a little finese
            lifttravel=true
          end
          if lifttravel==true then
            hero.y = lifts[hero.lvl][liftloop][2]-hero.h
            -- seems simplest way - fixme - add to draw?
        end
      end
    end
  end -- end of travel_update function
end

function tile_at(x,y)
  return fget(mget(flr(x/8),flr(y/8)))
end

function collision()
--  beneath=fget(mget(hero.x+levels[hero.lvl][6]*8,hero.y+hero.h)) - bottom half of hero / test x+1
  topleft=tile_at(hero.x+levels[hero.lvl][6]*8,hero.y-1+levels[hero.lvl][7]*8) -- door left - was x-1
-- was topleft=tile_at(hero.x-1,hero.y-1) -- door left - was -8
  topright=tile_at(hero.x+hero.w/2+levels[hero.lvl][6]*8,hero.y-8+levels[hero.lvl][7]*8) -- door right
-- was topright=tile_at(hero.x+8,hero.y-8)
floor_below = tile_at( hero.x, hero.y+hero.h )
floor_tile_below = tile_at(hero.x+levels[hero.lvl][6]*8, hero.y+hero.h+levels[hero.lvl][7]*8 )
  platform = hero.y==8 or hero.y==32 or hero.y==56 or hero.y==80
   or hero.y==136 or hero.y==160 or hero.y==184 or hero.y==208
    or hero.y==264 or hero.y==288 or hero.y==312 or hero.y==336
  -- dumb way fixme - but it worked - fix later?
  ladder_d = tile_at (hero.x+hero.w-5+levels[hero.lvl][6]*8,hero.y+hero.h+levels[hero.lvl][7]*8)==2
-- was ladder_d = tile_at( hero.x+hero.w/2, hero.y+hero.h )==2
  ladder_u = tile_at(hero.x+hero.w-5+levels[hero.lvl][6]*8,hero.y+(hero.h-1)+levels[hero.lvl][7]*8 )==2
-- was  ladder_u = tile_at( hero.x+hero.w, hero.y+hero.h-1 )==2
  behind = tile_at(hero.x+levels[hero.lvl][6]*8, hero.y+levels[hero.lvl][7]*8)
  -- for treasure & keys & exits?
  if cheat[2]==0 then
    for enemies = 1,levels[hero.lvl][5] do
    -- if pirate hits into you die
      if pilocate[hero.lvl][enemies][1]==hero.x and pilocate[hero.lvl][enemies][2]==hero.y then
        hero.lives-=1
        sfx(10)
        wait(1)
        hero.x=levels[hero.lvl][11]
        hero.y=levels[hero.lvl][12]
      end
    end
  end

  if not (topleft==0) and (topleft>=60 and topleft<=69) then
  -- if door to left
    dnum=(topleft-59)
    dsprite=(topleft-55)
    if hero.keyheld==topleft-59 then
      keydb[hero.lvl][hero.keyheld][3]=2
      deldoor()
    else hero.x+=1
    end
  end
  if not (topright==0) and (topright>=60 and topright<=69) then
  -- if door to right
    dnum=(topright-59)
    dsprite=(topright-55)
    if hero.keyheld==topright-59 then
      keydb[hero.lvl][hero.keyheld][3]=2
      deldoor()
    else hero.x-=1
    end
  end

  if not (behind==0) then
  -- pick up object
    if (behind>=34) and (behind<=44) then -- if treasure flag
      onum=(behind-33)
      booty[hero.lvl][onum][3]=0
      fset(behind,0)
      mset(booty[hero.lvl][onum][1],booty[hero.lvl][onum][2],0) -- added 16
      mset(booty[hero.lvl][onum][1],booty[hero.lvl][onum][2]+1,0)
      hero.treas+=1
      -- was it a trap?
      if trap==onum then -- if object is bomb
        bomb(trap)
      end
    end
    if (behind>=21) and (behind<=29) then
    -- if it's a key
      knum=(behind-20) -- which key is it? 1-8
      if not (hero.keyheld==0 or keydb[hero.lvl][hero.keyheld][3]==2) then
      -- if holding any key, or key used
        keydb[hero.lvl][hero.keyheld][3]=1 -- set that key back to unheld
      end
      keydb[hero.lvl][knum][3]=0 -- make unavailable
      fset(behind,0)
      mset(keydb[hero.lvl][knum][1],keydb[hero.lvl][knum][2],0)
      mset(keydb[hero.lvl][knum][1],keydb[hero.lvl][knum][2]+1,0)
      hero.keyheld=knum
    end
  end

if floor_tile_below==0 and tempon==false and climb==false then
  -- add if not riding platform
  if hero.death==false then
    hero.death=true
--    fall()
  end
end

end -- collision end

function objects()
  if cheat[3]==0 then
  -- place keys
    for keys = 1,levels[hero.lvl][3] do
     if not (keydb[hero.lvl][keys][3]==0 or keydb[hero.lvl][keys][3]==2) then -- only if keys there
        fset(20+keys,20+keys)
        mset(keydb[hero.lvl][keys][1],keydb[hero.lvl][keys][2],20+keys)
        mset(keydb[hero.lvl][keys][1],(keydb[hero.lvl][keys][2]+1),20)
      end
    end
    -- place doors
    for doornum = 1,levels[hero.lvl][3] do
      if not (doors[hero.lvl][doornum][3]==0) then -- only if doors closed
        fset(4+doornum,59+doornum) -- door sprites from 5, flags from 60
        mset(doors[hero.lvl][doornum][1],doors[hero.lvl][doornum][2],4+doornum)
        mset(doors[hero.lvl][doornum][1],doors[hero.lvl][doornum][2]+1,4)
        mset(doors[hero.lvl][doornum][1],(doors[hero.lvl][doornum][2])+2,3)
      end
    end
  end
  -- place treasures
  for items = 1,levels[hero.lvl][2] do
    if not (booty[hero.lvl][items][3]==0) then
      fset(33+btype[hero.lvl][items],33+items)
      mset(booty[hero.lvl][items][1],booty[hero.lvl][items][2],btype[hero.lvl][items]+33)
--      fset(49+booty[hero.lvl][items][3],49+items) -- don't need?
      mset(booty[hero.lvl][items][1],booty[hero.lvl][items][2]+1,btype[hero.lvl][items]+49)
    end
    -- set random object to be trap
    trap=rnd(levels[hero.lvl][2])
    if hero.lvl==21 then trap=3 end -- test
  end
  -- move travelators - defunct
  if not cheat[6]==1 then
    for travloop = 1,levels[hero.lvl][8] do
      -- if traveling forward (dir=0)
      if travs[hero.lvl][travloop][5]==0 then
        travs[hero.lvl][travloop][1]+=1 -- increase platform x
      end
      -- if reach end of path start back the other way (dir=1)
      if travs[hero.lvl][travloop][1]==travs[hero.lvl][travloop][4] then
        travs[hero.lvl][travloop][5]=1
      end
      -- if traveling back (dir=1)
      if travs[hero.lvl][travloop][5]==1 then
        travs[hero.lvl][travloop][1]-=1 -- decrease platform x
      end
      -- if back at the start go forward again
      if travs[hero.lvl][travloop][1]==travs[hero.lvl][travloop][3] then
        travs[hero.lvl][travloop][5]=0
      end
    end
    -- move lifts - defunct
    for liftloop = 1, levels[hero.lvl][9] do
      -- if traveling downward (dir=0)
      if lifts[hero.lvl][liftloop][5]==0 then
        lifts[hero.lvl][liftloop][2]+=1 -- increase platform y
      end
      -- if reach end of path start back the other way (dir=1)
      if lifts[hero.lvl][liftloop][2]==lifts[hero.lvl][liftloop][4] then
        lifts[hero.lvl][liftloop][5]=1
      end
      -- if traveling back (dir=1)
      if lifts[hero.lvl][liftloop][5]==1 then
        lifts[hero.lvl][liftloop][2]-=1 -- decrease platform y
      end
      -- if back at the start go forward again
      if lifts[hero.lvl][liftloop][2]==lifts[hero.lvl][liftloop][3] then
        lifts[hero.lvl][liftloop][5]=0
      end
    end
  end -- objects end
end

function shuffle(items,num)
  for l = 1, num+1 do
    local rand1 = flr(rnd(num)+1)
    local rand2 = flr(rnd(num)+1)
    items[rand1], items[rand2] = items[rand2], items[rand1]
  end
  return(items)
end

-- unused booty tap code
function bomb(trap)
  -- place bomb where object was -
  cycle=time()
  trapx = booty[hero.lvl][trap][1]+16
  trapy = booty[hero.lvl][trap][2]+24
  spr(96,trapx,trapy)
  -- initial warning sound - 18
    sfx(18)
--    wait(45)
  if cycle==time()-3 then
  -- explosion animation and sound
  for l =1,3 do
--    zspr(96,1,1,96-8*l,72-8*l,l)
  sfx(16)
    zspr(96,1,1,trapx-8*1,trapy-8*1,l)
  end
end
  -- check for death - player hero.x / hero.y
  -- maybe call death as function
end

function zspr(n,w,h,dx,dy,dz)
-- from http://www.lexaloffle.com/bbs/?tid=2429
    sx = 8 * (n % 16)
    sy = 8 * flr(n / 16)
    sw = 8 * w
    sh = 8 * h
    dw = sw * dz
    dh = sh * dz
    sspr(sx,sy,sw,sh, dx,dy,dw,dh)
end

function titleinit() -- menu
  -- opening menu with thanks to http://pico-8.wikia.com/wiki/multiple_states_system
  mode = 0
    music(0)
  text = "bootyful demake"
  speed = 25
  height = 10
  tim = 0
end

function _draw() -- menu
  if (mode == 0) then --title screen mode
    titledraw()
  elseif (mode == 9) then
    deathdraw()
  elseif (mode == 6) then
    windraw()
  elseif (mode == 3) then
    helpdraw()
  else
    gamedraw()
  end
end

function titledraw() -- menu
  cls()
  sspr(56,32,8,8,0,0,128,94) -- sky
  circfill (110,48,8,10)-- sun
  -- wavy text - thanks to http://www.lexaloffle.com/bbs/?tid=28262
  tim += 1
  for i=0,#text,1 do -- moving title text
    print(sub(text,i,i),
    32+(i*4),
    16+sin((tim+i)/speed)*height,7)
  end
  sspr(57,45,22,24,32,40,66,72) -- ship
  sspr(64,32,8,8,0,94,128,24) -- water
  centre_print("press x to start",100)
  if (btn(5)) then
    gameinit()
  end
  color(10)
  centre_print("press z for help",108)
  color(7)
  if (btn(4)) then
    mode = 3
    helpdraw()
  end
  centre_print("nct 2017 / jfc 1984",120)
end -- title end

function windraw() -- menu
  cls()
  text = "congratulations"
  sspr(64,32,8,8,0,0,128,94) -- dark sky
  circfill (110,48,8,6)-- moon
  tim += 1
  for i=0,#text,1 do -- moving title text
    print(sub(text,i,i),
    32+(i*4),
    16+sin((tim+i)/speed)*height,7)
  end
  sspr(57,45,22,14,32,48,66,48) -- sunk ship
  sspr(72,32,8,8,0,94,128,24) -- black water
  color(10)
  centre_print("you have won!",104)
  color(7)
end -- title end

function _update() -- menu
  if (mode == 0) then --title screen mode
    titleupdate()
  elseif (mode == 9) then
    deathupdate()
  elseif (mode == 6) then
    winupdate()
  elseif (mode == 3) then
    helpupdate()
  else
    gameupdate()
  end
end

function deathdraw()
  cls()
  centre_print("you have died!",16)
  zspr(101,2,2,32,32,4)
  centre_print("press x to restart",110)
  wait(1)
  if (btn(5)) then
    wait(1)
    titleinit()
  end
end

-- remind me what these were for again?
function titleupdate() -- menu
end
function deathupdate()
end
function helpupdate()
end
function winupdate()
end

function helpdraw()
  cls()
  centre_print("collect booty to win the game",8)
  for bl=1,10 do
    spr(bl+33,16+bl*8,12,1,2) -- 34-44
  end
  centre_print("use keys to open doors",32)
  spr(21,8,28)
  spr(20,8,36)
  spr(5,112,28)
  spr(4,112,36)
  centre_print("climb ladders",48)
  spr(2,24,40)
  spr(2,24,48)
  centre_print("press x on exits",64)
  spr(61,100,48,2,1)
  spr(32,100,56,2,1)
  spr(48,100,64,2,1)
  centre_print("avoid pirates",80)
  spr(109,24,72,1,2,1)
  centre_print("cross disappearing platforms",96)
  -- stats()
  color(10)
  centre_print("press x to start",112)
  color(7)
  wait(1)
  if (btnp(5)) then
    wait(1)
    gameinit()
  end
end

function centre_print(strtxt,py) print(strtxt,64-(#strtxt*2),py) end

function _init() -- move to gameinit?
  titleinit() -- menu
end -- init end

function gameinit() -- menu
  mode = 1
  music(-1)
  world={mx=0,my=0,w=128,h=128} -- world mx changes according to level
  hero={x=70,y=8,w=8,h=16,sx=70,sy=8,ini=77,sp=77,cli=74,clisp=74,ani=2,spd=1,dr=true,
    keyheld=0,treas=0,lives=3,lvl=1,rx=0,ron=false,death=false}
  climb=false -- state={wlk,clm}
  tempon=true
  destex=0
  levl=99
  first=true
  levels={{1,6,8,3,2,0,0,0,0,0,70,8,0},
    {2,9,7,3,2,16,0,0,0,0,104,8,0},
    {3,7,0,3,1,32,0,3,0,3,16,8,0},
    {4,2,0,3,2,48,0,0,0,2,48,8,0},
    {5,6,6,3,1,64,0,0,0,2,80,80,0},
    {6,6,6,3,0,80,0,0,2,2,48,32,3},
    {7,10,6,3,0,96,0,0,0,0,24,8,0},
    {8,5,3,3,1,112,0,0,0,0,80,56,0},
    {9,10,6,3,0,0,16,0,2,8,64,8,3},
    {10,7,7,3,0,16,16,0,0,4,80,32,3},
    {11,7,5,3,1,32,16,0,0,4,64,8,3},
    {12,6,6,3,0,48,16,0,0,5,64,80,3},
    {13,7,6,3,1,64,16,0,0,0,48,8,0},
    {14,6,5,3,0,80,16,0,0,7,0,8,3},
    {15,4,3,3,2,96,16,0,0,3,48,8,2},
    {16,8,6,3,0,112,16,0,0,0,32,56,0},
    {17,4,5,3,1,0,32,0,0,10,16,32,3},
    {18,3,9,3,1,16,32,0,0,4,40,8,3},
    {19,7,7,3,1,32,32,0,0,0,48,8,0},
    {20,7,6,3,0,48,32,0,0,1,80,8,0},
    {21,4,2,2,2,64,32,0,0,4,18,80,0} -- issue with keys/doors & pirates
    }
   -- ref,booty,keys/doors, exits,pirates,initx, inity,travs,lifts
   -- + templatforms & inipx,inipy, alt ladders
  keydb={{{12,7,1},{9,10,1},{0,7,1},{6,1,1},{0,10,1},{5,7,1},{6,4,1},{2,1,1},{7,1,1}}, -- 1
    {{16,10,1},{31,1,1},{29,10,1},{21,1,1},{31,4,1},{20,1,1},{20,10,1}}, -- 2
    {{0,0,0}},{{0,0,0}}, -- 3-4
    {{79,4,1},{70,1,1},{68,10,1},{64,10,1},{70,4,1},{68,4,1}}, -- 5
    {{86,7,1},{95,4,1},{81,10,1},{85,10,1},{81,1,1},{85,1,1}}, -- 6
    {{96,7,1},{109,4,1},{96,10,1},{103,1,1},{111,7,1},{111,1,1}}, -- 7
    {{123,4,1},{127,10,1},{121,7,1}}, -- 8
    {{15,17,1},{0,23,1},{15,20,1},{0,17,1},{15,26,1},{9,23,1}}, -- 9
    {{16,26,1},{27,26,1},{17,17,1},{31,17,1},{16,17,1},{25,17,1},{26,23,1}}, -- 10
    {{32,23,1},{47,26,1},{38,20,1},{32,17,1},{40,23,1}}, -- 11
    {{63,17,1},{48,23,1},{50,20,1},{48,26,1},{62,20,1},{48,17,1}}, -- 12
    {{64,20,1},{79,26,1},{67,17,1},{75,26,1},{71,23,1},{79,23,1}}, -- 13
    {{90,23,1},{93,17,1},{95,23,1},{80,23,1},{90,26,1}}, -- 14
    {{98,23,1},{111,20,1},{98,20,1}}, -- 15
    {{119,17,1},{117,17,1},{126,17,1},{125,26,1},{121,23,1},{118,23,1}}, -- 16
    {{13,42,1},{13,39,1},{00,39,1},{15,33,1},{00,33,1}}, -- 17
    {{21,39,1},{16,42,1},{19,42,1},{18,39,1},{20,36,1},{31,39,1},{18,33,1},{31,36,1},{31,33,1}}, -- 18
    {{32,42,1},{45,39,1},{42,33,1},{47,33,1},{32,33,1},{46,36,1},{34,36,1}}, -- 19
    {{54,36,1},{62,39,1},{49,42,1},{48,33,1},{63,36,1},{63,33,1}}, -- 20
    {{77,42,1},{73,33,1}} -- 21
    } -- key placement - x,y,present
  doors={{{5,0,1},{10,0,1},{5,3,1},{10,3,1},{4,6,1},{10,6,1},{5,9,1},{10,9,1}}, -- 1
    {{18,0,1},{27,0,1},{19,3,1},{24,3,1},{23,6,1},{19,9,1},{27,9,1}}, -- 2
    {{0,0,0}},{{0,0,0}}, -- 3-4
    {{69,0,1},{75,0,1},{69,3,1},{73,3,1},{67,9,1},{71,9,1}}, -- 5
    {{83,0,1},{88,0,1},{83,6,1},{87,6,1},{84,9,1},{88,9,1}}, -- 6
    {{102,0,1},{106,0,1},{107,3,1},{101,6,1},{101,9,1},{109,9,1}}, -- 7
    {{123,0,1},{124,6,1},{124,9,1}}, -- 8
    {{2,16,1},{12,16,1},{2,19,1},{13,19,1},{2,22,1},{12,25,1}}, -- 9
    {{24,16,1},{27,16,1},{29,16,1},{25,22,1},{27,22,1},{26,25,1},{29,25,1}}, -- 10
    {{39,19,1},{44,19,1},{33,22,1},{39,22,1},{42,25,1}}, -- 11
    {{51,16,1},{61,16,1},{61,19,1},{61,22,1},{50,25,1},{61,25,1}}, -- 12
    {{66,16,1},{66,19,1},{76,19,1},{72,22,1},{72,25,1},{76,25,1}}, -- 13
    {{90,19,1},{92,19,1},{94,19,1},{89,22,1},{92,22,1}}, -- 14
    {{109,16,1},{102,19,1},{100,25,1}}, -- 15
    {{118,16,1},{123,16,1},{118,19,1},{119,22,1},{123,22,1},{123,25,1}}, -- 16
    {{9,32,1},{11,32,1},{13,32,1},{9,41,1},{11,41,1}}, -- 17
    {{30,32,1},{19,35,1},{21,35,1},{30,35,1},{20,38,1},{22,38,1},{30,38,1},{18,41,1},{21,41,1}}, -- 18
    {{35,32,1},{43,32,1},{35,35,1},{44,35,1},{39,38,1},{36,41,1},{40,41,1}}, -- 19
    {{52,32,1},{61,32,1},{50,35,1},{53,35,1},{59,38,1},{59,41,1}}, -- 20
    {{69,32,1},{69,41,1}}
    } -- doors x,y,closed/open
  exits={{{104,8,2,1},{8,56,13,3},{112,80,5,3}}, -- x,y,lev,door
    {{104,8,1,1},{96,32,3,2},{72,80,10,2}}, -- 2
    {{72,32,4,3},{96,32,2,2},{16,80,9,3}}, -- 3
    {{8,8,10,1},{112,8,11,1},{72,32,3,1}}, -- 4
    {{64,8,20,1},{24,32,6,2},{104,80,1,3}}, -- 5
    {{8,32,5,2},{104,32,7,2},{72,80,8,3}}, -- 6
    {{72,32,8,2},{112,32,6,2},{16,56,12,2}}, -- 7
    {{32,32,15,1},{64,32,7,1},{64,80,6,3}}, -- 8
    {{64,8,16,1},{112,56,19,2},{16,80,3,3}}, -- 9
    {{4,8,4,1},{112,32,20,2},{64,80,2,3}}, -- 10
    {{112,8,4,2},{4,32,12,1},{4,80,20,3}}, -- 11
    {{4,32,11,2},{16,56,7,3},{112,80,18,3}}, -- 12
    {{112,8,14,1},{24,32,17,2},{8,56,1,2}}, -- 13
    {{4,32,19,1},{112,8,13,1},{96,80,15,3}}, -- 14
    {{24,32,8,1},{24,56,16,2},{96,80,14,3}}, -- 15
    {{64,8,9,1},{32,56,15,2},{112,80,17,3}}, -- 16
    {{8,8,18,1},{40,32,13,2},{112,80,16,3}}, -- 17
    {{4,8,17,1},{48,80,19,3},{112,80,12,3}}, -- 18
    {{4,32,14,2},{112,56,9,2},{48,80,18,2}}, -- 19
    {{56,8,5,1},{104,32,10,2},{16,80,11,3}}, -- 20
    {{4,32,21,2},{112,80,21,1}}
    } -- make sure to test whole width - x,y,where leads
  booty={{{1,1,4},{0,4,5},{14,4,3},{3,7,2},{6,10,7},{13,10,1}},
    {{16,1,3},{26,1,2},{28,1,6},{23,4,9},{30,4,4},{17,7,5},{25,7,8},{18,10,6},{21,10,7}},
    {{32,1,1},{45,1,6},{34,4,10},{34,7,2},{45,7,3},{39,10,11},{44,10,9}},
    {{58,7,1},{57,10,1}}, -- 4
    {{68,1,1},{78,1,2},{71,4,3},{74,4,4},{65,10,5},{70,10,6}}, -- 5
    {{82,1,1},{84,1,1},{82,7,1},{85,7,1},{82,10,1},{86,10,1}}, -- 6
    {{100,1,1},{108,1,2},{98,4,3},{103,4,4},{108,4,5},{97,7,1},{102,7,1},{100,10,1},{105,10,1},{110,10,1}}, -- 7
    {{122,1,1},{127,1,1},{117,4,1},{127,7,1},{126,10,1}}, -- 8
    {{1,17,1},{6,17,1},{13,17,1},{1,20,1},{9,20,1},{14,20,1},{1,23,1},{6,23,1},{6,26,1},{1,26,10}}, -- 9
    {{26,17,1},{28,17,1},{30,17,1},{28,20,1},{30,23,1},{28,26,1},{30,26,1}}, -- 10
    {{34,17,1},{45,17,1},{45,20,1},{34,23,1},{46,23,1},{38,26,1},{45,26,1}}, -- 11
    {{50,17,1},{62,17,1},{51,20,1},{49,26,1},{54,26,1},{62,23,1}}, -- 12
    {{65,17,1},{65,20,1},{77,20,1},{75,23,1},{77,23,1},{74,26,1},{77,26,1}}, -- 13
    {{92,17,1},{91,20,1},{95,20,1},{91,23,1},{80,26,1},{89,26,1}}, -- 14
    {{98,17,1},{110,17,1},{110,23,1},{98,26,1}}, -- 15
    {{115,17,1},{127,17,1},{116,20,1},{124,20,1},{120,23,1},{124,23,1},{116,26,1},{124,26,1}}, -- 16
    {{10,33,1},{14,33,1},{15,39,1},{1,42,1}}, -- 17
    {{17,36,1},{19,39,1},{17,42,1}}, -- 18
    {{34,33,1},{41,33,1},{45,36,1},{36,39,1},{44,39,1},{33,42,1},{41,42,1}}, -- 19
    {{53,33,1},{62,33,1},{48,36,1},{52,36,1},{55,36,1},{48,39,1},{60,42,1}}, -- 20
    {{68,33,1},{79,33,1},{75,39,1},{76,42,1}}
    } -- treasure placement - x,y,type/taken (0)
    -- randomize booty - adds variation & gets over duplicate booty bug
    btype={{}} -- booty type
    brange={1,2,3,4,5,6,7,8,9,10,11}
    for l=1,22 do -- num of lvls = 21
      shuffle(brange,#brange)
    	for m=1,11 do
        btype[l]=brange
      end
    end
  -- replacement data for disappearing platforms (in place of moving ones)
  templatforms={
    {{}}, -- 1
    {{}}, -- 2
    {{32,24,7,0,0},{32,48,7,0,0},{32,72,7,0,0}}, -- 3
    {{40,48,4,2,0},{40,72,4,2,0}}, -- 4
    {{32,72,2,1,0},{64,72,1,1,0}}, -- 5
    {{88,48,1,1,0},{96,96,1,1,0}}, -- 6
    {{}}, -- 7
    {{}}, -- 8
    {{32,24,1,0,0},{32,48,1,0,0},{32,72,1,0,0},{32,96,1,0,0},{80,24,1,0,0},{80,48,1,0,0},{80,72,1,0,0},{80,96,1,0,0}}, -- 9
    {{24,24,5,0,0},{16,48,5,0,0},{16,72,5,0,0},{16,96,5,0,0}}, -- 10
    {{32,24,1,0,0},{32,48,1,0,0},{32,72,1,0,0},{32,96,1,0,0}}, -- 11
    {{32,24,7,0,0},{32,48,7,0,0},{32,72,7,0,0},{32,96,1,0,0},{80,96,1,0,0}}, -- 12
    {{}}, -- 13
    {{16,24,1,0,0},{16,48,1,0,0},{16,72,1,0,0},{16,96,1,0,0},{48,24,2,0,0},{48,48,2,0,0},{48,72,2,0,0}}, -- 14
    {{64,24,4,0,0},{64,48,4,0,0},{88,72,1,0,0}}, -- 15
    -- was {{64,24,1,0,0},{64,48,1,0,0},{88,24,1,0,0},{88,48,1,0,0},{88,72,1,0,0}}
    {{}}, -- 16
    {{24,24,5,0,0},{24,48,1,0,0},{24,72,1,0,0},{24,96,1,0,0},{56,48,1,0,0},{56,72,1,0,0},{56,96,1,0,0},{96,24,1,0,0},{96,48,1,0,0},{96,72,1,0,0}}, -- 17
    {{64,24,4,0,0},{64,48,4,0,0},{64,72,4,0,0},{64,96,4,0,0}}, -- 18
    {{}}, -- 19
    {{64,72,2,1,0}}, -- 20
    {{48,24,3,0,0},{88,24,2,0,0},{16,48,2,1,0},{88,48,2,0,0}}
  } -- xstart,y,width,default,state
  -- replacement data for abscence of lifts
  altladders={
    {{}},{{}},{{}},{{}},{{}}, -- 1-5
      {{90,3},{88,6},{91,9}}, -- 6b
    {{}},{{}}, -- 7-8
      {{3,19},{12,22},{7,25}}, -- 9b
      {{18,19},{24,22},{17,25}}, -- 10b
      {{35,19},{38,22},{34,25}}, -- 11b
      {{60,19},{51,22},{55,25}}, -- 12b
    {{}}, -- 13
      {{89,19},{81,22},{85,25}}, -- 14b
      {{103,19},{109,22}}, -- 15b
    {{}}, -- 16
      {{2,35},{9,38},{12,41}}, -- 17b
      {{29,35},{23,38},{29,41}}, -- 18b
    {{}},{{}} -- 19-20
  }
  -- unused data for testing traveling platforms
  travs={ {{0,0,0,0,0,0}}, -- 1
    {{0,0,0,0,0,0}}, -- 2
    {{32,24,32,88,0,1},{88,48,32,88,1,1},{32,72,32,88,0,1}}, --3
    {{0,0,0,0,0,0}}, -- 4
    {{0,0,0,0,0,0}}, -- 5
    {{0,0,0,0,0,0}}, -- 6
    {{0,0,0,0,0,0}}, -- 7
    {{}}, -- 8
    {{}}, -- 9
    {{}}, -- 10
    {{}}, -- 11
    {{}}, -- 12
    {{}}, -- 13
    {{}}, -- 14
    {{}}, -- 15
    {{}}, -- 16
    {{}}, -- 17
    {{}}, -- 18
    {{}}, -- 19
    {{}}, -- 20
    {{72,24,72,70,1,1}} -- 21
  } -- x,y,xstart,xend,dir,width
  -- unused data for testing lifts
  lifts={ {{0,0,0,0,0,0}}, -- 1
    {{0,0,0,0,0,0}}, -- 2
    {{0,0,0,0,0,0}}, -- 3
    {{0,0,0,0,0,0}}, -- 4
    {{0,0,0,0,0,0}}, -- 5
    {{88,24,24,96,0,1},{96,96,24,96,1,1}}, -- 6
    {{0,0,0,0,0,0}}, -- 7
    {{0,0,0,0,0,0}}, -- 8
    {{32,152,152,200,0,1},{80,200,200,152,1,1}}, -- 9
    {{}}, -- 10
    {{}}, -- 11
    {{}}, -- 12
    {{}}, -- 13
    {{}}, -- 14
    {{}}, -- 15
    {{}}, -- 16
    {{}}, -- 17
    {{}}, -- 18
    {{}}, -- 19
    {{}}, -- 20
    {{75,35,35,37,0,1},{76,37,37,35,1,1}} -- 21
  } -- x,y,ystart,yend,dir, width
  pilocate={{{0,80,true},{128,56,false}}, -- not tiles - should equal pixels!
    {{32,32,true},{0,56,false}},
    {{40,80,true}},
    {{80,56,true},{58,80,false}},
    {{80,32,false}}, -- 5
    {{9,4,false},{15,10,false}}, -- 6
    {{9,1,true},{15,7,true}}, -- pixels!
    {{1,80,0}}, -- 8
    {{}}, -- 9
    {{}}, -- 10
    {{33,80,false}}, -- 11
    {{}}, -- 12
    {{64,32,false}}, -- 13
    {{}}, -- 14
    {{16,8,false},{16,80,false}}, -- 15
    {{}}, -- 16
    {{80,80,false}}, -- 17
    {{16,56,false}}, -- 18
    {{120,32,false}}, -- 19
    {{}}, -- 20
    {{8,8,false},{48,56,true},{64,80,true}}
    } -- pirate start location x,y & facing
  pirate={w=1,h=2,ini=109,sp=109,ani=2,spd=1} -- pirate animation
  behind=0 topleft=0 topright=0 frames=0 test=false -- initialize misc variables
  cheat={1,0,0,0,0,1,0,1,0,0} -- cheats
  -- 1 - don't throw back to start - default/defunct
  -- 6 - all fade platforms - default
  -- 8 - no rats or birds - default/defunct
  -- note: these do not work perfectly, just used for testing
end

function wait(a) for i = 1,a do flip() end end -- fixme - replace

function slow(n)
  frames+=1
  if (frames % n == 0) then
    return true
  end
end

function timer(n)
  if (time() % n == 0) then
    return true
  end
end

__gfx__
000000008888888880000008008008000080080088888888888888888888888888888888888888888888888888888888888888888888888800aaa00088888888
00000000000880008000000800800800008008000088080000800800008008000080880000800800008008000080080000800800008008000aaaaa0000000000
00700700000000008888888800800800008008000088080000880800008808000080080000808800008088000088080000800800008008000000000000000000
0007700000000000800000080080080000800800008808000080080000800800008008000080080000800800008808000088880000800800a0a0a0a000000000
0007700000000000800000080080080000800800008808000080880000880800008808000088080000800800008088000080080000880800a0a0a0a000000000
0070070000000000800000080080080008800880008808000080080000800800008808000080080000800800008088000080080000880800a0a0a0a000000000
00000000000000008888888800800800008008000088880000888800008888000088880000888800008888000088880000888800008888000000000000000000
0000000000000000800000080080080000800800008008000080080000800800008008000080080000800800008008000080080000800800aaaaaaa000000000
88888888888888880000000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000aaa0a0000333000
000880000008800000077000066000000006600000666600006666000066660000666600006666000066660000666600006666000066660000a0a00003333300
00000000000000000007700060060000000666000066060000600600006006000060660000600600006006000060060000600600006006000000000033333330
00000000000000000000000060066666000660000066060000660600006606000060060000606600006066000066060000600600006006000a00aa0033333330
0000000000000000007777006006666600066600006606000060060000600600006006000060060000600600006606000066660000600600aa000aa033333330
0000003330000000070770706006060600000000006606000060660000660600006606000066060000600600006066000060060000660600aaa00aa033333330
00003333333000000007700006600000000000000066060000600600006006000066060000600600006006000060660000600600006606000a000a0033333330
000333000333000000700700000000000000000000666600006666000066660000666600006666000066660000666600006666000066660000a0a00033333330
00033003003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666666600000000
00330303030330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666666600000000
00330303030330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00330303033030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00330303300030000000000000000000000000000000000000000000000000000000000009990000000009a00a00000000900000000000000000000000000000
0030300303303000000a00000aaaaaa00aaa0a00000a0000000000000aaaaa0000999000aa00900000000000a9a000000aaaaa9a000000000000000000555000
00033303030330000aa0aa009aaaaaa00a0aaa0000a0a0009900000000aaa000000a0000a0aa09000099999a0a9aa000aaaaaa9a000000000000000005550500
0030300303303000aaaaaaa0aaaaaaa000aaa000000a0000999009000a0a0a00990a0990aaaaa090a099aaaa00aaa900aa09a000000000000000000055555050
0033030330003000000000009aa7a7a00000000000aaa00009099000a00a00a00a0a0a000aaa0a0990aa000000aa9aa0aa990000000000000000000000000000
0033030303303000a0a0a0a0aa7a7aa00aa0aa0000a0a000a09a0000a0aaa0a00a0a0a0000a000a00a099a900009aa0aaa000000000000000000000000666600
0033030303033000a0a0a0a0aaaaaaa0aa000aa00aaa0a00a9aaa0000aaaaa000a0a0a00000a0aaa09a9a9a00000a00aa9000000000000000000000000600600
0033030303033000a0a0a0a0aaaaaaa0aa00aaa00aaa0a00900aaa00aaaa0aa00aaaaa000000aaa0000a900000000aa09a000000000000000000000000600600
0000000000000000a0a0a0a09aaaaaa0aaa00aa0aaaaa0a0000aaaa0aaaa0aa000aaa00000000000000000000000000000000000000000000000000000600600
003333333333300000000000aaaaaaa00a000a00a00000a00000aaaa0aa0aa00000a000000000000000000000000000000000000000000333000000000600600
0033333333333000aaaaaaa09aaaaaa000a0a000aaa9aaa0000000aa00aaa0000099900000000000000000000000000000000000000033333330000000600600
0000000000000000000000000aaaaaa000000000000a0000000000000aaaaa000999990000000000000000000000000000000000000333000333000000666600
0000000088888888dddddddd00000000000000008888888888888888cccccccc1111111100cccc00000440000004400000044000000440000004400000044000
0000000000088000d000000000000005555550000008800000088000cccccccc111111110c1111c0a0444400a044440a0044440a00444a0000444a0000444a00
0000000000000000d0550dd000000005000050000000000000000000cccccccc11111111c1cc001ccc444400cc4444cc004444cc0044a0a00044a0a00044a0a0
0000000000000000d050dd0000000005055050000000000000000000cccccccc11111111c100001ccc04400acc0440cca00440cc004aaa00004aaa00004aaa00
0000000000000000d00dd05000000005000050000dddddddddddddd0cccccccc11111111c100001ccc8888cccc8888cccc8888cc000aa000000aa000000aa000
0055500000555000d0dd055000ddddddddddddd00dddddddddddddd0cccccccc11111111c100001ccc7777cccc7777cccc7777cc007007000070070000700700
0555050005550500d000000000ddddddddddddd00dd0000000000dd0cccccccc111111110c1111c00c8888c00c8888c00c8888c0008888800088888000888880
5555505055555050dddddddd00dd000000000dd00dddddddddddddd0cccccccc1111111100cccc00077777700777777007777770007c777000c777700077c770
000000005000000055555555555555555ddd0dd00dd0000000000dd0000000000000000000000000088888800888888008888880008c888000c888800088c880
555550505000000050000000500000005ddd0dd00dddddddddddddd0000000000000000000000000077777700777777007777770007c777000c777700077c770
555550505000000050555550505505505ddd0dd00dd0000000000dd00000000000000000000000000dddddd00dddddd00dddddd00088a880008a888000888a80
555550505000000050555550505055005ddd0dd00dddddddddddddd00000000000000000000000000dddddd00dddddd00dddddd0007777000077770000777700
0000000050000000505555505005505050000dd00dd0000000000dd00000000088000000000000000dd60dd00dd60dd00dd60dd0000d0d00000d0d00000d0d00
055505005000000050555550505505505dddddd00dddddddddddddd0000000000400000000000000ddd60dd00dd60dd00dd60ddd000d0d0000dd00d000d00dd0
005550005000000050000000500000005dddddd00dddddddddddddd000000000740000000000000000000dd00dd60dd00dd60000000d00d00dddd00d0d00dddd
0000000050000000555555555555555550000000000000000000000000000000740000880000000000000dddddd60dddddd60000000dddd000dddddd00dddddd
0090080000000a0060000000d0000000006660000660006666000660000000077400007400000000000000000000000000000000044444000444440004444400
00008009000aa9a060000000d0000000066666006060666666660606000000770400077400000000000009000000000000000000007444400074444000744440
0088880000000a9a60000000d00000006066606066066666666660660000000074000004000000000aa0990a0aa0000a0ddddddd000774400007744000077440
0880888000000a0060000000d0000000600600600066666666666600000000777400077400088000a0a99aaaa0a999aa0ddddddd007774400077744000777440
0800088000a0000060000000d00000006666666000660000000066000000076764007774000040000aaaaaa00aaaaaa00dd00000000444400004444000044440
0800088000a9a00060000000d000000066606660006600066000660000000776740777740007400000aaaa0000aaaa000ddddddd604447406044474000444740
08808880aa9a000060000000d000000006666600006600066000660000007767647777740077400000000000000000000dd00000600777006607770006077700
0088880000a0000060000000d000000006060600006666666666660000077777740000040000400000000000000000000ddddddd660222200602222000622220
00cccc0000cccc0000cccc0000cccc0000cccc000006666006666000000000000400000400000000000000000000000000000000662292200662922000669220
0c1111c00c1111c00c1111c00c1111c00c1111c00006666006666000044440000000000000444444000000000000000000000000066922200066922000066920
c1cccc1cc1cccc1cc1cccc1cc1cccc1cc1cccc1c00066666666660000444444444444444444444440000000000000000ddddddd0069222200069222000022220
c1cc001cc1cccc1cc1cccc1cc1cccc1cc1cccc1c00066606606660000444444444444444444444000000000000000000ddddddd0000222000002220000022200
c100001cc100cc1cc1cccc1cc100cc1cc1cccc1c006600000000660004444a4a44a4a44a4a444000005005050050050500000dd0000022000000220000002200
c100001cc100001cc1cc001cc100001cc1cccc1c66066606606660660044444444444444444400000850555008505550ddddddd000022200000022000000d220
0c1111c00c1111c00c1111c00c1111c00c1111c06060066666600606004444444444444444440000555555505555555000000dd000202d0000020200000d2220
00cccc0000cccc0000cccc0000cccc0000cccc0006600066660006600cccccccccccccccccccc0000055050000505500ddddddd002222dd00022220000dd2200
10011110101010101010101010101010011110101010101010101010101010101010101010101010101010101010101010101010101010011110101010101010
10101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00021200000000000000000000000000021200000000000000000000000000000000000000043444000000000000000000043444000000021200000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00031300000000000000000000000000031300000000000000000000000000000000000000053545000000000000000000053545000000031300000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010100000d3e3000010101000101010101010101010101000000000001010100111101020101010101010101010101010101010101010101010101020011110
01111010101000000010100000102010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000212000000000000000000000000000000000000000000000000000212000020000000000000000000000000000000000000000000000020021200
02120000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000313000000000000000000000000000000000000000000000000000313000020000000000000000000000000000000000000000000000020031300
0313000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000ff00000000000000
10101000001010000010101000101010101010101010101000000000001010101010101010101010101020101010011110101020101010101010101010101010
10100000101010101020100000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000004344400000000000000000000000000000000000000000000000000000000000020000000021200000020000025c70000000000000000
00000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000005354500000000000000000000000000000000000000000000000000000000000020000000031300000020000024351500000000000000
00000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101000001010000010101000100111101010101010011100000000001001111010101010100111101010201010101010100111201010100000001010101010
10201010101010101010101010100111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000212000000000000021200000000000002120000000000000212000000200000000000000212200000000000000000003444
00200000000000000000000000000212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000313000000000000031300000000000003130000000000000313000000200000000000000313200000000000000000003545
00200000000000000000000000000313000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101000001010000010101010101010101010101010101000000000001010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000051b1000000000000000000000000000051c1000000000000000000000000000051d1000000000000000000000000000061f3
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
00088000000880000008800000088000000880000088080000088000000880000008800000088000008008000008800000088000000880000008800000088000
00000000000000000000000000000000000000000088080000000000000000000000000000000000008808000000000000000000000000000000000000000000
00000000000000000000000000000000000000000088080000000000000000000000000000000000008008000000000000000000000000000000000000000000
00000000000000000000000000000000000000000088080000000000000000000000000000000000008088000000000000000000000000000000000000000000
00000000000000000000000000000000000000000088080000000000000000000000000000000000008008000000000000000000000000333000000000000000
00000000000000000000000000000000000000000088880000000000000000000000000000000000008888000000000000000000000033333330000000000000
00000000000000000000000000000000000000000080080000000000000000000000000000000000008008000000000000000000000333000333000000000000
00000000000000000000000000000000000000000080080000000000000000000000000004400000008008000000000000000000000330030033000000000000
000000000000000000666600000000000000000000800800006666000000000000000000a4440000008008000000000000000000003303030303300000000000
00000000000000000060060000000000000000000080080000606600000000000000000a0a440000008008000000000000000000003303030303300000000000
000000000000000000600600000000000000000000800800006006000000000000000000aaa40000008008000000000000000000003303030330300000000000
0000000000000000006666000000000000000000008008000060060000000000000000000aa00000008008000000000000000000003303033000300000000000
000000000aaaaa000060060000000000000000000880088000660600000000000000000070070000088008800000000000000000003030030330300000000000
0000000000aaa0000060060000000000000000000080080000660600000000000000000888880000008008000000000000000000000333030303300000000000
000000000a0a0a000066660000000000000000000080080000666600000000000000000777c70000008008000000000000000000003030030330300000000000
00000000a00a00a00006600000000000000000000080080000066000000000000000000888c80000008008000000000000000000003303033000300000000000
00000000a0aaa0a00006600000000000000000000080080000066000000000000000000777c70000008008000000000000000000003303030330300000000000
000000000aaaaa00000666000000000000000000008008000006660000000000000000088a880000008008000000000000000000003303030303300000000000
00000000aaaa0aa00006600000000000000000000080080000066000000000000000000077770000008008000000000000000000003303030303300000000000
00000000aaaa0aa000066600000000000000000000800800000666000000000000000000d0d00000008008000000000000000000000000000000000000000000
000000000aa0aa0000000000000000000000000000800800000000000000000000000000d0d00000008008000000000000000000003333333333300000000000
0000000000aaa0000000000000000000000000000080080000000000000000000000000d00d00000008008000000000000000000003333333333300000000000
000000000aaaaa000000000000000000000000000080080000000000000000000000000dddd00000008008000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888000000888888888888888888888888888888888888888888888888888888888
00088000000880000008800000088000000880000080080000088000000880008000000800088000008088000008800000088000000880000008800000088000
00000000000000000000000000000000000000000088080000000000000000008888888800000000008008000000000000000000000000000000000000000000
00000000000000000000000000000000000000000080080000000000000000008000000800000000008008000000000000000000000000000000000000000000
00000000000000000000000000000000000000000088080000000000000000008000000800000000008808000000000000000000000000000000000000000000
00000000000000000000000000000000000000000080080000000000000000008000000800000000008808000000000000000000000000000000000000000000
00000000000000000000000000000000000000000088880000000000000000008888888800000000008888000000000000000000000000000000000000000000
00000000000000000000000000000000000000000080080000000000000000008000000800000000008008000000000000000000000000000000000000000000
00000000000000000000000000000000000000000080080000000000000000008000000800000000008008000000000000000000000000000000000000000000
00000000000000000000000555555000000000000080080000666600000000008000000800000000008008000000000000000000000000000000000000000000
00000000000000000000000500005000000000000080080000600600000000008888888800000000008008000000000000000000000000000000000000000000
00000000000000000000000505505000000000000080080000660600000000008000000800000000008008000000000000000000000000000000000000000000
0999000000000000000000050000500000000000008008000066060000000000800000080000000000800800000000000000000000000000000009a000000000
aa0090000055500000ddddddddddddd0000000000880088000606600000000008000000800000000088008800000000000000000000000000000000000000000
a0aa09000555050000ddddddddddddd0000000000080080000606600000000008888888800000000008008000000000000000000000000000099999a00000000
aaaaa0905555505000dd000000000dd000000000008008000066660000000000800000080000000000800800000000000000000000000000a099aaaa00000000
0aaa0a0900000000555555555ddd0dd00000000000800800000660000000000080000008000000000080080000000000000000000000000090aa000000000000
00a000a055555050500000005ddd0dd0000000000080080000066000000000008000000800000000008008000000000000000000000000000a099a9000000000
000a0aaa55555050505505505ddd0dd00000000000800800000666000000000088888888000000000080080000000000000000000000000009a9a9a000000000
0000aaa055555050505055005ddd0dd000000000008008000006600000000000800000080000000000800800000000000000000000000000000a900000000000
00000000000000005005505050000dd0000000000080080000066600000000008000000800000000008008000000000000000000000000000000000000000000
0000000005550500505505505dddddd0000000000080080000000000000000008000000800000000008008000000000000000000000000000000000000000000
0000000000555000500000005dddddd0000000000080080000000000000000008888888800000000008008000000000000000000000000000000000000000000
00000000000000005555555550000000000000000080080000000000000000008000000800000000008008000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888880000008888888888888888888888888888888888888888888888888888888888888888888888888
00088000000880000008800000088000008008000008800080000008000880000008800000088000008008000008800000088000000880000008800000088000
00000000000000000000000000000000008088000000000088888888000000000000000000000000008088000000000000000000000000000000000000000000
00000000000000000000000000000000008008000000000080000008000000000000000000000000008008000000000000000000000000000000000000000000
000000000000000000000000000000000088080000000000800000080dddddddddddddd000000000008008000000000000000000000000000000000000000000
000000000000003330000000000000000080080000000000800000080dddddddddddddd000000000008008000000000000000000000000000000000000000000
000000000000333333300000000000000088880000000000888888880dd0000000000dd000000000008888000000000000000000000000000000000000000000
000000000003330003330000000000000080080000000000800000080dddddddddddddd000000000008008000000000000000000000000000000000000000000
000000000003300300330000000000000080080000000000800000080dd0000000000dd000000000008008000000000000444440000000000000000000000000
006666000033030303033000000000000080080000666600800000080dddddddddddddd000000000008008000000000000674444000000000000000000000000
006006000033030303033000000000000080080000600600888888880dd0000000000dd000000000008008000000000000667744000000000000000000000000
006606000033030303303000000000000080080000606600800000080dddddddddddddd000000000008008000000000000677744000000000000000000000000
006006000033030330003000000000000080080000600600800000080dd0000000000dd000000000008008000000000000664444000000000000000000000000
0066060000303003033030000aaaaaa00880088000600600800000080dddddddddddddd000000000088008800000000006644474000000000000000000000000
0060060000033303030330009aaaaaa00080080000600600888888880dddddddddddddd000000000008008000000000006667770000000000000000000000000
006666000030300303303000aaaaaaa0008008000066660080000008000000000000000000000000008008000000000000662222000000000000000000000000
0006600000330303300030009aa7a7a0008008000006600080000008ddddddddddddddddd0000000008008000000000000662922000000000000000000000000
000660000033030303303000aa7a7aa0008008000006600080000008d0000000d0000000d0000000008008000000000000066922000000000000000000000000
000666000033030303033000aaaaaaa0008008000006660088888888d0550dd0d0550dd0d0000000008008000000000000069222000000000000000000000000
000660000033030303033000aaaaaaa0008008000006600080000008d050dd00d050dd00d0000000008008000000000000062220000000000000000000000000
0006660000000000000000009aaaaaa0008008000006660080000008d00dd050d00dd050d0000000008008000000000000066220000000000000000000000000
000000000033333333333000aaaaaaa0008008000000000080000008d0dd0550d0dd0550d0000000008008000000000000000220000000000000000000000000
0000000000333333333330009aaaaaa0008008000000000088888888d0000000d0000000d0000000008008000000000000002020000000000000000000000000
0000000000000000000000000aaaaaa0008008000000000080000008ddddddddddddddddd0000000008008000000000000022220000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888000000888888888888888888888888888888888888888888888888888888888
00088000000880000008800000088000000880000080080000088000000880008000000800088000008008000008800000088000000880000008800000088000
00000000000000000000000000000000000000000088080000000000000000008888888800000000008008000000000000000000000000000000000000000000
00000000000000000000000000000000000000000088080000000000000000008000000800000000008888000000000000000000000000000000000000000000
00000000000000000000000000000000000000000080880000000000000000008000000800000000008008000000000000000000000000000000000000000000
00000000000000000000000000000000000000000080880000000000000000008000000800000000008008000000000000000000000000000000003330000000
00000000000000000000000000000000000000000088880000000000000000008888888800000000008888000000000000000000000000000000333333300000
00000000000000000000000000000000000000000080080000000000000000008000000800000000008008000000000000000000000000000003330003330000
00000000000000000000000004444400000000000080080000000000000000008000000800000000008008000000000000000000000000000003300300330000
00666600000000000000000044447000000000000080080000000000000000008000000800666600008008000000000000000000000000000033030303033000
00600600000000000000000044770000000000000080080000000000000000008888888800600600008008000000000000000000000000000033030303033000
00606600000000000000000044777000000000000080080000000000000000008000000800660600008008000000000000000000000000000033030303303000
00600600000000000000000044440000000000000080080000000000000000008000000800600600008008000000000000000000009000000033030330003000
006606000000000000000000474440600000000008800880000a00000000000080000008006066000880088000000000000000000aaaaa9a0030300303303000
0060060000000000000000000777066000000000008008000aa0aa00000000008888888800600600008008000000000000000000aaaaaa9a0003330303033000
006666000000000000000000222206000000000000800800aaaaaaa0000000008000000800666600008008000000000000000000aa09a0000030300303303000
00066000000000000000000022926600000000000080080000000000000000008000000800066000008008000000000000000000aa9900000033030330003000
000660000000000000000000229660000000000000800800a0a0a0a0000000008000000800066000008008000000000000000000aa0000000033030303303000
000666000000000000000000222960000000000000800800a0a0a0a0000000008888888800066600008008000000000000000000a90000000033030303033000
000660000000000000000000022200000000000000800800a0a0a0a00000000080000008000660000080080000000000000000009a0000000033030303033000
000666000000000000000000022000000000000000800800a0a0a0a0000000008000000800066600008008000000000000000000000000000000000000000000
00000000000000000000000002200000000000000080080000000000000000008000000800000000008008000000000000000000000000000033333333333000
000000000000000000000000020200000000000000800800aaaaaaa0000000008888888800000000008008000000000000000000000000000033333333333000
00000000000000000000000002222000000000000080080000000000000000008000000800000000008008000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
00088000000880000008800000088000000880000008800000088000000880000008800000088000000880000008800000088000000880000008800000088000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000aaa0a00000000000000000000aaa00000000000000000000000000000333000
000000000000000007700000077000000770000006600000000000000000000000a0a00000000000000000000aaaaa0000000000000000000000000003333300
a0007700000000000770000007700000077000006006000000000007770000000000000000000077700000000000000000000077007770777000000033333330
a0000700000000000000000000000000000000006006666600000007070000000a00aa000000007070000000a0a0a0a000000007000070700000000033333330
a000070000000000777700007777000077770000600666660000000707000000aa000aa00000007070000000a0a0a0a000000007007770777000000033333330
a000070000000007077070070770700707707000600606060000000707000000aaa00aa00000007070000000a0a0a0a000000007007000007000000033333330
aaa07770000000000770000007700000077000000660000000000007770000000a000a0000000077700000000000000000000077707770777000000033333330
000000000000000070070000700700007007000000000000000000000000000000a0a0000000000000000000aaaaaaa000000000000000000000000033333330
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbb0bbb0bbb00bb00bb00000bbb00000bbb0bbb00000b0b00bb0b0b000000bb0bbb0bbb000000bb0bbb0b0b00bb0b0b00000000000000000
0000000000000000b0b0b0b0b000b000b000000000b000000b00b0000000b0b0b0b0b0b00000b000b0000b000000b0000b00b0b0b000b0b00000000000000000
0000000000000000bbb0bb00bb00bbb0bbb000000b0000000b00bb000000bbb0b0b0b0b00000b000bb000b000000bbb00b00b0b0b000bb000000000000000000
0000000000000000b000b0b0b00000b000b00000b00000000b00b000000000b0b0b0b0b00000b0b0b0000b00000000b00b00b0b0b000b0b00000000000000000
0000000000000000b000b0b0bbb0bb00bb000000bbb00000bbb0b0000000bbb0bb000bb00000bbb0bbb00b000000bb000b000bb00bb0b0b00000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000008880088008808880808088808080800000008800888088808880808088800000000000000000000000000000000000
00000000000000000000000000000000008080808080800800808080008080800000008080800088808080808080000000000000000000000000000000000000
00000000000000000000000000000000008800808080800800888088008080800000008080880080808880880088000000000000000000000000000000000000
00000000000000000000000000000000008080808080800800008080008080800000008080800080808080808080000000000000000000000000000000000000
00000000000000000000000000000000008880880088000800888080000880888000008880888080808080808088800000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0001020000010101010101010101000101010000000000000000000000000000c0c00100010000000000000000a00001c0c0000000000000000000000001010000010000000101000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000001000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010110110101010101010101454601010101101101010101010101010101010101010101011011014101410101014101410101101101454601010101011011010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
ff0000ffff00ff00ff0000ff002021ff0000000000000055560000000020210000006c7c000000000000000000000000202140504050400040504050400020210055560000000000202100000000000000000000000000000000000000000000426c7c0000000000000000000000000000000000000000000000000000000000
ff000000ff00ff00ff0000ff003031ff00000000000042634263000000303100005255525100000000000000000000003031500050005000500050005000303142514251000000003031000000000000000000000000000000000000000000005255525100000000000000000000000000000000000000000000000000000000
01010101010101010201010101010101010201010101010101010201101101010101010100000000003d3e00101102010101010201010101011011010101010101011011010101010101010102010101011011014546010101010100003d3e00010101010102010101101101010110110000003d3e0000001011010101010201
00404344ff00000002ff0000000000ffff02ffffffffffffffff02ff2021ffffffffffffffffffff00202100202102000000000200000000002021000000000000002021000000000000000002000000002021005556000000000000002021000000000000020000002021000000202100000020210000002021000000000200
00505354ff00000002ff0000000000ffff02ffffffffffff00ff02ff3031ffffffffffff00000000003031003031020000000002000000000030310000000000000030310000000000000000020000ff003031426300535100000000003031000000000000020000003031000000303100000030310000003031000000000200
0110110101010245460101010101010101010101010201010101010101010101010201010000000000000000010101010102010101000000000101010101020101020101010101010101010101010101010101010101010101010100000101010101101102010101010101010201010100000101010100000101010101020101
0020210000000255560000ff00ffffffffffffffff02ffffffffffff6c7cffffff02ffffffffffff00000000000000000002000000000000000000000000020000020000000000000000000000006c7c00000000000000004043440000000000000020210200000000526c7c0200000000000000000000000000000000020000
003031000000024242630000000000ffffffffffff02ffffffffff52555251ffff02ffffffffffff00000000000000000002000000000000000000000000020000020000000000000000000000525552000000000000000050535400000000000000303102000000004255560200000000000000000000000000000000020000
0101010101010101020101010101101101010101010101010110110101010201010110110000000000000000010102010101010201000000000101010201010101010101000001010000010201101101010101010101010101101100000000000101010101010101020101010101010100400040004000001011020101010101
00ffffffff0000ff020000ffff00202100000000000000000020210000000200000020210043440040434400000002000000000200004043440000000200000000000000000000000000000200202100000000000000000000202100000000000000000000000000020000000000000040504050405040002021020000000000
00ffffffff000000020000ff00003031000000000000ff000030310000000200000030310053540050535400000002000000000200005053540000000200000000000000000000000000000200303100000000000000000000303100000000000000000000000000020000000000000050005000500050003031020000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000001010101010101010101010101010101010101010101010101010101010101010101
000000ff00ffff00ffffff00ffff0015000000000000000000000000000000160000000000000000000000000000001700000000000000000000000000000018000000000000000000000000000000190000000000000000000000000000001a0000000000000000000000000000001b0000000000000000000000000000001c
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010110110101010101010101010101010101010101010101010101010101010101014101010101010110110101010101010101010101010101010101010101010145460101010101011011010101010101010101014101010110110101010101010101010101010101010101010101010101011011010101010101
00000000000000202100000000000000000000000000000000000000000000000000000000002f502f2f43440000202100000000000000000000000000000000000000006c7c555643440000000020210000000000000000002f502f000020210000000000000000000000000000000000000000000000002021000000000000
ffffffff00000030310000000000000000000000000000000000000000000000000000000000500050505354000030310000000000000000000000000000000000000000525642635354000000003031000000000000000000500050000030310000000000000000000000000000000000000000000000003031000000000000
0101010100000141010100000101010101010000000000000101010101011011101101010000010101010101010101011011010100000000000000000101010101010110110101010101020101010101010100000101000000010101010101010101011011010101000000000001010101020101010101010101010101010101
0000000000004050400000000000000000000000000000004043440000002021202170000000000000730000000000002021000000000000000000000000000000000020210000000000020000000000000000000000000000000000000000000000002021000000000000000000000000020074007300720071007000490000
00000000000050005000000000000000000000000000000050535400000030313031000000000000000000000000000030310000000000000000000000000000000000303100000000000200000000ff000000000000000000000000000000000000003031000000000000000000000000020000000000000000000000000000
0101010100000101010100000101101101010100000000000101010101010101010101010000010101010101010101010110110100000000000000000101010101101101010201010101010101010101010100000101000000010101010101010101011011010101000000000001010101010101101101010101010101010201
000000000000000000000000000020210000000000000000000000000000000000000000000000000000004043440000002021000000000000000000000000000020210000020000000000000000000000000000000000000000000000402f000000002021000000000000000000000000000000202100000000000000000200
0000000000000000000000000000303100000000000000000000000000000000000000000000000000000050535400000030310000000000000000000000000000303100000200000000000000000000000000000000000000000000005050000000003031000000000000000000000000000000303100000000000000000200
0101101100000101014100000101010101010100000000001011010101010101101101010000010101010101010101010101010100000000000000000101101102010101010101010101010101010101010100000100002f00010101101101010101010101010101010201003d11010101020101010101010101010101011011
0000202100000000405040000000000000000000000000002021000000000000202100000000000000000000000000000000000000000000000000000000202102006c7c4043440000000000000000000000000000002f502f000000202100000000000000000000000200002021000000020000000000000000000000002021
0000303100000000500050000000000000000000000000003031000000000000303100000000000000000000000000000000000000000000000000000000303102525552505354000000000000000000000000000000500050000000303100000000000000000000000200003031000000020000000000000000000000003031
0101010101010101010101010101010101010100000000000101010101010101010101010000010101010101010101010101010100000101010100000101010101010101010101010101010101010101010100000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0000000000000000000000000000001d0000000000000000000000000000153f00000000000000000000000000001515000000000000000000000000000015160000000000000000000000000000151700000000000000000000000000001518000000000000000000000000000015190000000000000000000000000000151a
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
001200000000000000000000000000000000000000000000000002e00000000000000000000000290402804029040290401d0401d0451d0401d040240402204021040240402904029045290402d0402b04029040
0012000000000000000000000000000000000000000000000000000000000000000000000000001d1401d14021140211402114021140211402114021140211402414024140241402414024140241402414024145
001200002b0402b0401f0401f0451f0401f040210401d0401c0401f040240402404524040240402604028040290402804026040240402604024040220402104022040210401f0401d0401f0401d0401c0401a040
001200002414024140241402414024140241402414024145241402414024140241402114021140211402114521140211402114021140211402114021140211402214022140221402214022140221402214022140
00120000180401d0401c0401f0401d040210401f0402204021040210401d0401d0451d0401d040290402804029040290401d0401d0451d0401d040240402204021040240402904029045290402d0402b04029040
0012000021140211401f1401f1401f1401f1401f1401f1401f1401f1401d1401d1401d1401d1451d1401d14021140211402114021140211402114021140211402414024140241402414024140241402414024145
00120000180401d0401c0401f0401d040210401f0402204021040210401d0401d0451d0401d040240402204021040240402904024040210402404029040240402604026040220402204522040220402604024040
0012000021140211401f1401f1401f1401f1401f1401f1401f1401f1401d1401d1401d1401d1451d1401d1451d1401d1402114021140211402114021140211452114021140211402114021140211402114021145
0012000023040260402b0402604023040260402b040260402804028040240402404524040240402604028040290402804026040240402604024040220402104022040210401f0401d0401f0401d0401c0401a040
001200002114021140211402114021140211402114021140241402414024140241452414024140241402414021140211402114021140211402114021140211402214022140221402214022140221402214022140
00100000191500000013150000000e150022000a15000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001e7502d750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001f7002170024700257002770027700277502575023750217501e7501c750197501775013750107500b700067000670000000000000000000000000000000000000000000000000000000000000000000
001000003b70039750347502e75000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900003e6503b6503865038650386502d6503365000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002c450294502645023450204501c4501945000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003465033650316502f6502c650296502665023650216501f6501d6501c65018650176501565013650106500f6500d6500c6500a6500965007650066500565005650046500365003650026500000000000
002000000000001650000000465017000076500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000039650016003b650017003c650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 00014344
00 02034344
00 04054344
00 02034344
00 06074344
00 08094344
00 06074344
00 08094344
00 04054344
00 02034344
00 04054344
00 02034344
00 06074344
00 08094344
00 06074344
00 08094344
00 04054344
00 02034344
00 04054344
00 02034344
00 06074344
00 08094344
00 06074344
00 08094344
00 04054344
00 02034344
00 04054344
00 02034344
00 06074344
00 08094344
00 06074344
00 08094344
00 04054344
00 02034344
00 04054344
00 02034344
00 06074344
00 08094344
00 06074344
00 08094344
00 04054344
00 02034344
00 04054344
00 02034344
00 06074344
00 08094344
00 06074344
00 08094344
00 04054344
00 02034344
00 04054344
00 02034344
00 06074344
00 08094344
00 06074344
00 08094344
00 04054344
00 02034344
00 04054344
00 02034344
00 06074344
00 08094344
00 06074344
00 08094344
