--Guldengeist Haploduce
function c26051011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26051011,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c26051011.announcecost)
	e1:SetCondition(c26051011.thcon)
	e1:SetTarget(c26051011.thtg)
	e1:SetOperation(c26051011.thop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c26051011.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	c:RegisterEffect(e1)
	--add target from gy to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26051011,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,26051011)
	e3:SetCost(c26051011.announcecost)
	e3:SetTarget(c26051011.tdtg)
	e3:SetOperation(c26051011.tdop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
c26051011.listed_series={0x651}
function c26051011.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x651)
	and c:GetFlagEffect(26051000)==0 and c:GetCode()~=26051011
end
function c26051011.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand() and c:IsMonster()
end
function c26051011.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsStatus(STATUS_SUMMON_TURN)
end
function c26051011.announcecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26051011)==0
	and (c:GetFlagEffect(26051000)==0 or c:GetOriginalCode()==26051011) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:RegisterFlagEffect(26051000,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
	c:RegisterFlagEffect(26051011,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26051011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetHandler():GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(c26051011.thfilter,tp,LOCATION_DECK,0,1,nil,code) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c26051011.thop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26051011.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26051011.tdfilter(c,e)
	return c:IsMonster() and c:IsAbleToDeck()
	and c:IsCanBeEffectTarget(e) and c:GetLevel()==1
end
function c26051011.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg
	or sg:GetClassCount(Card.GetCode)==1
end
function c26051011.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c26051011.tdfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,#g,c26051011.rescon,0)
	end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,#g,c26051011.rescon,1,tp,HINTMSG_TODECK)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c26051011.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKTOP,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK|LOCATION_EXTRA)
	local hc=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local tt=ct-hc
	if tt>=1 and Duel.IsPlayerCanDraw(tp,tt) and Duel.SelectYesNo(tp,aux.Stringid(26051011,2)) then
		Duel.BreakEffect()
		Duel.Draw(tp,tt,REASON_EFFECT)
	end
end