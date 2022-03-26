config = {}

config.key = 47 -- G

config.locations = {
    ['1'] = {  -- Just and example, change to whatever you like
        coords = {
            ['1'] = vector3(-615.61, 20.3, 41.7),
            ['2'] = vector3(-603.97, 21.39, 42.76)
        },
        text = "[G] Start picking", -- What 3dtext to display
        skillBar = "easy", -- How hard the skillchecks should be. "hard", "medium" or "easy"
        progressbar = math.random(10000, 15000), -- How long the progressbar should be
        notifyMinigameSuccess = "You are now starting to pick", -- What to notify when you successfullly made all the skillchecks
        notifyMinigameFail = "You failed the skillchecks, Please try again", -- What to notify when you fail the skillchecks
        notifyProgressbar = "You picked up a phone", -- what to notify when the progressbar is done
        animDict = "anim@amb@clubhouse@mini@darts@", -- The animation dictionary
        anim = "enter_throw_a", -- The animation in the animation dictionary
        item = "phone", -- What item to give the player
        amount = 1 -- how many of the item to give the player
    },
    ['2'] = {  -- Just and example, change to whatever you like
        coords = {
            ['1'] = vector3(-615.61, 20.3, 41.7),
            ['2'] = vector3(-603.97, 21.39, 42.76)
        },
        text = "[G] Start picking", -- What 3dtext to display
        skillBar = "hard", -- How hard the skillchecks should be. "hard", "medium" or "easy"
        progressbar = math.random(10000, 15000), -- How long the progressbar should be
        notifyMinigameSuccess = "You are now starting to pick", -- What to notify when you successfullly made all the skillchecks
        notifyMinigameFail = "You failed the skillchecks, Please try again", -- What to notify when you fail the skillchecks
        notifyProgressbar = "You picked up a bag of coke", -- what to notify when the progressbar is done
        animDict = "anim@amb@clubhouse@mini@darts@", -- The animation dictionary
        anim = "enter_throw_a", -- The animation in the animation dictionary
        item = "cokebaggy", -- What item to give the player
        amount = 1 -- how many of the item to give the player
    },
}
