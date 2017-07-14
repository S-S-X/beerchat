## [Mod] Beerchat [beerchat]
[Mod] Beerchat [beerchat] is a standalone completely dependency free Minetest mod that supports chat channels/ chat rooms, colored messages, muting players, message sounds and chat shortcuts. Full list of features:

* Support for chat rooms, called channels, in which members can privately chat without flooding the main channel
* The default chat has been turned into a channel as well, called main. You can leave (and rejoin) the main channel, e.g. when you are not interested or it is too spammy
* Extremely easy to chat in a channel, just start your message with #your channel name: (in case of spaces in the channel name) or #my_channel (no colon needed if there are no spaces in the name)
* You can still chat the old way. Just enter your message like you used to do and it will appear in the main chat automatically (no need to prepend with #main or do other difficult things to chat like you used to)
* Channels can be assigned a color so messages in that channel appear in that color. This way you can easily differentiate between main channel chats and private channel chats
* Distance based chatting, called whispering. Players out of range will not see your message, players in range will see the message in a different color. Ideal to talk to nearby people and to differentiate messages
* Provides shortcuts: @ for PMs, # for chat room messages and $ to whisper
* Remebers the last player or last channel a message was sent to. So at first you can @player or #my_channel and after that just use @ or # only to send to that player/ channel again
* Uses the console/ standard chat "window" for chat messages
* Message formats fully configurable (currently in the init.lua but really easy to do, all settings are in the top of the file and documented). You can pass parameters to the message strings as well. So if you want to strip the channel name from the main channel you can do so. You can shuffle elements around e.g. placing the channel name at the end of a message. You can add a time. You can put from_player and to_player in all messages or just a few
* State is stored in mod storage and player attributes so they survive a server restart. E.g. channels you have created and joined will still be there after server restart. Players you have muted will also survive a server restart.

Depends: none
Requires Minetest 0.4.16 because of mod storage and player attributes support in the mod
Attribution: Some code used from orwell's atchat: https://forum.minetest.net/viewtopic.php?f=11&t=13593

Future plans:

* Setting a default channel, e.g. messages typed normally will appear in the channel of your choice
* Beerchat formspec to tweak per player settings such as enabling/ disabling sounds, managing channels, overriding colors, etc.
* Configurable color for private messages
* A "talk to" feature where you can send a public message but it will appear as <from_player> to <to_player>, possibly highlighting the message for that player only using a selected color. This to avoid confusion as to who the message was meant for e.g. in the case of <player01> can i use mese ; <player02> can you give me some diamonds ; <player03> yes
* Shout with ! support
* Externalizing the settings from the init.lua and support using configuration file and the main minetest.conf
* Improved channel management by server administrator, e.g. to avoid wild growth of channels. Adding a last used timestamp to identify channel that have not been used in a long time. Automatic cleanup of old unused channels
* Message highlighting when your name is mentioned in a chat message or when a message contains a certain string a la chat2
* Option to place certain messages in the HUD a la chat2 and allow users to enable/ disable this feature via preferences formspec on a per message type (PM, channel, name mentions, etc.) basis. Even easier to identify messages of interest

## Using the Mod In-Game
### Channel Management
Channels are like chat rooms. Messages in channels are only sent to the members of that channel. They can be made private by password protecting it and a color to differentiate from the main chat. Channel management is done via chat commands. Parameters to these commands are comma separated. To create a channel, use the /create_channel or /cc command and supply channel name, optional password and optional color (defaults to white). Channels can be deleted via /delete_channel or /dc and this can only be done by the channel owner. The owner does not need to supply the channel's password to delete the channel. The /my_channels or /mc command shows the channels you are owner/ member of in json format. Some channel management examples below:

    /create_channel my super secret room,mysecretpass01,#00ffff
    /create_channel my public room
    /create_channel my red colored room without password,,#ff0000
    /delete_channel my super secret room

To join a channel use the /join_channel or /jc command which takes the channel name and optionally a password. To leave a channel do /leave_channel or /lc and supply the channel name. If you are the owner of a channel, you can send an invite to a player using the /invite_channel or /ic command which will then send the channel name and password to the invited player.

    /jc someone else's channel,pass01
    /lc channel i got bored with
    /ic my private room,NicePlayer01

### Channel Chats
When you chat normally, everything is written to the channel called main. Chats to main are prefixed with |#main| and given the default main channel color white. In order to write to a specific channel you have joined, start your chat with a #, then the channel name and then a colon. Messages sent this way will only be seen by the other members of the channel (unless someone has muted the sender, see also muting below). If you want to send another message to the same channel you can start it with just the # (without channel name):

    #my channel: This will be sent to my channel
    # This will also be sent to my channel as that was the last one used
    #jokes In this case a colon is not needed as there is no space in the channel name
    # We have now switched to the jokes channel so this will be sent there

These "hash chats" are prefixed with |#channel name| and appear in the color of that particular channel as specified during channel creation (or default white if no color was supplied at that time).

NOTE: You can leave the main channel! So if things are getting spammy, besides muting people (see below) you can leave the main channel and just chat in the other channels you are a member of.

Muting Players
To mute a player, just do /mute or /ignore player name. Unmuting is done via /unmute or /unignore player name. E.g.:

    /mute Griefer666
    /unmute NicePlayerAfterAll

### Private Messages
You can send private messages the old way using /msg but there is now a shorthand as well using the @ sign (like the at chat mod, code was inspired by this mod). To at chat a PM, just supply the user name or comma separated names you want to send the PM to. If you start the message with just @ without supplying player names, it will send the message to the last user(s) you sent a PM to, e.g.:

    @JohnDoe How's life?
    @JohnDoe,MaryJane Shall we have a party at spawn >8-)))
    @ Hey John, Mary, I will be at spawn in 5 minutes ok?

