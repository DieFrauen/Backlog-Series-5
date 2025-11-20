--SNI-Pyre Ace - Delvigne
function c26054005.initial_effect(c)
	--Add 1 "SNI-Pyre" card from your Deck to your hand then overlay
	local e1a=Effect.CreateEffect(c)
	e1a:SetDescription(aux.Stringid(26054005,0))
	e1a:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1a:SetProperty(EFFECT_FLAG_DELAY)
	e1a:SetCode(EVENT_SUMMON_SUCCESS)
	e1a:SetCountLimit(1,26054005)
	e1a:SetTarget(c26054005.thtg)
	e1a:SetOperation(c26054005.thop)
	c:RegisterEffect(e1a)
	local e1b=e1a:Clone()
	e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	local e1c=e1a:Clone()
	e1c:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1c)
	--burn target atk/destroy ST/Banish from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054005,1))
	e2:SetCategory(CATEGORY_POSITION|CATEGORY_DESTROY|CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c26054005.poscon)
	e2:SetTarget(c26054005.postg)
	e2:SetOperation(c26054005.posop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_QUICK_O|EFFECT_TYPE_XMATERIAL)
	e3:SetCondition(c26054005.xyzcon)
	e3:SetCost(c26054005.xyzcost)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(TIMING_END_PHASE)
	c:RegisterEffect(e3)
	
end
c26054005.listed_series={0x654}
c26054005.listed_names={26054002}
function c26054005.thfilter(c)
	return c:IsSetCard(SET_TELLARKNIGHT) and c:IsMonster() and not c:IsCode(id) and c:IsAbleToHand()
end
function c26054005.thfilter(c,tp)
	return c:IsSetCard(0x654) and c:IsAbleToHand()
	and not Duel.IsExistingMatchingCard(c26054005.snfilter,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
function c26054005.snfilter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function c26054005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26054005.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26054005.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26054005.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(c:GetLevel()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c26054005.poscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c26054005.posfilter(c,e,tp)
	return c:IsCanTurnSet() or c:IsDefensePos()
	and c:IsCanBeEffectTarget(e) or Duel.IsPlayerAffectedByEffect(tp,26054009)
end
function c26054005.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	local g=Duel.GetMatchingGroup(c26054004.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,e,tp)
	local og=math.floor(Duel.GetOverlayCount(tp,1,0)/2)
	local ct=math.min(2,og)
	if chk==0 then return #g>0 and ct>0 and c26054005.ovg(e,c,tp,1,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c26054005.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,c,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c26054005.chkfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c26054005.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c26054005.chkfilter,nil,e)
	if #g==0 or not c26054005.ovg(e,c,tp,#g,0) then return end
	local ct=c26054005.ovg(e,c,tp,#g,1)
	if ct>0 then
		local tg=g:Select(tp,ct,ct,nil)
		local tc=tg:GetFirst()
		for tc in aux.Next(tg) do
			local pos=POS_FACEDOWN_DEFENSE 
			if tc:IsAttackPos() then
				Duel.HintSelection(tc)
				pos=Duel.SelectPosition(tp,tc,POS_DEFENSE)
			elseif tc:IsFacedown() then pos=POS_FACEUP_DEFENSE end 
			Duel.ChangePosition(tc,pos)
		end
	end
end
function c26054005.ovg(e,c,tp,g,chk)
	local ov1=c:GetOverlayGroup()
	local ov2=Duel.GetOverlayGroup(tp,1,0)
	if not Duel.IsPlayerAffectedByEffect(tp,26054011) then
		ov2=ov2:Filter(Card.IsCode,nil,26054002)
	end
	ov1:Merge(ov2)
	if Duel.IsPlayerAffectedByEffect(tp,26054015) then
		local ov3=Duel.GetMatchingGroup(c26054015.ammo,tp,LOCATION_HAND,0,nil)
		ov1:Merge(ov3)
	end
	if chk==0 then
		return #ov1>0
	end
	if chk==1 then
		local dc=ov1:Select(tp,1,g,nil)
		if #dc>0 then
			local dc1,dc2=dc:Split(Card.IsLocation,nil,LOCATION_OVERLAY)
			Duel.SendtoGrave(dc1,REASON_EFFECT+REASON_XYZ)
			Duel.SendtoGrave(dc2,REASON_EFFECT+REASON_DISCARD)
		end
		return #dc
	end
end
function c26054005.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c26054005.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x654)
end