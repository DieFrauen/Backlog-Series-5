--SNI-Pyre Reload
function c26054013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26054013,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,{26054013,1},EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26054013.target1)
	e1:SetOperation(c26054013.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054013,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26054013,EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c26054013.target2)
	e2:SetOperation(c26054013.activate2)
	c:RegisterEffect(e2)
	--activate (again)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054013,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,{26054013,2})
	e2:SetCondition(c26054013.matcon)
	e2:SetTarget(c26054013.mattg)
	e2:SetOperation(c26054013.matop)
	c:RegisterEffect(e2)
end
c26054013.listed_series={0x654}
function c26054013.filter1(c)
	return c:IsSetCard(0x654) and c:IsDiscardable(REASON_EFFECT)
end
function c26054013.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c26054013.filter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26054013.activate1(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.DiscardHand(tp,c26054013.filter1,1,99,REASON_EFFECT|REASON_DISCARD,e:GetHandler())
	if dc>0 then
		Duel.Draw(tp,dc+1,REASON_EFFECT)
	end
end
function c26054013.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c26054013.ovfilter(c)
	return c:IsSetCard(0x654) and not (c:IsForbidden() or c:IsType(TYPE_XYZ))
end
function c26054013.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26054013.filter2(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(c26054013.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26054013.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26054013.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		local g=Group.FromCards(c)
		local fg=Duel.GetMatchingGroup(c26054013.ovfilter,tp,LOCATION_ONFIELD|LOCATION_HAND,0,c)
		local fc=math.min(2,#fg)
		if fc>0 then
			fg=fg:Select(tp,0,fc,c)
			local g1,g2=fg:Split(Card.IsPublic,c)
			Duel.HintSelection(g1)
			Duel.ConfirmCards(1-tp,g2)
			g:Merge(fg)
		end
		c:CancelToGrave()
		Duel.Overlay(tc,g)
		Duel.Draw(tp,#g,REASON_EFFECT)
	end
end
function c26054013.matcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DISCARD) then return true end
	return c:IsReason(REASON_COST|REASON_EFFECT) and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c26054013.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c26054013.matfilter(c)
	return c:IsRace(RACE_PYRO) and not c:IsForbidden()
end
function c26054013.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c26054013.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26054013.xyzfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c26054013.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26054013.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c26054013.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_XYZ) then
		local mt=1
		if tc:GetOverlayCount()==0 then mt=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c26054013.matfilter,tp,LOCATION_GRAVE,0,1,mt,nil)
		Duel.HintSelection(g)
		Duel.Overlay(tc,g)
	end
end