--Energea - Formed Nomencreation
function c26052009.initial_effect(c)
	Fusion.AddProcMixRep(c,true,true,c26052009.ffilter,2,4)
	Fusion.AddContactProc(c,c26052009.contactfil,c26052009.contactop,c26052009.splimit,nil,nil,aux.Stringid(26052009,0),false)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26052009,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,26052009)
	e1:SetCost(c26052009.cost)
	e1:SetTarget(c26052009.sptg)
	e1:SetOperation(c26052009.spop)
	c:RegisterEffect(e1)
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
function c26052009.spfilter(c,e,tp,op)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and
	(c:IsType(TYPE_NORMAL) or op)
end
function c26052009.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetRace)==#sg
end
function c26052009.rescon2(sg,e,tp,mg)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local mc=math.min(ft1+ft2,mg:GetClassCount(Card.GetRace))
	return sg:GetClassCount(Card.GetRace)==#sg
	and #sg==mc
	and sg:FilterCount(Card.IsControler,nil,tp)<=ft1
	and sg:FilterCount(Card.IsControler,nil,1-tp)<=ft2
end
function c26052009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c26052009.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp,RACE_ALL,false)
	if chk==0 then return ft>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26052009.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c26052009.spfilter,tp,LOCATION_DECK,0,nil,e,tp,false)
	local g2=Duel.GetMatchingGroup(c26052009.spfilter,tp,0,LOCATION_DECK,nil,e,tp,true)
	local sg1=aux.SelectUnselectGroup(g1,e,tp,1,5,c26052009.rescon,1,tp,aux.Stringid(26052009,2),c26052009.rescon)
	local sg2=aux.SelectUnselectGroup(g2,e,tp,1,5,c26052009.rescon,1,1-tp,aux.Stringid(26052009,2),c26052009.rescon)
	Duel.ConfirmCards(tp,sg2); Duel.ConfirmCards(1-tp,sg1)
	sg1:Merge(sg2)
	local tg=Group.CreateGroup()
	while #sg1>0 do
		local tc=sg1:Select(tp,1,1,nil):GetFirst()
		if tc then
			local p=tc:GetOwner()
			tg:AddCard(tc)
			sg1:Sub(sg1:Filter(Card.IsRace,nil,tc:GetRace()))
			if tg:FilterCount(Card.IsControler,nil,p)==Duel.GetLocationCount(p,LOCATION_MZONE) then
				sg1:Sub(sg1:Filter(Card.IsControler,nil,p))
			end
			if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
				sg1:Clear()
			end
		end
	end
	g1:Clear();g2:Clear();
	local op=tp
	for tc in tg:Iter() do
		op=tc:GetOwner()
		if Duel.SpecialSummonStep(tc,0,tp,op,false,false,POS_FACEDOWN_DEFENSE)~=0 then
			if op==tp then g1:AddCard(tc) else g2:AddCard(tc) end
		end
	end
	Duel.SpecialSummonComplete()
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleSetCard(g1)
	Duel.ConfirmCards(tp,g2)
	Duel.ShuffleSetCard(g2)
end