pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- thursday game!
-- by trolzie

local score
local game_objects

function _init()
    make_controls()
    -- start game with counter at zero
    score=0
    -- create game objects
    game_objects={}
    local i
    -- create some objects
    -- bottom border
    for i=0,15 do
        make_block(8*i,120)
    end
    for i=0,15 do
        make_block(0,8*i)
    end
    for i=0,15 do
        make_block(120,8*i)
    end
    make_pin_row(40,96,4)

    for_each_game_object("pin",function(pin)
        if pin.pos==1 then
            pin.selected=true
        end
    end)
end

function _update()
    controls:update()
    local obj
    -- update all the game objects
    for obj in all(game_objects) do
        obj:update()
    end
end

function _draw()
    -- clear the screen
    cls()
    -- draw the score
    print(score,5,5,7)
    -- draw all the game objects
    local obj
    for obj in all(game_objects) do
        obj:draw()
    end    
end

function make_controls()
    controls={
        current_pin=1,
        update=function(self)
            if btnp(0) then
                if self.current_pin>1 then
                    self.current_pin-=1
                end
            end
            if btnp(1) then
                if self.current_pin<4 then
                    self.current_pin+=1
                end
            end
            if btnp(2) then
                for_each_game_object("pin",function(pin)
                    if pin.pos==self.current_pin then
                        pin:change("up")
                    end
                end)
            end
            if btnp(3) then
                for_each_game_object("pin",function(pin)
                    if pin.pos==self.current_pin then
                        pin:change("down")
                    end
                end)
            end
            for_each_game_object("pin",function(pin)
                if pin.pos==self.current_pin then
                    pin.selected=true
                else
                    pin.selected=false
                end
            end)
        end
    }
    return controls
end

function make_block(x,y)
    return make_game_object("block",x,y,{
        width=8,
        height=8,
        draw=function(self)
            spr(3,self.x,self.y)
        end
    })
end

function make_pin(x,y,pos)
    return make_game_object("pin",x,y,{
        width=8,
        height=8,
        pos=pos,
        selected=false,
        color=4,
        draw=function(self)
            spr(self.color,self.x,self.y)
            if self.selected then
                rect(self.x,self.y,self.x+self.width-1,self.y+self.height-1,11)
            end
        end,
        change=function(self,direction)
            if direction=="up" then
                self.color=get_previous_color(self.color)
            elseif direction=="down" then
                self.color=get_next_color(self.color)
            end
        end
    })
end

function get_previous_color(color)
    return color+1
end

function get_next_color(color)
    return color-1
end

function make_pin_row(x,y,n)
    local i
    for i=1,n do
        make_pin(x+i*8,y,i)
    end
end

function make_game_object(name,x,y,props)
    local obj={
        name=name,
        x=x,
        y=y,
        velocity_x=0,
        velocity_y=0,
        update=function(self)
            -- do nothing
        end,
        draw=function(self)
            -- dont draw anything
        end,
        draw_bounding_box=function(self,color)
            rect(self.x,self.y,self.x+self.width,self.y+self.height,color)
        end,
        center=function(self)
            return self.x+self.width/2,self.y+self.height/2
        end
    }
    -- add additional properties
    local key,value
    for key,value in pairs(props) do
        obj[key]=value
    end
    -- add it to list of game objects
    add(game_objects,obj)
    return obj
end

function for_each_game_object(name,callback)
    local obj
    for obj in all(game_objects) do
        if obj.name==name then
            callback(obj)
        end
    end
end

__gfx__
00000000000000000000000077777777ffffffff7777777777777777777777777777777700000000000000000000000000000000000000000000000000000000
0000000000c00c00000aa90076666666feeeeeee7eeeee467aaaaa367aaaaa467bbbbbd600000000000000000000000000000000000000000000000000000000
0070070001cccc1000a7aa907677777dfefffff27e8888467abbbb367a9999467bccccd600077000000000000000000000000000000000000000000000000000
000770000cccccc000aaaa9076766d6dfefee2e27e8888467abbbb367a9999467bccccd600777700000000000007700000000000000000000000000000000000
000770000777777000aaaa9076766d6dfefee2e27e8888467abbbb367a9999467bccccd607777770077777700077770000777700000000000000000000000000
007007000c8cc8c000aaaa90767ddd6dfef222e27e8888467abbbb367a9999467bccccd600000000007777000000000000077000000000000000000000000000
0000000000cccc00000aa9007666666dfeeeeee27444444673333336744444467dddddd600000000000770000000000000000000000000000000000000000000
0000000000000000000000007dddddddf22222227666666676666666766666667666666600000000000000000000000000000000000000000000000000000000
__sfx__
000200000f3500f35010350113501335015350193501c350225502a7502b7502c7502d7502e7502f7502f7502f7502f75029550225501c5501355010050100500f0500f0500f0500f05010050100500f0500c050
010400000d3620e3620e3620e3620c3620b3620f36200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000180551a0551c0552405024040240302402024010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0108000011440114411344114431104311b4211f42125411000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01070000180551c0551f0552405024031240110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001141000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
