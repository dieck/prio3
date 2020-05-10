# prio3
Prio3 - World of Warcraft Classic addon

## tl;dr

Generate loot lists in format `Username;Prio1;Prio2;Prio3` per line. (e.g. CSV SHORT export from sahne-team.de)
Go to Menu Interfaces, Tab Addon, Prio3 and import.
Loot corpses and have chosen loot announced in raid chat.


## What is Priority 3 Looting?

This loot distribution scheme is based on participants choosing up to three items they want to gain priority on when they actually drop.

It is especially nice for pug raids or raids with a high amount of random fillers, as there is no history, no earning of points, everyone starts the same with every raid.
But of course it can also be of value on regular raid groups that do not want the hassle of full DKP tracking or avoid long loot council discussions.

Side note: Prio 3 does not distinguish between main/need and offspec/greed priorities. It can thus be a good choice if you want to collect offspec gear for your char.
(*Hint*: In order to avoid grief on main spec characters who are interested in the same items, it could be better to announce this intention beforehand.)

## So, how does this work now?

Before the raid, you will choose 3 items you want to have priority on.

Mostly, the raid lead or designated PM is collecting these requests, noting them down. Sometimes a Google Doc is used to post as read only link to users later on.

> **_sahne-team.de usage:_** 
> If you are a German user, please try this website! It eases up coordinating Prio loot a lot. You setup a run on the `Priorun` function to the upper left, and give the Run PIN to your participants. Please remember to note down your admin pin from the upper right corner! 
> Every user can choose their items, in secret. Even the admin cannot see those. Afterwards the admin can set the run to be visible for all.
> For use with the Prio3 addon, you can then use the Exports. Prio3 native would be `CSV Short`, but the addon can actually read sahne-team.de full CSV and TXT export as well. (see below)

If the loot drops, it will be handled along the priority table, starting with all users that have this on Priority 1.
If there is only one user: Congrats, you have a new item.
If there are more users with the same priority, those are asked to roll for the item, highest roll wins. Every user will get only one item per priority. If an items drops a second time, it is handled among the others with the highest remaining priority.

If no one selected that particular item for Prio 1, then Prio 2 will be handled, and afterwards Prio 3.
For all items where no one set a Priority, those are usually handled by FFA.  Some raids tend to apply main>offspec here.

Of course choosing which items to put where, that is part of the fun, and risk.
Do I put this item on Prio 1, because others may want it too? Or it is unlikely, and I can savely bet it on Prio 3?

# Where does the Prio3 addon comes into play?

Looking up if someone actually has marked down a priority can be a tedious task, and it's easy to miss someone.

The Prio3 addon will notify you on looting if there are any Priorities set up.

This way you don't have to switch to your lookup table, e.g. on a website like sahne-team.de or a google doc, or even a handwritten note.
It will announce this to the raid (by default), or only to the char using the addon and looting (should normally be the PM).

## How does the addon know about the priorities?

You can import simple CSV strings on the Addon config page (Menu Interfaces, Tab Addon, Prio3)

    Username;Prio1;Prio2;Prio3
    ...

where Prio1, 2, 3 can be numeric item Ids, or even strings with the IDs somewhere in (will take first number found), e.g. wowhead links.

This is the CSV-SHORT export format of sahne-team.de.

Also accepted format: sahne-team.de CSV export (with german header line)

    Name;Klasse;prio1itemid;prio2itemid;prio3itemid;prio1itemname;prio2itemname;prio3itemname;
    Username;Class;ID1;ID2;ID3;Name1;Name2;Name3;
    ...

Also accepted format: sahne-team.de TXT export (tab (\t) separated)

    Username↹↹Class↹↹Name1-ID1↹Name2-ID2↹Name3-ID3
    ...

If you need further formats, please let me know.

Players can be informed by whispers about imported priorities (configurable in options).

> **Plans (short-term)**:
> Create easier access to import function :)

> **Plans (mid-term)**:
> React on loot events as well, e.g. if you forgot master looter and someone else loots.

> **Plans (long-term)**:
> Allow player to whisper in priorities, also for late joiners / replacements.

> **Plans ((very-)long-term)**:
> Simplified loot distribution (maybe even automated, with roll evaluation)

## Looking up and validating priorities

/prio3 will open an overview on loot

(Known issue: tooltip does not display properly, working on it.)

### Querying

There are three options for your raid participants to query for Prio3 entries (can be turned on and off in options)

Whisper `prio` to get your own priorities.

Whisper `prio USERNAME` to look up another raid member.

Whisper `prio ITEMLINK` to look up priorities on an item.

(If you don't get an answer at all, ask your Prio3 master if they turned on the options)


> **Plans (short-term)**:
> - Sync between multiple raid users having the addon installed

> **Plans (mid-term)**:
> - Note if someone got an item and remove user from list


