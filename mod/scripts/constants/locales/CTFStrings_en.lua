---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-22 10:20 a.m.
---

local CTF_STRINGS = {
    WELCOME = {
        TITLE = 'Welcome to Capture the Flag!',
        TEXT = 'There are two teams in this game, each team has a different hue.\nThe goal of the game is to bring the opponent\'s piggyback to your base.\nUse gold to craft weapons, armor and food.\nYou can get gold by defeating enemies.\nSome creatures are your friends, some aren\'t, either way, they all drop gold.\n\nGood luck!',

        OK = 'OK',

        DISCORD = 'Discord',
        DISCORD_LINK = 'https://discord.gg/qfNbVrXCkd',

        VIDEO = 'Video Tutorial',
        VIDEO_LINK = 'https://www.youtube.com/embed/_LN5mRUN6cE?autoplay=1',
    },

    CHAT_ALL = '[ALL]',
    CHAT_TEAM = '[TEAM]',

    CHAT_ALL_SHORT = '[A]',
    CHAT_TEAM_SHORT = '[T]',

    CHAT_TEAM_DELIMITER = '\n',

    CHARACTER_DESCRIPTIONS = {
        wilson = '*Uses your life force to grow his stubble\n*Bounty is tied to his stats\n*Resets after death',
        willow = 'NEWEST CHARACTER RELEASE (almost)\n*Uses her lighter as a ranged weapon\n*Create a ring of fire\n*Burn them first for extra dmage',
        wendy = '*Can use Abigail for a quick burst of damage\n*Abigails health becomes her damage\n*Resets after each use',
        wolfgang = '*Absorbs damage when full\n*Gets slower on a full stomach\n*Is a literal tank',
        wx78 = '*Can buy gears to upgrade from the store\n*Can get very tanky',
        wickerbottom = '*Can craft Heart Tart Art\n*Can also craft Humpty Dumpty',
        wes = '*Armor effectiveness reduced\n*Does more damage\n*Can\'t be insta-killed\n*Has less health, hunger and sanity',
        waxwell = '*Can spawn up to 5 shadow duelists',
        woodie = '*Can transform into the weremoose',
        woodie_us = '*Can transform into the weremoose\n*Will beat thisguyizgood at hockey',
        woodie_canada = '*Can transform into the weremoose\n*Comes from the true north\n*Oh Ca.na.daaaa...',
        wathgrithr = '*Same old, same old',
        webber = '*Takes less damage from spiders\n*Can craft a spiderhat',
        winona = '*Can build catapults\n*And generators\n*And craft gems',
        wortox = '*Souls drop by last hitting enemy players\n*Also beehives and pigs\n*Cannot soulhop when wearing the piggyback\n*Gets less hunger and health from food',
        wormwood = '*Can craft bramble items\n*And compost wrap\n*Cannot heal from food\n*With the exception of jellybeans',
        warly = '*Can build a seasoning station\n*Crafts spices\n*Why not add some flavor to food?!\n*Can only eat crockpot meals',
        wurt = 'WORK IN PROGRESS',
        walter = '*Get a slingshot from the shop\n*Ammo can be bought too\n*Has a bee allergy',
        random = 'Who will you be?',
    },
    
    CRAFTING_DESCRIPTIONS = {
        --FOOD
        JELLYBEAN = '+122 health over 120 seconds',
        COOKEDMEAT = 'Health: 3\n Hunger: 25',
        BIRD_EGG_COOKED = 'Health: 0\n Hunger: 12.5',
        DRAGONFRUIT_COOKED = 'Health: 20\n Hunger: 12.5',
        POTATO_COOKED = 'Health: 20\n Hunger: 25',
        GARLIC_COOKED = 'Health: 1\n Hunger: 9.375',
        CARROT_COOKED = 'Health: 3\n Hunger: 12.5',
        BUTTERFLYWINGS = 'Health: 8\n Hunger: 9.375',
        HONEY = 'Health: 3\n Hunger: 9.375',


        --WEAPONS
        SPEAR = 'Damage: 34\n Durability: 150',
        BLOWDART_PIPE = 'Damage: 100\n Durability: 1',
        BOOMERANG = 'Damage: 27.2\n Durability: 10',
        WHIP = 'Damage: 27.2\n Durability: 175',
        TENTACLESPIKE = 'Damage: 51\n Durability: 100',
        BATBAT = 'Damage: 42.5\n Durability: 75',
        SPEAR_WATHGRITHR = 'Damage: 42.5\n Durability: 200',
        HAMBAT = 'Damage: 29.75 - 59.5\n Durability: 10 days',
        GLASSCUTTER = 'Damage: 68\n Durability: 75',
        ICESTAFF = 'Damage: 0\n Durability: 20',
        NIGHTSWORD = 'Damage: 68\n Durability: 100',
        RUINS_BAT = 'Damage: 59.5\n Durability: 200',
        TOWNPORTAL = 'Teleport using a desert stone!',


        --ARMOR
        ARMORWOOD = 'Absorbtion: 80%\n Durability: 315',
        ARMORMARBLE = 'Absorbtion: 95%\n Durability: 735',
        ARMOR_SANITY = 'Absorbtion: 95%\n Durability: 525',
        ARMORSNURTLESHELL = 'Absorbtion: 60-100%\n Durability: 735',
        ARMORRUINS = 'Absorbtion: 90%\n Durability: 1260',
        ARMORSKELETON = 'Blocks all damage every 5 seconds',


        --HATS
        COOKIECUTTERHAT = 'Absorbtion: 70%\n Durability: 525',
        WATHGRITHRHAT = 'Absorbtion: 80%\n Durability: 525',
        SLURTLEHAT = 'Absorbtion: 90%\n Durability: 525',
        RUINSHAT = 'Absorbtion: 90-100%\n Durability: 840',


        --WALTER
        SLINGSHOT = 'Shoot pebbles at your enemies!',
        SLINGSHOTAMMO_ROCK = 'Amount: 5\n Damage: 17',
        SLINGSHOTAMMO_GOLD = 'Amount: 5\n Damage: 34',
        SLINGSHOTAMMO_MARBLE = 'Amount: 5\n Damage: 51',
        SLINGSHOTAMMO_FREEZE = 'Amount: 5\n Freeze your enemies!',
        SLINGSHOTAMMO_SLOW = 'Amount: 5\n Slow your enemies!',


        --WORMWOOD
        ARMOR_BRAMBLE = 'Damage nearby enemies when hit!',
        TRAP_BRAMBLE = 'Damage: 40\n Durability: 10',
        COMPOSTWRAP = '+40 health, speeds up blooming',


        --WOODIE
        WEREITEM_MOOSE = 'Destroy anything as the weremoose!',


        --WINONA
        WINONA_CATAPULT = 'Damage: 35\n Health: 250',
        WINONA_BATTERY_HIGH = 'Power your catapult!',
        BLUEGEM = 'Power your G.E.M.erator!',


        --WARLY
        PORTABLECOOKPOT_ITEM = 'Cook on the go!',
        PORTABLESPICER_ITEM = 'Gain unique abilities!',
        SPICE_GARLIC = '33% absorbtion\n Duration: 4 minutes',
        SPICE_CHILI = '20% more damage\n Duration: 4 minutes',
        SPICE_SALT = '25% more healing to any food',

        --WICKERBOTTOM
        BOOK_SILVICULTURE = 'Heal the heart, tart, art.',
        BOOK_BRIMSTONE = 'Humpty Dumpty had a great killing spree.',


        --MAXWELL
        SHADOWDUELIST_BUILDER = 'Build up to 5 minions!',


        --WX-78
        GEARS = 'Eat up to 15 and gain up to 400 health!',

        --WEBBER
        SPIDERHAT = 'Have up to 10 spider followers!',

        --WILLOW
        LIGHTER = 'Burn your enemies alive!',
    }
}

return CTF_STRINGS;