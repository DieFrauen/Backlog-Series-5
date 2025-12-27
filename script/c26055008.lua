--Etherweight Hauteclere
function c26055008.initial_effect(c)
	--pendulum effect
		Pendulum.AddProcedure(c)
		--prevent traps (summon)
		local pe1=Effect.CreateEffect(c)
		pe1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetCode(EVENT_SPSUMMON_SUCCESS)
		pe1:SetCondition(c26055008.trapcon)
		pe1:SetOperation(c26055008.cedop)
		c:RegisterEffect(pe1)
		local pe2=pe1:Clone()
		pe2:SetCode(EVENT_SUMMON_SUCCESS)
		pe2:SetCondition(aux.AND(c26055008.cedcon,c26055008.trapcon))
		c:RegisterEffect(pe2)
		local pe3=pe1:Clone()
		pe3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(pe3)
		local pe4=Effect.CreateEffect(c)
		pe4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		pe4:SetRange(LOCATION_PZONE)
		pe4:SetCode(EVENT_CHAIN_END)
		pe4:SetCondition(c26055008.trapcon)
		pe4:SetOperation(c26055008.cedop2)
		c:RegisterEffect(pe4)
		--prevent traps (effect)
		local pe5=Effect.CreateEffect(c)
		pe5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		pe5:SetCode(EVENT_CHAINING)
		pe5:SetRange(LOCATION_PZONE)
		pe5:SetCondition(c26055008.trapcon)
		pe5:SetOperation(c26055008.chainop)
		c:RegisterEffect(pe5)
		--prevent traps (attack)
		local pe6=Effect.CreateEffect(c)
		pe6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		pe6:SetCode(EVENT_ATTACK_ANNOUNCE)
		pe6:SetRange(LOCATION_PZONE)
		pe6:SetCondition(aux.AND(c26055008.attcon,c26055008.trapcon))
		pe6:SetOperation(c26055008.attop)
		c:RegisterEffect(pe6)
		local pe7=pe6:Clone()
		pe7:SetCode(EVENT_BE_BATTLE_TARGET)
		c:RegisterEffect(pe7)
	--equip effect (equipped by an "Etherweight" card effect)
		--atk up
		local eq1=Effect.CreateEffect(c)
		eq1:SetType(EFFECT_TYPE_EQUIP)
		eq1:SetCode(EFFECT_UPDATE_ATTACK)
		eq1:SetCondition(c26055008.eqcon)
		eq1:SetValue(300)
		c:RegisterEffect(eq1)
		--prevent traps (summon)
		local eq2=pe1:Clone()
		eq2:SetRange(LOCATION_SZONE)
		eq2:SetCondition(aux.AND(c26055008.eqcon,c26055008.trapcon))
		c:RegisterEffect(eq2)
		local eq3=eq2:Clone()
		eq3:SetCode(EVENT_SUMMON_SUCCESS)
		eq3:SetCondition(aux.AND(c26055008.eqcon,c26055008.cedcon,c26055008.trapcon))
		c:RegisterEffect(eq3)
		local eq4=eq3:Clone()
		eq4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(eq4)
		local eq5=pe4:Clone()
		eq5:SetRange(LOCATION_SZONE)
		eq5:SetCondition(aux.AND(c26055008.eqcon,c26055008.trapcon))
		c:RegisterEffect(eq5)
		--prevent traps (effect)
		local eq6=pe5:Clone()
		eq6:SetRange(LOCATION_SZONE)
		eq6:SetCondition(aux.AND(c26055008.eqcon,c26055008.trapcon))
		c:RegisterEffect(eq6)
		--prevent traps (attack)
		local eq7=pe6:Clone()
		eq7:SetRange(LOCATION_SZONE)
		eq7:SetCondition(aux.AND(c26055008.eqcon,c26055008.attcon,c26055008.trapcon))
		c:RegisterEffect(eq7)
		local eq8=eq7:Clone()
		eq8:SetCode(EVENT_BE_BATTLE_TARGET)
		c:RegisterEffect(eq8)
	--Monster Effect
		--send to gy
		local e1a=Effect.CreateEffect(c)
		e1a:SetDescription(aux.Stringid(26055008,0))
		e1a:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1a:SetProperty(EFFECT_FLAG_DELAY)
		e1a:SetCode(EVENT_SUMMON_SUCCESS)
		e1a:SetCountLimit(1,26055008)
		e1a:SetTarget(c26055008.thtg)
		e1a:SetOperation(c26055008.thop)
		c:RegisterEffect(e1a)
		local e1b=e1a:Clone()
		e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(e1b)
		local e1c=e1a:Clone()
		e1c:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e1c)
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26055008,1))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_HAND)
		e2:SetCountLimit(1,{26055008,1})
		e2:SetCondition(c26055008.spcon)
		e2:SetTarget(c26055008.sptg)
		e2:SetOperation(c26055008.spop)
		c:RegisterEffect(e2)
end
c26055008.listed_series={0x655}
c26055008.listed_names={26055008}
function c26055008.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(26055001) and c:GetEquipTarget()
end
function c26055008.trapcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
	or Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
end
function c26055008.cedfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c26055008.cedcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()~=e:GetHandler() and eg:IsExists(c26055008.cedfilter,1,nil)
end
function c26055008.cedop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c26055008.chlimit2)
end
function c26055008.cedop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) then
		Duel.SetChainLimitTillChainEnd(c26055008.chlimit2)
	end
end
function c26055008.chlimit2(re,rp,tp)
	return not (re:GetHandler():IsTrap() and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp~=tp)
end
function c26055008.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_PENDULUM) and re:IsMonsterEffect()  and re:GetOwnerPlayer()==tp then
		Duel.SetChainLimit(c26055008.chainlm)
	end
end
function c26055008.chainlm(e,rp,tp)
	return tp==rp or e:GetHandler():IsType(TYPE_TRAP)
end
function c26055008.atcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsType(TYPE_PENDULUM)
end
function c26055008.attop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c26055008.atlimit)
	e1:SetReset(RESET_PHASE|PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c26055008.atlimit(e,re,tp)
	return re and re:IsTrapEffect() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c26055008.thfilter(c)
	return c:IsSetCard(0x655) and c:IsMonster() and not c:IsCode(26055008) and c:IsAbleToGrave()
end
function c26055008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26055008.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK|LOCATION_EXTRA|LOCATION_HAND)
end
function c26055008.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg
	and #sg:Filter(Card.IsLocation,nil,LOCATION_DECK)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
end
function c26055008.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26055008.thfilter,tp,LOCATION_DECK|LOCATION_EXTRA|LOCATION_HAND,0,nil)
	local xg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	local ct=1; if #xg==0 then ct=3 end
	local sg=aux.SelectUnselectGroup(g,e,tp,1,ct,c26055008.rescon,1,tp,HINTMSG_TOGRAVE)
	if #sg>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c26055008.spfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c26055008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26055008.spfilter,1,nil)
end
function c26055008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c26055008.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		--Banish it if it leaves the field
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		--c:RegisterEffect(e1,true)
	end
end