local hamster=display.newImage("superhamster.png")
hamster:translate(hamster.width/2, display.contentCenterY)
hamster:scale(-1,1)

Runtime:addEventListener("touch", function(event)
  if not hamster then
    return
  end
  hamster.y=event.y
end)

local scoreText=display.newText({
  text="Cats dodged: "..0,
  fontSize=80,
  align="right"
})
scoreText.anchorX=1
scoreText.anchorY=0
scoreText:translate(display.contentWidth-10,10)

local catCounter=0
local catGroup=display.newGroup()

function spawnCat()
  if not hamster then 
    return
  end

  local delayTillNextCat=math.random(2000)
  timer.performWithDelay(delayTillNextCat,function()
    local cat=display.newImage("cat.png")
    catGroup:insert(cat)
    local y=math.random(display.contentHeight-cat.height)+cat.height/2
    cat:translate(display.contentWidth+cat.width/2, y)

    transition.to(cat,{x=-cat.width,time=2000,onComplete=function()
      cat:removeSelf()
      catCounter=catCounter+1
      scoreText.text="Cats dodged: "..catCounter
    end})

    spawnCat()
  end)
end
spawnCat()

local testForGameOver
testForGameOver=function()
  for i=1, catGroup.numChildren do
    local cat=catGroup[i]
    if cat.x-cat.width/2>0 and cat.x-cat.width/2 < hamster.x+hamster.width/2 then
      local catBottomEdge=cat.y+cat.height/2
      local catTopEdge=cat.y-cat.height/2

      local hamsterBottomEdge=hamster.y+hamster.height/2
      local hamsterTopEdge=hamster.y-hamster.height/2

      local list={catBottomEdge,catTopEdge,hamsterBottomEdge,hamsterTopEdge}
      table.sort(list)

      -- a quick check to see if the hamster and the cat image overlap
      -- if the top and bottom of the hamster are the two smallest or 
      -- biggest values then there must be a gap between the hamster 
      -- and cat, otherwise they overlap and gameover
      if list[1]==hamsterTopEdge and list[2]==hamsterBottomEdge or list[3]==hamsterTopEdge and list[4]==hamsterBottomEdge then
        -- do a little victory roll
        hamster.rotation=0
        transition.to(hamster,{rotation=360})
      else
        cat:setFillColor(1,0,0)
        hamster:removeSelf()
        hamster=nil
        Runtime:removeEventListener("enterFrame", testForGameOver)
        return
      end
    end
  end
end

Runtime:addEventListener("enterFrame",testForGameOver)