--Energea - Formed Nomencreation
function c26052009.initial_effect(c)
	Fusion.AddProcMixRep(c,true,true,c26052009.ffilter,2,4)
	Fusion.AddContactProc(c,c26052009.contactfil,c26052009.contactop,c26052009.splimit,nil,nil,aux.Stringid(26052009,0),false)
	c:SetSPSummonOnce(26052009)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052009,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(c26052009.cost)
	e2:SetTarget(c26052009.sptg)
	e2:SetOperation(c26052009.spop)
	c:RegisterEffect(e2)
end
c26052009.RACES=(RACE_ROCK|RACE_PYRO|RACE_AQUA|RACE_THUNDER)
function c26052009.ffilter(c,fc,sumtype,sp,sub,mg,sg)
	local RC=c26052009.RACES
	return c:IsRace(RC,fc,sumtype,sp) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace(),fc,sumtype,sp))
end
function c26052009.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetLocation()~=LOCATION_EXTRA 
end
function c26052009.contactfil(tp)
	return Duel.GetMatchingGroup(c26052009.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
end
function c26052009.mtfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_NORMAL)
end
function c26052009.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c26052009.costfilter(c)
	return c:IsMonster() and c:IsReleasable()
end
function c26052009.rescon1(sg,e,tp,mg)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26052012)}) do
		fg:AddCard(pe:GetHandler())
	end
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=#fg
end
function c26052009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26052012)}) do
		fg:AddCard(pe:GetHandler())
	end
	local g1=Duel.GetMatchingGroup(c26052009.costfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,e:GetHandler())
	if #fg>0 then
		local g2=Duel.GetMatchingGroup(c26052012.costfilter,tp,LOCATION_DECK,0,nil,e,tp)
		g1:Merge(g2)
	end
	if chk==0 then return aux.SelectUnselectGroup(g1,e,tp,2,2,c26052009.rescon1,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=aux.SelectUnselectGroup(g1,e,tp,2,2,c26052009.rescon1,1,tp,HINTMSG_RELEASE,c26052009.rescon1)
	local dc=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if dc>0 then
		if dc>1 then
			fg=fg:Select(tp,2,2,nil)
		end
		for fc in aux.Next(fg) do
			Duel.HintSelection(fc)
			fc:RegisterFlagEffect(26052012,RESETS_STANDARD_PHASE_END,0,0)
		end
		Duel.Hint(HINT_CARD,0,26052012)
	end
	Duel.SendtoGrave(tg,REASON_COST+REASON_RELEASE)
end
function c26052009.spfilter(c,e,tp,rc,opp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsRace(rc) and
	(c:IsType(TYPE_NORMAL) or opp)
end
function c26052009.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetRace)==#sg
end
function c26052009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c26052009.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp,RACE_ALL,false)
	if chk==0 then return ft>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c26052009.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local races=e:GetLabel()
	if ft==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local rc1,rc2,rc=0,0,0
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RACE)
	rc1=Duel.AnnounceRace(1-tp,3,RACE_ALL)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	rc2=Duel.AnnounceRace(tp,3,RACE_ALL-rc1)
	rc=rc1|rc2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26052009.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp,rc,false)
	local rsg=aux.SelectUnselectGroup(g,e,tp,1,ft,c26052009.rescon,1,tp,aux.Stringid(26052009,3),c26052009.rescon)
	if #rsg>0 and Duel.SpecialSummon(rsg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,rsg)
		Duel.ShuffleSetCard(rsg)
		local p,rc2=1-tp,rc-rsg:GetSum(Card.GetRace)
		local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26052009.spfilter),tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,nil,e,tp,rc2,true)
		if #g2>0 and Duel.SelectYesNo(p,aux.Stringid(26052009,4)) then
			g2=g2:Select(p,1,1,nil)
			Duel.SpecialSummon(g2,0,p,p,false,false,POS_FACEUP)
		end
	end
end