--Drachor - Fantastic Nomencreation
function c26052008.initial_effect(c)
	Fusion.AddProcMixRep(c,true,true,c26052008.ffilter,2,4)
	Fusion.AddContactProc(c,c26052008.contactfil,c26052008.contactop,c26052008.splimit,nil,nil,aux.Stringid(26052008,0),false)
	--return self to Extra
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c26052008.condition)
	e1:SetOperation(c26052008.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052008,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c26052008.cost)
	e2:SetTarget(c26052008.destg)
	e2:SetOperation(c26052008.desop)
	c:RegisterEffect(e2)
	--indestructible
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(c26052008.indval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION))
	e4:SetValue(c26052008.indval2)
	c:RegisterEffect(e4)
end
c26052008.RACES=(RACE_DRAGON+RACE_DINOSAUR+RACE_WYRM+RACE_FIEND)
function c26052008.ffilter(c,fc,sumtype,sp,sub,mg,sg)
	local rc=c26052008.RACES
	return c:IsRace(rc,fc,sumtype,sp) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace(),fc,sumtype,sp))
end
function c26052008.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetLocation()~=LOCATION_EXTRA 
end
function c26052008.contactfil(tp)
	return Duel.GetMatchingGroup(c26052008.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
end
function c26052008.mtfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_NORMAL)
end
function c26052008.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c26052008.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c26052008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Return it to the Extra Deck when it leaves the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26052008,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(LOCATION_DECKBOT)
	e1:SetReset(RESET_EVENT|RESETS_REDIRECT -RESET_TOFIELD)
	c:RegisterEffect(e1,true)
end
function c26052008.indval(e,re,rp)
	return re:IsSpellTrapEffect() 
end
function c26052008.indval2(e,re,rp)
	local tp,rc=e:GetHandlerPlayer(),re:GetHandler():GetRace()
	return re:IsMonsterEffect() and Duel.IsExistingMatchingCard(Card.IsRace,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,rc)
end
function c26052008.costfilter(c)
	return c:IsMonster() and c:IsReleasable()
end
function c26052008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26052012)}) do
		fg:AddCard(pe:GetHandler())
	end
	local g1=Duel.GetMatchingGroup(c26052008.costfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,nil)
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
function c26052008.desfilter(c)
	return c:IsMonster() and c:IsFaceup()
	and Duel.IsExistingMatchingCard(Card.IsRace,0,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c:GetRace())
end
function c26052008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c26052008.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c26052008.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c26052008.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end