--Etherweight Clarent
function c26055006.initial_effect(c)
	--pendulum effect
		Pendulum.AddProcedure(c)
		--Negate targeting
		local pe1=Effect.CreateEffect(c)
		pe1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		pe1:SetCode(EVENT_CHAIN_SOLVING)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetCondition(c26055006.netgcon)
		pe1:SetOperation(c26055006.netgop)
		c:RegisterEffect(pe1)
	--equip effect (equipped by an "Etherweight" card effect)
		--atk up
		local eq1=Effect.CreateEffect(c)
		eq1:SetType(EFFECT_TYPE_EQUIP)
		eq1:SetCode(EFFECT_UPDATE_ATTACK)
		eq1:SetCondition(c26055006.eqcon)
		eq1:SetValue(500)
		c:RegisterEffect(eq1)
		--piercing
		eq2=pe1:Clone()
		eq2:SetRange(LOCATION_SZONE)
		eq2:SetCondition(aux.AND(c26055006.netgcon,c26055006.eqcon))
		c:RegisterEffect(eq2)
	--Monster Effect
		--add "Etherweight" card(s) to Hand
		local e1a=Effect.CreateEffect(c)
		e1a:SetDescription(aux.Stringid(26055006,0))
		e1a:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1a:SetProperty(EFFECT_FLAG_DELAY)
		e1a:SetCode(EVENT_SUMMON_SUCCESS)
		e1a:SetCountLimit(1,26055006)
		e1a:SetTarget(c26055006.thtg)
		e1a:SetOperation(c26055006.thop)
		c:RegisterEffect(e1a)
		local e1b=e1a:Clone()
		e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(e1b)
		local e1c=e1a:Clone()
		e1c:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e1c)
		--place scales
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26055006,1))
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_TO_DECK)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCountLimit(1,{26055006,1})
		e2:SetCondition(c26055006.tpcon)
		e2:SetTarget(c26055006.tptg)
		e2:SetOperation(c26055006.tpop)
		c:RegisterEffect(e2)
end
function c26055006.netgfilter(c,tp,loc) 
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsControler(tp)
end
function c26055006.netgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g==0 or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local pd,od=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil),Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)
	return rp~=tp and Duel.GetFlagEffect(tp,26055006)==0 and (#pd==0 or #od-#pd>=10) and g:IsExists(c26055006.netgfilter,1,nil,tp) and not g:IsContains(e:GetHandler()) and Duel.IsChainDisablable(ev)
end
function c26055006.netgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.RegisterFlagEffect(tp,26055006,RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c26055006.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(26055001) and c:GetEquipTarget()
end
function c26055006.thfilter(c)
	return c:IsSetCard(0x655) and c:IsMonster()
	and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c26055006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26055006.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c26055006.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26055006.thfilter,tp,LOCATION_EXTRA,0,nil)
	local xg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,1,c26055006.rescon,1,tp,HINTMSG_ATOHAND)
	if #sg>0 then
		aux.ToHandOrElse(sg,tp)
	end
end
function c26055006.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function c26055006.pcfilter(c)
	return c:IsSetCard(0x655) and c:IsType(TYPE_PENDULUM)   
	and c:IsFaceup() and not c:IsForbidden()
end
function c26055006.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) and Duel.IsExistingMatchingCard(c26055006.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
end
function c26055006.tpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26055006.pcfilter,tp,LOCATION_EXTRA,0,nil)
	if Duel.CheckPendulumZones(tp) and #g>0 then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false)~=0 then
			g:Sub(tc)
			local xg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
			if Duel.CheckPendulumZones(tp) and #g>0 and #xg==0 then
				local tc2=g:Select(tp,0,1,nil):GetFirst()
				if tc2 and Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false)~=0  then
					tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
				end
			end
		end
		tc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end