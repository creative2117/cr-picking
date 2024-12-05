config = {}

config.debug = false
config.key = 47 -- G
config.useTarget = GetConvar('UseTarget', 'false') == 'true'

config.locations = {
    ['1'] = {  -- Just and example, change to whatever you like
        coords = {
            ['1'] = vector3(-601.38, 21.43, 42.95),
            ['2'] = vector3(-603.97, 21.39, 42.76)
        },
        text = "[G] Start picking", -- What 3dtext or target option text to display
        skillBar = "easy", -- How hard the skillchecks should be. "hard", "medium" or "easy"
        progressbar = 1000, -- How long the progressbar should be
        notifyMinigameSuccess = "You are now starting to pick", -- What to notify when you successfullly made all the skillchecks
        notifyMinigameFail = "You failed the skillchecks, Please try again", -- What to notify when you fail the skillchecks
        notifyProgressbar = "You picked up a phone", -- what to notify when the progressbar is done
        animDict = "anim@amb@clubhouse@mini@darts@", -- The animation dictionary
        anim = "enter_throw_a", -- The animation in the animation dictionary
        item = "phone", -- What item to give the player
        amount = 1,                                                          -- how many of the item to give the player
        cooldown = {
            enabled = true, -- if you want it do have a cooldown or not
            time = 30, -- how long the cooldown should be in seconds
            notify = "You are on cooldown",
        }
    },
    ['2'] = {  -- Just and example, change to whatever you like
        coords = {
            ['1'] = vector3(-615.61, 20.3, 41.7),
            ['2'] = vector3(-603.97, 21.39, 42.76)
        },
        text = "[G] Start picking", -- What 3dtext or target option text to display
        skillBar = "hard", -- How hard the skillchecks should be. "hard", "medium" or "easy"
        progressbar = math.random(10000, 15000), -- How long the progressbar should be
        notifyMinigameSuccess = "You are now starting to pick", -- What to notify when you successfullly made all the skillchecks
        notifyMinigameFail = "You failed the skillchecks, Please try again", -- What to notify when you fail the skillchecks
        notifyProgressbar = "You picked up a bag of coke", -- what to notify when the progressbar is done
        animDict = "anim@amb@clubhouse@mini@darts@", -- The animation dictionary
        anim = "enter_throw_a", -- The animation in the animation dictionary
        item = "cokebaggy", -- What item to give the player
        amount = 1, -- how many of the item to give the player
        cooldown = {
            enabled = true, -- if you want it do have a cooldown or not
            time = 100, -- how long the cooldown should be in seconds
            notify = "You are on cooldown", -- what to notify if on cooldown
        }
    },
}
