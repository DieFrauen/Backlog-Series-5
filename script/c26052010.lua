--Artefix the Synthetic Nomencreation
function c26052010.initial_effect(c)
	Fusion.AddProcMixRep(c,true,true,c26052010.ffilter,2,4)
	Fusion.AddContactProc(c,c26052010.contactfil,c26052010.contactop,c26052010.splimit,nil,nil,aux.Stringid(26052010,0),false)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c26052010.sumlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26052010,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE|EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetCost(c26052010.cost)
	e3:SetTarget(c26052010.thtg)
	e3:SetOperation(c26052010.thop)
	c:RegisterEffect(e3)
end
c26052010.RACES=(RACE_CYBERSE|RACE_MACHINE|RACE_PSYCHIC|RACE_SPELLCASTER)
function c26052010.ffilter(c,fc,sumtype,sp,sub,mg,sg)
	local RC =c26052010.RACES 
	return c:IsRace(RC,fc,sumtype,sp) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace(),fc,sumtype,sp))
end
function c26052010.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetLocation()~=LOCATION_EXTRA 
end
function c26052010.contactfil(tp)
	return Duel.GetMatchingGroup(c26052010.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
end
function c26052010.mtfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_NORMAL)
end
function c26052010.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c26052010.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c26052010.nmfilter(c,rc)
	return c:IsMonster() and c:IsType(TYPE_NORMAL) and c:IsRace(rc)
end
function c26052010.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return Duel.IsExistingMatchingCard(c26052010.nmfilter,sump,0,LOCATION_GRAVE,1,nil,c:GetRace()) and sump==targetp and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_FUSION)
end
function c26052010.costfilter(c)
	return c:IsMonster() and c:IsReleasable()
end
function c26052010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26052012)}) do
		fg:AddCard(pe:GetHandler())
	end
	local g1=Duel.GetMatchingGroup(c26052010.costfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,nil)
	if #fg>0 then
		local g2=Duel.GetMatchingGroup(c26052012.costfilter,tp,LOCATION_DECK,0,nil,e,tp)
		g1:Merge(g2)
	end
	if chk==0 then return #g1>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		local fc=nil
		if #fg==1 then
			fc=fg:GetFirst()
		else
			fc=fg:Select(tp,1,1,nil):GetFirst()
		end
		Duel.HintSelection(fc)
		Duel.Hint(HINT_CARD,0,fc:GetCode())
		fc:RegisterFlagEffect(26052012,RESETS_STANDARD_PHASE_END,0,0)
	end
	Duel.SendtoGrave(tc,REASON_COST+REASON_RELEASE)
end
function c26052010.thfilter(c,tp)
	return c:IsAbleToHand() and c:IsMonster()
	and (c:GetOwner()~=tp or not c:IsType(TYPE_EFFECT))
end
function c26052010.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local op=e:GetHandler():GetOwner()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(op) and c26052010.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c26052010.thfilter,op,LOCATION_GRAVE,0,1,nil,ep) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26052010.thfilter,op,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26052010.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end