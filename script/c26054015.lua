--SNI-Pyre Barrage
function c26054015.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate (again)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054015,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,{26054015,2})
	e2:SetCondition(c26054015.tfcon)
	e2:SetTarget(c26054015.tftg)
	e2:SetOperation(c26054015.tfop)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26054015,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,26054015)
	e3:SetTarget(c26054015.mattg)
	e3:SetOperation(c26054015.matop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(26054015,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,{26054015,1})
	e4:SetCost(c26054015.cost)
	e4:SetTarget(c26054015.target)
	e4:SetOperation(c26054015.operation)
	local eS4=Effect.CreateEffect(c)
	eS4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	eS4:SetRange(LOCATION_SZONE)
	eS4:SetTargetRange(LOCATION_MZONE,0)
	eS4:SetTarget(c26054015.eftg)
	eS4:SetLabelObject(e4)
	c:RegisterEffect(eS4)
	--enable hand as xyz materials
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(26054015)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	
end
c26054015.toss_coin=true
c26054015.listed_series={0x654,0x1654}
function c26054015.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c26054015.matfilter,tp,LOCATION_GRAVE|LOCATION_HAND,0,1,c,c)
end
function c26054015.matfilter(c,tc)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsMonster() and tc:ListsCode(c:GetCode())
end
function c26054015.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c26054015.xyzfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c26054015.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26054015.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetPossibleOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c26054015.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c26054015.matfilter,tp,LOCATION_HAND|LOCATION_GRAVE,0,1,1,tc,tc)
		if #g>0 then
			Duel.Overlay(tc,g,true)
		end
	end
end
function c26054015.tfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST|REASON_EFFECT) and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c26054015.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,tp,0)
	end
end
function c26054015.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local c=e:GetHandler()
	if c and c:IsRelateToEffect(e) then 
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c26054015.eftg(e,c)
	return c:IsSetCard(0x654) and c:IsType(TYPE_XYZ)
end
function c26054015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c26054015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c:IsControler(1-tp) end
	local c=e:GetHandler()
	local oc=c:GetOverlayCount()
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) and oc>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,oc,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c26054015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		local ov=c:GetOverlayCount()
		if not c:IsRelateToEffect(e) or ov==0 then return end
		local heads=Duel.CountHeads(Duel.TossCoin(tp,ov))
		local tails=ov-heads
		local ovg=c:GetOverlayGroup()
		if Duel.IsPlayerAffectedByEffect(tp,26054015) then
			local hg=Duel.GetMatchingGroup(c26054015.ammo,tp,LOCATION_HAND,0,nil)
			ovg:Merge(hg)
		end
		if tails>0 then
			c:AddCounter(0x1654,tails)
		end
		if heads>0 then
			local max=math.min(#tg,heads)
			local gc=ovg:Select(tp,1,max,nil)
			if #gc>0 and Duel.SendtoGrave(gc,REASON_EFFECT)>0 then
				local sg=tg:Select(1-tp,#gc,#gc,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end
function c26054015.ammo(c)
	return c:IsDiscardable() 
end