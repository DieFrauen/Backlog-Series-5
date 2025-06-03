--Therius - Proud Nomencreation
function c26052005.initial_effect(c)
	Fusion.AddProcMixRep(c,true,true,c26052005.ffilter,2,4)
	Fusion.AddContactProc(c,c26052005.contactfil,c26052005.contactop,c26052005.splimit,nil,nil,aux.Stringid(26052005,0),false)
	--Increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c26052005.atkfilter)
	e1:SetValue(c26052005.atkval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052005,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c26052005.atcon)
	e2:SetCost(c26052005.cost)
	e2:SetOperation(c26052005.atop)
	c:RegisterEffect(e2)
end
c26052005.RACES=(RACE_BEASTWARRIOR|RACE_WARRIOR|RACE_BEAST|RACE_ZOMBIE)
function c26052005.ffilter(c,fc,sumtype,sp,sub,mg,sg)
	local rc=c26052005.RACES
	return c:IsRace(rc,fc,sumtype,sp) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace(),fc,sumtype,sp))
end
function c26052005.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetLocation()~=LOCATION_EXTRA 
end
function c26052005.contactfil(tp)
	return Duel.GetMatchingGroup(c26052005.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
end
function c26052005.mtfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_NORMAL)
end
function c26052005.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c26052005.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not e:GetHandler():IsHasEffect(EFFECT_ATTACK_ALL)
end
function c26052005.costfilter(c)
	return c:IsMonster() and c:IsReleasable()
end
function c26052005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26052012)}) do
		fg:AddCard(pe:GetHandler())
	end
	local g1=Duel.GetMatchingGroup(c26052005.costfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,e:GetHandler())
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
function c26052005.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26052005,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(c26052005.atgfilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c26052005.atgfilter(e,c)
	return Duel.IsExistingMatchingCard(Card.IsRace,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,c:GetRace())
end
function c26052005.atkfilter(e,c)
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL then return false end
	if not (c:IsType(TYPE_FUSION) and c:IsRelateToBattle()) then return false end 
	local bc=c:GetBattleTarget()
	local bg=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_NORMAL)
	return bc and bg:IsExists(Card.IsRace,1,nil,bc:GetRace())
end
function c26052005.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsPublic,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil):Filter(Card.IsType,nil,TYPE_MONSTER)
	local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil,TYPE_NORMAL)
	return g:GetClassCount(Card.GetRace)*100
end