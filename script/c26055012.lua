--Etherweight Beckon
function c26055012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE|CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26055012)
	e1:SetTarget(c26055012.target)
	e1:SetOperation(c26055012.activate)
	c:RegisterEffect(e1)
	--Return "Etherweight" pendulums to Extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26055012,5))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26055012)
	e2:SetCost(Cost.SelfToDeck)
	e2:SetTarget(c26055012.tdtg)
	e2:SetOperation(c26055012.tdop)
	c:RegisterEffect(e2)
end
function c26055012.filter(c,p1,p2,p3)
	if not c:IsSetCard(0x655)  then return false end
	if p1 and c:IsAbleToHand() and c:IsMonster() then return true
	elseif p2 and c:IsAbleToGrave() then return true
	elseif p3 and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() then return true end
	return false
end
function c26055012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26055012.filter,tp,LOCATION_DECK,0,1,nil,true,true,true) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26055012.activate(e,tp,eg,ep,ev,re,r,rp)
	local p1,p2,p3=true,true,true
	local g=Duel.GetMatchingGroup(c26055012.filter,tp,LOCATION_DECK,0,nil,p1,p2,p3)
	local xg=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)-Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	while #g>0 do
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local b1=c26055012.filter(tc,p1,false,false)
		local b2=c26055012.filter(tc,false,p2,false)
		local b3=c26055012.filter(tc,false,false,p3)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26055012,1))
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(26055012,2)},
			{b2,aux.Stringid(26055012,3)},
			{b3,aux.Stringid(26055012,4)})
		if op==1 then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc); p1=false
		elseif op==2 then
			Duel.SendtoGrave(tc,REASON_EFFECT); p2=false
		elseif op==3 then
			Duel.SendtoExtraP(tc,tp,REASON_EFFECT); p3=false
		end
		xg=xg-5
		if xg<5 then return end
		g=Duel.GetMatchingGroup(c26055012.filter,tp,LOCATION_DECK,0,nil,p1,p2,p3)
	end
end
function c26055012.tdfilter(c)
	return c:IsSetCard(0x655) and c:IsType(TYPE_PENDULUM) and c:IsMonster() and c:IsAbleToExtra()
end
function c26055012.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26055012.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26055012.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26055012,5))
	local tg=Duel.SelectTarget(tp,c26055012.tdfilter,tp,LOCATION_GRAVE,0,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c26055012.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.SendtoExtraP(tg,nil,REASON_EFFECT)
		local tdg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if #tdg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26055012,6))
			local tdc=tdg:Select(tp,0,#tg,nil)
			if #tdc>0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(tdc,nil,2,REASON_EFFECT)
			end
		end
	end
end