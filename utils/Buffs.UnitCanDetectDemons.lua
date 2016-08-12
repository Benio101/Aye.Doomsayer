local Aye = Aye;
Aye.utils.Buffs = Aye.utils.Buffs or {};

-- Check if @unitID can detect demons
--
-- @param	{uint}		unitID	@unitID should be visible (UnitIsVisible)
-- @return	{0|1}		buff	if unit can detect demons
Aye.utils.Buffs.UnitCanDetectDemons = Aye.utils.Buffs.UnitCanDetectDemons or function(unitID)
	-- Rune
	for _, buffID in pairs({
		47524, -- Sense Demons
		11407, -- Detect Demon
	}) do
		local _, _, _, _, _, _, expires = UnitBuff(unitID, GetSpellInfo(buffID));
		
		if type(expires) =="number" and expires >0 then
			return 1;
		end;
	end;
	
	local _, _, classID = UnitClass(unitID);
	if
			classID == 3	-- Hunter
		or	classID == 12	-- Demon Hunter
	then
		return 1;
	end;
	
	-- No Rune
	return 0;
end;