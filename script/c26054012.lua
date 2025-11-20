--SNI-Pyre's Bounty
function c26054012.initial_effect(c)
	--Activate
	local e0=aux.AddEquipProcedure(c)
	e0:SetCost(c26054012.reg)
	e0:SetCountLimit(1,{26054012,1},EFFECT_COUNT_CODE_OATH)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26054012,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c26054012.thcon)
	e1:SetTarget(c26054012.thtg)
	e1:SetOperation(c26054012.thop)
	c:RegisterEffect(e1)
	--draw 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054012,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,26054012)
	e2:SetCondition(c26054012.drcon)
	e2:SetTarget(c26054012.drtg)
	e2:SetOperation(c26054012.drop)
	c:RegisterEffect(e2)
	--shuffle to Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26054012,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,26054012)
	e3:SetCondition(c26054012.tdcon)
	e3:SetTarget(c26054012.tdtg)
	e3:SetOperation(c26054012.tdop)
	c:RegisterEffect(e3)
end
c26054012.listed_series={0x654}
function c26054012.thfilter(c)
	return c:IsSetCard(0x654) and c:IsMonster()
	and c:IsAbleToHand() --and c:IsType(TYPE_EFFECT)
end
function c26054012.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(26054012,RESET_PHASE|PHASE_END,EFFECT_FLAG_OATH,1)
end
function c26054012.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(26054012)~=0
end
function c26054012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c26054012.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26054012,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetLabelObject(c)
	e1:SetCondition(c26054012.d2con)
	e1:SetOperation(c26054012.d2op)
	e1:SetReset(RESET_CHAIN)
	tc:RegisterEffect(e1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c26054012.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c26054012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26054012.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	local dc=1
	if c:GetFlagEffect(26054012)~=0 then
		dc=2
	end
	if c:IsReason(REASON_LOST_TARGET) and ec and ec:IsReason(REASON_DESTROY) and ec:GetReasonPlayer()==tp then
		e:SetLabel(tp)
		return Duel.IsPlayerCanDraw(tp,dc)
	end
end
function c26054012.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local c=e:GetHandler()
	local dc=1
	if c:GetFlagEffect(26054112)~=0 then
		dc=2
		c:ResetFlagEffect(26054112)
	end
	if e:GetHandler():GetFlagEffect(26054112)~=0 then dc=2 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dc)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dc)
end
function c26054012.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c26054012.d2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=0
	if c:IsReason(REASON_BATTLE) then 
		rc=Duel.GetAttacker()
		return rc:IsSetCard(0x654)
	end
	rc=re:GetHandler()
	local p,rg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TARGET_CARDS)
	if not (rc and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	return c:IsReason(REASON_DESTROY) and rc:IsSetCard(0x654) and #rg>0 and rg:IsContains(c)
end
function c26054012.d2op(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():RegisterFlagEffect(26054112,RESETS_STANDARD_PHASE_END-RESET_TOGRAVE-RESET_LEAVE,0,1)
	Duel.Hint(HINT_CARD,tp,26054012)
end
function c26054012.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DISCARD) then return true end
	return c:IsReason(REASON_COST|REASON_EFFECT) and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c26054012.tdfilter1(c,e,tp)
	return c:IsSetCard(0x654) and c:IsType(TYPE_NORMAL)
	and c:IsMonster() and c:IsAbleToDeck() and
	(c:IsCanBeEffectTarget(e) or Duel.IsPlayerAffectedByEffect(tp,26054009))
end
function c26054012.tdfilter2(c,e,tp)
	return c:IsMonster() and c:IsAbleToDeck() and
	(c:IsCanBeEffectTarget(e) or Duel.IsPlayerAffectedByEffect(tp,26054009))
end
function c26054012.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g1=Duel.GetMatchingGroup(c26054012.tdfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c26054012.tdfilter2,tp,0,LOCATION_GRAVE,nil,e,tp)
	if chk==0 then return #g1>0 and #g2>0 end
	local tg=g1:Select(tp,1,math.min(3,#g2),nil)
	local tg2=g2:Select(tp,#tg,#tg,nil)
	tg:Merge(tg2)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,tp,0)
end
function c26054012.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end