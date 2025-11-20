--SNI-Pyre Roulette
function c26054011.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate (again)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054011,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c26054011.tfcon)
	e2:SetTarget(c26054011.tftg)
	e2:SetOperation(c26054011.tfop)
	c:RegisterEffect(e2)
	--enable sharing xyz materials
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(26054011)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetDescription(aux.Stringid(26054011,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c26054011.cost)
	e5:SetTarget(c26054011.target)
	e5:SetOperation(c26054011.operation)
	local eS5=Effect.CreateEffect(c)
	eS5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	eS5:SetRange(LOCATION_FZONE)
	eS5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	eS5:SetTarget(c26054011.eftg)
	eS5:SetLabel(0)
	eS5:SetLabelObject(e5)
	c:RegisterEffect(eS5)
	--destroy
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(26054011,3))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	local eS6=eS5:Clone()
	eS6:SetLabel(1)
	eS6:SetHintTiming(TIMING_END_PHASE,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E|TIMING_END_PHASE)
	eS6:SetLabelObject(e6)
	c:RegisterEffect(eS6)
end
c26054011.roll_dice=true
c26054011.listed_series={0x1654}
function c26054011.tfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST|REASON_EFFECT) and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c26054011.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetActivateEffect():IsActivatable(tp,true,true) end
end
function c26054011.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local c=e:GetHandler()
	if c and c:IsRelateToEffect(e) and c:GetActivateEffect():IsActivatable(tp,true,true) then 
		Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c26054011.eftg(e,c)
	local lab=e:GetLabel()
	if c:GetSequence()>4 then return lab==1 end
	return lab==0 
end
function c26054011.dcfilter(c)
	return c:GetSequence()>4 --or c:ListsCode(c:GetCode())
end
function c26054011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26054111)==0 end
	c:RegisterFlagEffect(26054111,RESETS_STANDARD_PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26054011,4))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c26054011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local c=e:GetHandler()
	local ovg=c:GetOverlayCount()
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:IsType(TYPE_XYZ) and ovg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c26054011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local ovg=c:GetOverlayGroup()
		if not c:IsRelateToEffect(e) or ovg==0 then return end
		c:AddCounter(0x1654,1)
		local d=Duel.TossDice(tp,1)
		local ct=c:GetCounter(0x1654)+c:GetOverlayCount()
		if ct>=d then
			local ov=ovg:Select(tp,1,1,nil)
			if #ov>0 and  Duel.SendtoGrave(ov,REASON_EFFECT)>0 then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
end