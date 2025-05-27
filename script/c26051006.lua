--Guldengeist Ascension
function c26051006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26051006.target)
	e1:SetOperation(c26051006.activate)
	c:RegisterEffect(e1)
end
function c26051006.filter1(c)
	return c:IsSetCard(0x651) and c:IsMonster() and c:IsAbleToHand()
end
function c26051006.filter2(c)
	return c:IsSetCard(0x651) and c:IsAbleToDeck()
end
function c26051006.filter3(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c26051006.filter4(c)
	return c:IsSetCard(0x651) and c:IsSummonable(true)
end
function c26051006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c26051006.filter1,tp,LOCATION_DECK,0,1,nil)
	local p1=Duel.GetFlagEffect(tp,26051006)==0
	local b2=Duel.IsExistingMatchingCard(c26051006.filter2,tp,LOCATION_GRAVE,0,1,nil)
	local p2=Duel.GetFlagEffect(tp,26051106)==0
	local b3=Duel.IsExistingMatchingCard(c26051006.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	local p3=Duel.GetFlagEffect(tp,26051206)==0
	local b4=Duel.IsExistingMatchingCard(c26051006.filter4,tp,LOCATION_HAND,0,1,nil)
	local p4=Duel.GetFlagEffect(tp,26051306)==0
	if chk==0 then
		if p1 then return b1
		elseif p2 then return b2
		elseif p3 then return b3
		elseif p4 then return b4
		end
	end
	if p1 then Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) end
	if p2 then Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE) end
	if p3 then Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD) end
	if p4 then Duel.SetPossibleOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND) end
end
function c26051006.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup
	(c26051006.filter1,tp,LOCATION_DECK,0,nil)
	local p1=Duel.GetFlagEffect(tp,26051006)==0
	local g2=Duel.GetMatchingGroup
	(c26051006.filter2,tp,LOCATION_GRAVE,0,nil)
	local p2=Duel.GetFlagEffect(tp,26051106)==0
	local g3=Duel.GetMatchingGroup
	(c26051006.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local p3=Duel.GetFlagEffect(tp,26051206)==0
	local g4=Duel.GetMatchingGroup  
	(c26051006.filter4,tp,LOCATION_HAND,0,nil)
	local p4=Duel.GetFlagEffect(tp,26051306)==0
	local tc1,tc2,tc3,tc4=nil
	if p1 and #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc1=g1:Select(tp,1,1,nil):GetFirst()
		if tc1 then
			Duel.SendtoHand(tc1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc1)
			g2:Remove(Card.IsCode,nil,tc1:GetCode())
			g3:Remove(Card.IsCode,nil,tc1:GetCode())
			g4:Remove(Card.IsCode,nil,tc1:GetCode())
			Duel.RegisterFlagEffect(tp,26051006,RESET_PHASE+PHASE_END,0,1)
			if not (p2 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(26051006,1))) then return end
		else return end
	end
	if p2 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc2=g2:Select(tp,1,1,nil):GetFirst()
		if tc2 then
			Duel.SendtoDeck(tc2,nil,2,REASON_EFFECT)
			g3:Remove(Card.IsCode,nil,tc2:GetCode())
			g4:Remove(Card.IsCode,nil,tc2:GetCode())
			Duel.RegisterFlagEffect(tp,26051106,RESET_PHASE+PHASE_END,0,1)
			if not (p3 and #g3>0 and Duel.SelectYesNo(tp,aux.Stringid(26051006,2))) then return end
		else return end
	end
	if p3 and #g3>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc3=g3:Select(tp,1,1,nil):GetFirst()
		if tc3 then
			Duel.SendtoGrave(tc3,REASON_EFFECT)
			g4:Remove(Card.IsCode,nil,tc3:GetCode())
			Duel.RegisterFlagEffect(tp,26051206,RESET_PHASE+PHASE_END,0,1)
			if not (p4 and #g4>0 and Duel.SelectYesNo(tp,aux.Stringid(26051006,3))) then return end
		else return end
	end
	if p4 and #g4>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc4=g4:Select(tp,1,1,nil):GetFirst()
		if tc4 then
			Duel.Summon(tp,tc4,true,nil)
			Duel.RegisterFlagEffect(tp,26051306,RESET_PHASE+PHASE_END,0,1)
		end
	end
end