### Whispering
You can whisper by starting your message with the $ sign. Only players within a range of 32 blocks will then be able to see your chat (which happens to be the same maximum range of seeing other players). The dollar chat will be sent to the main channel in a grey color. If you want to dollar chat with a larger or shorter range, you can supply the radius straight after the dollar. The maximum radius is (for now) 200 blocks (or you might just start using normal chat or use channels if you don't want others to hear you). Whispering is just there so that when used, chats from nearby players are colored differently (light grey) and can be more easily distinguished from the chat of players further away. The below dollar chats whisper the message to 16, 32 and 64 nodes respectively.

    $16 Can you hear me major Tom
    $ Can you hear me now, major Tom?
    $64 Can you heeeeeeeeeere I am floating round my tin can

## Mod Settings, Configuration and Customization
### Configuration
Configuration is currently done in the init.lua so make the changes in there. For the main channel (channel where messages are sent by default if no channel was specified), you can change the name, the owner and the color. Colors are defined in hexadecimal and start with a #.

    local main_channel_name = "main"     -- The main channel is the one you send messages to when no channel is specified
    local main_channel_owner = "ADMIN"   -- The owner of the main channel, usually ADMIN
    local main_channel_color = "#ffffff" -- The color in hex of the main channel

The default channel color specifies the color of channels for which no color was passed as argument when the channel was created.

    local default_channel_color = "#ffffff" -- The default color of channels when no color is specified

You can enable or disable sounds and when sounds are enabled you can specify what sounds to play by changing the sound file strings:

    local enable_sounds = true -- Global flag to enable/ disable sounds

Example of a sound string below, make sure that you specify the sound file here without the .ogg extension and that you have the sound file stored in the sounds directory and with the .ogg extension

    local private_message_sound = "beerchat_chime" -- Sound when you receive a private message

Whisper settings control the range controlled dollar chats. The default range is the range used when you do not pass a radius when whispering. You cannot specify a radius larger than the max range. If you would like to be able to whisper over larger distances, you can increase the value of 200 to something higher. The whisper color can be used to visually differentiate whispers from the normal chats. Please note that whispering is done in the main channel.

    local whisper_default_range = 32
    local whisper_max_range = 200
    local whisper_color = "#aaaaaa"

### Customizing the Message Formats
In the settings section in the init.lua you can customize formatting of the messages. As you can see, parameters can be specified using ${parameter}:

    local main_channel_message_string = "|#${channel_name}| <${from_player}> ${message}"

You can remove the |#main| from main channel chats by removing the ${channel_name} parameter from the above string. This would format main channel messages using the default chat format from Minetest:

    local main_channel_message_string = "<${from_player}> ${message}"

The use of parameters not only allows you to add or remove elements, it also allows you to move elements around in the message string. E.g. to move the channel name to the end of the message:

    local main_channel_message_string = "<${from_player}> ${message} |#${channel_name}|"

The following parameters can be used in the message strings:
* ${channel_name} name of the channel
* ${channel_owner} owner of the channel
* ${channel_password} password to use when joining the channel, used e.g. for invites
* ${from_player} the player that is sending the message
* ${to_player} player to which the message is sent, will contain multiple player names e.g. when sending a PM to multiple players
* ${message} the actual message that is to be sent
* ${time} the current time in 24 hour format, as returned from os.date("%X")

You can completely customize the formatting of the chat system to your liking, e.g. if you do not like the default use of the | character around channel names, you can change this into whatever you like. The below example uses [ and ] around the channel name in the channel message strings:

    local channel_message_string = "[#${channel_name}] <${from_player}> ${message}"
    local main_channel_message_string = "[#${channel_name}] <${from_player}> ${message}"

### About the Code
Be warned, the code is not pretty and even though it was refactored after spinning it off from the beerarchy subgame, it may need quite some more refactoring. And it would be nicer if it actually supplied an API, but oh well it was hacked together in 2-3 days. Also, it requires Minetest 0.4.16 as it uses both mod storage and player attributes to keep track of the channels and muted players. Otherwise, the code *should* work pretty much out of the box. However be careful when running this mod together with other chat mods, as they could very likely interfere with each other. Have fun and let me know in case of issues!
