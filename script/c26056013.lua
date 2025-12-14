--Tetramancer's Minora
function c26056013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE|CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	local TIMINGS =TIMING_BATTLE_STEP_END|TIMING_ATTACK
	e1:SetHintTiming(TIMINGS,TIMINGS|TIMING_END_PHASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26056013,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26056013.target)
	e1:SetOperation(c26056013.activate)
	c:RegisterEffect(e1)
	--Send to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056013,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabel(1)
	e2:SetCondition(c26056013.qcon1)
	e2:SetCost(c26056013.tdcost)
	e2:SetTarget(c26056013.tdtg)
	e2:SetOperation(c26056013.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c26056013.qcon2)
	c:RegisterEffect(e3)
	--place counter
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(26056013,1))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetLabel(2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(c26056013.qcon2)
	c:RegisterEffect(e5)
	--place counter
	local e6=e2:Clone()
	e6:SetDescription(aux.Stringid(26056013,2))
	e6:SetCategory(0)
	e6:SetLabel(3)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetCondition(c26056013.qcon2)
	c:RegisterEffect(e7)
end
function c26056013.filter(c,e,p,lb)
	if not c:IsFaceup() then return false end
	if lb==1 then return c26056013.tdop1(e,p,c,0)
	elseif lb==2 then return c26056013.tdop2(e,p,c,0)
	elseif lb==3 then return c26056013.tdop3(e,p,c,0) 
	else return c26056013.tdop1(e,p,c,0)
	or c26056013.tdop2(e,p,c,0)
	or c26056013.tdop3(e,p,c,0) end
end
function c26056013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc==0 then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c26056013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e,tp,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26056013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,e,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c26056013.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e)) then tc=nil end
	local b1=c26056013.tdop1(e,tp,tc,0)
	local b2=c26056013.tdop2(e,tp,tc,0)
	local b3=c26056013.tdop3(e,tp,tc,0)
	if b1 and (not (b2 or b3) or
	Duel.SelectYesNo(tp,aux.Stringid(26056013,0))) then
		c26056013.tdop1(e,tp,tc,1)
		b1=true
	else b1=false end
	if not tc then return end
	b2=c26056013.tdop2(e,tp,tc,0)
	if b2 and (not (b1 or b3) or
	Duel.SelectYesNo(tp,aux.Stringid(26056013,1))) then
		Duel.BreakEffect()
		c26056013.tdop2(e,tp,tc,1)
		b2=true
	else b2=false end
	b3=c26056013.tdop3(e,tp,tc,0)
	if b3 and (not (b1 or b2) or
	Duel.SelectYesNo(tp,aux.Stringid(26056013,2))) then
		Duel.BreakEffect()
		c26056013.tdop3(e,tp,tc,1)
	end
end
function c26056013.tgfilter(c,e,p,tc)
	local code=c:GetCode()
	return c:IsSetCard(0x1656) and c:IsMonster() and c:IsAbleToGrave() and not Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,code) and (not tc or not tc:IsCode(code))
end
function c26056013.tdop1(e,tp,tc,chk)
	local g=Duel.GetMatchingGroup(c26056013.tgfilter,tp,LOCATION_DECK,0,nil,e,tp,tc)
	if chk==0 then return #g>0 end
	local sc=g:Select(tp,1,1,nil):GetFirst()
	if sc then
		Duel.SendtoGrave(sc,REASON_EFFECT)
		Duel.AdjustInstantly(sc)
	end 
end
function c26056013.counter(c,ct,tc)
	return c:IsSetCard(0x1656) and c:IsMonster()
	and c:PlacesCounter(ct)
	and tc:GetCounter(ct)==0
	and tc:IsCanAddCounter(ct,1)
end
function c26056013.tdop2(e,tp,tc,chk)
	local b1,b2,b3,b4=false,false,false,false
	local gg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,1,nil)
	if gg:IsExists(c26056013.counter,1,nil,0x1656,tc) then
		ct=0x1656; c26056002.TETRAFLARE(e,tp); b1=true end
	if gg:IsExists(c26056013.counter,1,nil,0x1657,tc) then
		ct=0x1657;  c26056003.TETRALAND(e,tp); b2=true end
	if gg:IsExists(c26056013.counter,1,nil,0x1658,tc) then
		ct=0x1658;   c26056004.TETRAQUA(e,tp); b3=true end
	if gg:IsExists(c26056013.counter,1,nil,0x1659,tc) then
		ct=0x1659;  c26056005.TETRAIR(e,tp); b4=true end
	if chk==0 then return (b1 or b2 or b3 or b4) end
	if (b1 or b2 or b3 or b4) then
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(26056013,4)},
			{b2,aux.Stringid(26056013,5)},
			{b3,aux.Stringid(26056013,6)},
			{b4,aux.Stringid(26056013,7)})
		local ct=op>0 and 0x1655+op or nil
		if ct and tc:IsCanAddCounter(ct) then 
			Duel.BreakEffect()
			tc:AddCounter(ct,1) 
		end
	end
end
function c26056013.tdop3(e,tp,tc,chk)
	if chk==0 then
		return tc and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:GetSequence()<5 and tc:CheckAdjacent()
	end
	tc:MoveAdjacent(tp)
end
function c26056013.qcon1(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and rp~=tp
end
function c26056013.qcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.IsTurnPlayer(1-tp)
end
function c26056013.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoDeck(c,nil,1,REASON_COST)
end
function c26056013.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lb=e:GetLabel()
	if chkc==0 then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c26056013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e,tp,lb) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26056013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,e,tp)
	if lb==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif lb==2 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
	end
end
function c26056013.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local op=e:GetLabel()
	if op==1 then
		c26056013.tdop1(e,tp,tc,1)
	elseif op==2 then
		c26056013.tdop2(e,tp,tc,1)
	elseif op==3 then
		c26056013.tdop3(e,tp,tc,1)
	end
end