--Book of Nomencreation
function c26052012.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26052012,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c26052012.activate)
	c:RegisterEffect(e1)
	--use tributes from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052012,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(26052012)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c26052012.condition)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	c:RegisterEffect(e3)
end
function c26052012.filter1(c,tp)
	return c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(c26052012.filter2,tp,LOCATION_DECK,0,1,nil,tp,c)
end
function c26052012.filter2(c,tp,fc)
	local mt=fc.material
	local rc=fc.RACES 
	return c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
	and ((fc:IsSetCard(0x652) and rc and c:IsRace(rc))
	or  (mt and c:IsCode(table.unpack(mt))))
	and Duel.IsExistingMatchingCard(c26052012.filter3,tp,LOCATION_HAND,0,1,nil,tp,c,fc)
end
function c26052012.filter3(c,tp,dc,fc)
	local mt=fc.material
	local rc=fc.RACES 
	return c:IsType(TYPE_NORMAL) and not c:IsPublic() 
	and ((fc:IsSetCard(0x652) and rc and c:IsRace(rc))
	or  (mt and c:IsCode(table.unpack(mt))))
	and not c:IsRace(dc:GetRace()) 
end
function c26052012.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local xg=Duel.GetMatchingGroup(c26052012.filter1,tp,LOCATION_EXTRA,0,nil,tp)
	if #xg>0 and Duel.SelectYesNo(tp,aux.Stringid(26052012,0)) then
		local dc,tc,hc=xg:GetFirst(),nil,nil
		while dc do
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26052012,3))
			dc=xg:Select(tp,0,1,nil):GetFirst()
			if dc then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				tc=Duel.SelectMatchingCard(tp,c26052012.filter2,tp,LOCATION_DECK,0,0,1,nil,tp,dc):GetFirst()
				if tc then 
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
					hc=Duel.SelectMatchingCard(tp,c26052012.filter3,tp,LOCATION_HAND,0,1,1,nil,tp,tc,dc):GetFirst()
					if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
						Duel.ConfirmCards(1-tp,dc)
						Duel.ConfirmCards(1-tp,Group.FromCards(tc,hc))
						Duel.ShuffleHand(tp)
						return
					end
				end
			tc,hc=nil
			end
		end
	end
end
function c26052012.condition(e)
	return e:GetHandler():GetFlagEffect(26052012)==0
end
function c26052012.costfilter(c,e,tp)
	local RC =e:GetHandler().RACES 
	return c:IsMonster() and c:IsReleasable()
	and (RC and RC &c:GetRace()~=0 or c:IsType(TYPE_NORMAL))
	and not Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,c:GetRace())
end
function c26052012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local g=Duel.IsExistingMatchingCard(c26052012.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		return g:GetClassCount(Card.GetRace)>=3
	end
	local g=Duel.GetMatchingGroup(c26052012.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	local tg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.dpcheck(Card.GetRace),1,tp,HINTMSG_TODECK)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c26052012.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKTOP,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK|LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end