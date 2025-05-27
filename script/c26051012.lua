--Guldengeist Geodesire
function c26051012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26051012,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c26051012.announcecost)
	e1:SetCondition(c26051012.tgcon)
	e1:SetTarget(c26051012.tgtg)
	e1:SetOperation(c26051012.tgop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c26051012.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	c:RegisterEffect(e1)
	--add target from gy to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26051012,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,26051012)
	e3:SetCost(c26051012.announcecost)
	e3:SetTarget(c26051012.thtg)
	e3:SetOperation(c26051012.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
c26051012.listed_series={0x651}
function c26051012.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x651)
	and c:GetFlagEffect(26051000)==0 and c:GetCode()~=26051012
end
function c26051012.cpfilter(c,code)
	return c:IsCode(code)
end
function c26051012.tgfilter(c,tp)
	return c:IsSetCard(0x651) and c:IsAbleToGrave()
	and not Duel.IsExistingMatchingCard(c26051012.cpfilter,tp,LOCATION_GRAVE,0,1,nil,code) 
end
function c26051012.announcecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26051012)==0
	and (c:GetFlagEffect(26051000)==0 or c:GetOriginalCode()==26051012) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:RegisterFlagEffect(26051000,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
	c:RegisterFlagEffect(26051012,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26051012.tgcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsStatus(STATUS_SUMMON_TURN)
end
function c26051012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetHandler():GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(c26051012.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c26051012.tgop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26051012.tgfilter,tp,LOCATION_DECK,0,1,1,nil,code)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c26051012.thfilter(c,e)
	return c:IsSetCard(0x651) and c:IsAbleToHand()
end
function c26051012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c26051012.tfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	if chk==0 then return Duel.IsExistingTarget(c26051012.thfilter,tp,LOCATION_GRAVE,0,2,nil)
	end
	local tg=Duel.SelectTarget(tp,c26051012.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,0)
end
function c26051012.rescon(sg,e,tp,mg)
	return (#sg==2 and not sg:IsContains(e:GetHandler())) or #sg==1
end
function c26051012.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg and tg:FilterCount(Card.IsRelateToEffect,nil,e)==2 and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then hg:AddCard(c) end
		local sg=aux.SelectUnselectGroup(hg,e,tp,1,2,c26051012.rescon,1,tp,HINTMSG_TODECK,c26051012.rescon)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end