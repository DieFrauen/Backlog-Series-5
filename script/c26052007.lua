--Aviaris - Majestuous Nomencreation
function c26052007.initial_effect(c)
	Fusion.AddProcMixRep(c,true,true,c26052007.ffilter,2,4)
	Fusion.AddContactProc(c,c26052007.contactfil,c26052007.contactop,c26052007.splimit,nil,nil,aux.Stringid(26052007,0),false)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c26052007.efilter)
	c:RegisterEffect(e1)
	--Disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052007,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c26052007.discon)
	e2:SetCost(c26052007.cost)
	e2:SetOperation(function() Duel.NegateAttack() end)
	c:RegisterEffect(e2)
	--Disable target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26052007,2))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c26052007.discon2)
	e3:SetCost(c26052007.cost)
	e3:SetTarget(c26052007.distg)
	e3:SetOperation(function(e,tp,eg,ep,ev) Duel.NegateEffect(ev) end)
	c:RegisterEffect(e3)
end
c26052007.RACES=(RACE_WINGEDBEAST+RACE_FAIRY+RACE_INSECT+RACE_ILLUSION) 
function c26052007.ffilter(c,fc,sumtype,sp,sub,mg,sg)
	local rc=c26052007.RACES
	return c:IsRace(rc,fc,sumtype,sp) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace(),fc,sumtype,sp))
end
function c26052007.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetLocation()~=LOCATION_EXTRA 
end
function c26052007.contactfil(tp)
	return Duel.GetMatchingGroup(c26052007.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
end
function c26052007.mtfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_NORMAL)
end
function c26052007.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c26052007.efilter(e,re,rp)
	return re:IsSpellTrapEffect()
end
function c26052007.disfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c26052007.discon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	if a and d and d:IsType(TYPE_FUSION) and d:IsControler(tp) then
		e:SetLabel(a:GetRace())
		return true
	end
end
function c26052007.discon2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if tg and tg:IsExists(c26052007.disfilter,1,nil,tp) then
		e:SetLabel(re:GetHandler():GetRace())
		return rp~=tp and re:IsMonsterEffect()
		and Duel.IsChainNegatable(ev)
	end
end
function c26052007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26052012)}) do
		fg:AddCard(pe:GetHandler())
	end
	local g1=Duel.GetMatchingGroup(c26052007.costfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,nil)
	if #fg>0 then
		local g2=Duel.GetMatchingGroup(c26052012.costfilter,tp,LOCATION_DECK,0,nil,e,tp)
		g1:Merge(g2)
	end
	local g3=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,e:GetLabel())
	if chk==0 then return (#g1>0 or #g3>0) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	if #g3==0 or Duel.SelectYesNo(tp,aux.Stringid(26052007,4)) then
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
end
function c26052007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end