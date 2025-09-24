--Elegiac Crescendo
function c26053012.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053012,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26053012,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c26053012.cost)
	e1:SetTarget(c26053012.target)
	e1:SetOperation(c26053012.activate)
	c:RegisterEffect(e1)
end
c26053012.listed_series={0x653,0x1653,0x2653}
function c26053012.extrafilter(c)
	return c:IsFaceup() and c:HasLevel()
	and c:IsAbleToGrave() and c:GetFlagEffect(26053012)>0
end
function c26053012.extramat(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(c26053012.extrafilter,tp,0,LOCATION_MZONE,nil)
end
function c26053012.filter(c)
	return c:IsMonster() and c:IsSetCard(0x2653) and c:IsAbleToHand()
end
function c26053012.filter2(c,e,tp)
	local g=Duel.GetMatchingGroup(c26053012.filter3,tp,LOCATION_DECK,0,nil,c)
	return c:IsMonster() and c:IsSetCard(0x2653) and not c:IsPublic()
	and aux.SelectUnselectGroup(g,e,tp,3,3,aux.dpcheck(Card.GetLevel),0)
end
function c26053012.filter3(c,tc)
	local tab=tc.ELEGIAC
	if not tab then return false end
	for i=1,5 do
		if c:GetLevel()==tab[i] then return c:IsAbleToHand() end
	end
	return false
end
function c26053012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26053012.filter2,tp,LOCATION_HAND,0,nil,e,tp)
	if chk==0 then
		if #g>0 then e:SetLabel(1)
		else e:SetLabel(0) end
		return true
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26053012,1)) then
		local tc=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		tc:KeepAlive()
		e:SetLabelObject(tc)
		Duel.SetTargetCard(tc)
		tc:GetFirst():CreateEffectRelation(e)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetTarget(c26053012.target2)
		e:SetOperation(c26053012.activate2)
	else
		e:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH|CATEGORY_TOGRAVE|CATEGORY_SPECIAL_SUMMON)
		e:SetTarget(c26053012.target)
		e:SetOperation(c26053012.activate)
	end
end
function c26053012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		e:GetLabel()==1 or Duel.IsExistingMatchingCard(c26053012.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26053012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26053012.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26053012.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x1653)
	and sg:GetClassCount(Card.GetLevel)==#sg
end
function c26053012.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26053012.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetFirst()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26053012.filter3,tp,LOCATION_DECK,0,nil,tc)
	if #g>0 then
		local dg=aux.SelectUnselectGroup(g,e,tp,3,5,c26053008.rescon,1,tp,HINTMSG_SELECT)
		local dc=dg:FilterCount(Card.IsSetCard,nil,0x1653)
		local g1=dg:Filter(Card.IsAbleToHand,nil)
		local g2=dg:Filter(Card.IsAbleToGrave,nil)
		local b1= dc>0 and #g1>0
		local b2= dc>1 and #g2>0
		local b3= dc>2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and dg:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false)
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(26053012,2)},
			{b2,aux.Stringid(26053012,3)},
			{b3,aux.Stringid(26053012,4)})
		Duel.ConfirmCards(1-tp,tc)
		Duel.ConfirmCards(1-tp,dg)
		if op==1 then
			local gc=g2:Select(tp,1,dc,nil)
			Duel.SendtoGrave(gc,REASON_EFFECT)
		end
		if op==2 then
			local hc=g1:Select(tp,1,1,nil)
			Duel.SendtoHand(hc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hc)
		end
		if op==3 then
			Duel.ShuffleDeck(tp)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local spc=dg:Select(1-tp,1,1,nil):GetFirst()
			if spc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
				Duel.SpecialSummon(spc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.ConfirmCards(1-tp,spc)
				Duel.ShuffleDeck(tp)
			end
		end
	end
end