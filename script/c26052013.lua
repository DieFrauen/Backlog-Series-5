--Nomencreator's Study
function c26052013.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26052013,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26052013.target)
	e1:SetOperation(c26052013.activate)
	c:RegisterEffect(e1)
	--draw and return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052013,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CUSTOM+26052013)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(function() return not Duel.IsPhase(PHASE_DAMAGE) end)
	e2:SetTarget(c26052013.drtg)
	e2:SetOperation(c26052013.drop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--to grave register
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetLabelObject(e2)
	e3:SetOperation(c26052013.regop)
	c:RegisterEffect(e3)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION))
	c:RegisterEffect(e4)
end
function c26052013.filter1(c,e,tp)
	local mg=Duel.GetMatchingGroup(c26052013.filter2,tp,LOCATION_DECK,0,nil,c)
	return c:IsType(TYPE_FUSION) and aux.SelectUnselectGroup(mg,e,tp,1,4,c26052013.rescon1,0)
end
function c26052013.rescon1(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetRace)==#sg and Duel.IsPlayerCanDraw(tp,#sg)
end
function c26052013.filter2(c,fc)
	local mt=fc.material
	rc=fc.RACES
	if c:IsForbidden() or not c:IsAbleToGrave() then return false end
	return c:IsType(TYPE_NORMAL) and
	(mt and c:IsCode(table.unpack(mt)) or
	(fc:IsSetCard(0x652) and rc and c:IsRace(rc)))
end
function c26052013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26052013.filter1,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then return g:GetClassCount(Card.GetCode)>2 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK|LOCATION_HAND)
end
function c26052013.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26052013.filter1,tp,LOCATION_EXTRA,0,nil,e,tp)
	local cg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.dncheck,1,tp,HINTMSG_CONFIRM)
	if #cg<3 then return end
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELECT)
	local cc=cg:Select(1-tp,1,1,nil):GetFirst()
	Duel.ConfirmCards(tp,cc)
	local mg=Duel.GetMatchingGroup(c26052013.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,cc)
	local sg=aux.SelectUnselectGroup(mg,e,tp,1,4,c26052013.rescon1,1,tp,HINTMSG_TOGRAVE,c26052013.rescon1)
	if #sg>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c26052013.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPhase(PHASE_DAMAGE) then return end
	local og=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	og:Sub(eg)
	local tg=eg:Filter(c26052013.regfilter,nil,e,tp,og)
	if #tg>0 then
		for tc in tg:Iter() do
			tc:RegisterFlagEffect(26052013,RESET_CHAIN,0,1)
		end
		local g=e:GetLabelObject():GetLabelObject()
		if Duel.GetCurrentChain()==0 then g:Clear() end
		g:Merge(tg)
		g:Remove(function(c) return c:GetFlagEffect(26052013)==0 end,nil)
		e:GetLabelObject():SetLabelObject(g)
		if Duel.GetFlagEffect(tp,26052013)==0 then
			Duel.RegisterFlagEffect(tp,26052013,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+26052013,e,0,tp,tp,0)
		end
	end
end
function c26052013.regfilter(c,e,tp,og)
	return c:IsType(TYPE_NORMAL) and c:IsMonster()
	and not og:IsExists(Card.IsRace,1,nil,c:GetRace())
end
function c26052013.drfilter(c,tp)
	return c:GetType()&0x11==0x11 
	and c:IsControler(tp)
	and not Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c,c:GetRace())
	and c:GetFlagEffect(26052013)==0
end
function c26052013.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26052013.drfilter,1,nil,tp)
end
function c26052013.rescon2(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetRace)==#sg and
	Duel.IsPlayerCanDraw(tp,#sg)
end
function c26052013.drfilter(c,e,g)
	return g:IsContains(c) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeEffectTarget(e)
end
function c26052013.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject()
	local tg=Duel.GetMatchingGroup(c26052013.drfilter,tp,LOCATION_GRAVE,0,nil,e,g)
	if chkc then return tg:IsContains(chkc) end
	if chk==0 then return
	aux.SelectUnselectGroup(tg,e,tp,1,1,c26052013.rescon2,0) end
	local sg=aux.SelectUnselectGroup(tg,e,tp,1,#tg,c26052013.rescon2,1,tp,HINTMSG_RELEASE,c26052013.rescon2)
	Duel.SetTargetCard(sg)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,#g,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,#g,tp,LOCATION_HAND)
end
function c26052013.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,g=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_CARDS)
	g=g:FilterCount(Card.IsRelateToEffect,nil,e)
	if g>0 then
		Duel.Draw(p,g,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		local ct=1; if g>1 then ct=g-1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,ct,ct,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
end
