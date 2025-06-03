--Dissertation: on Nomencreatures
function c26052015.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	c:RegisterEffect(e1)
	--send from deck to gy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052015,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_CUSTOM+26052015)
	e2:SetCountLimit(1,26052015,EFFECT_COUNT_CODE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c26052015.tgtg)
	e2:SetOperation(c26052015.tgop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--to grave register
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(e3)
	e3:SetOperation(c26052015.regop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Fusion.CreateSummonEff({handler=c,
			desc=aux.Stringid(26052015,1),
			extrafil=c26052015.fextra,
			extratg=c26052015.extratg,
			matfilter=aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL+TYPE_FUSION),
			extraop=Fusion.ShuffleMaterial,
			stage2=c26052015.stage2})
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(0,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,26052015,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(function() return Duel.IsMainPhase() or Duel.IsBattlePhase() end)
	c:RegisterEffect(e4)
end
function c26052015.hfilter(c)
	return not c:IsPublic()
end
function c26052015.rescon(sg,e,tp,mg)
	return (#sg==1 and sg:IsExists(Card.IsCode,1,nil,26052001))
	or (sg:GetClassCount(Card.GetRace)==3
	and sg:FilterCount(Card.IsType,nil,TYPE_NORMAL)==#sg)
end
function c26052015.hcond(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c26052015.hfilter,tp,LOCATION_HAND,0,nil)
	return aux.SelectUnselectGroup(g,e,tp,1,3,c26052015.rescon,0)
end
function c26052015.costchk(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26052015.hfilter,tp,LOCATION_HAND,0,nil)
	local lob=e:GetLabelObject()
	if chk==0 then lob:SetLabel(0) return true end
	if lob:GetLabel()>0 then
		lob:SetLabel(0)
		local tg=aux.SelectUnselectGroup(g,e,tp,1,3,c26052015.rescon,1,tp,HINTMSG_CONFIRM,c26052015.rescon)
		Duel.ConfirmCards(1-tp,tg)
		Duel.ShuffleHand(tp)
	end
end
function c26052015.regop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c26052015.regfilter,nil,e,tp)
	if #tg>0 then
		for tc in tg:Iter() do
			tc:RegisterFlagEffect(26052015,RESET_CHAIN,0,1)
		end
		local g=e:GetLabelObject():GetLabelObject()
		if Duel.GetCurrentChain()==0 then g:Clear() end
		g:Merge(tg)
		g:Remove(function(c) return c:GetFlagEffect(26052015)==0 end,nil)
		e:GetLabelObject():SetLabelObject(g)
		if Duel.GetFlagEffect(tp,26052015)==0 then
			Duel.RegisterFlagEffect(tp,26052015,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+26052015,e,0,tp,tp,0)
		end
	end
end
function c26052015.regfilter(c,e,tp)
	return c:IsMonster() and c:IsType(TYPE_EFFECT)
end
function c26052015.filter1(c,e,tp)
	return Duel.IsExistingMatchingCard(c26052015.filter2,tp,LOCATION_DECK,0,1,nil,c:GetRace())
end
function c26052015.rescon2(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetRace)==#sg 
end
function c26052015.filter2(c,rc)
	if c:IsForbidden() or not c:IsAbleToGrave() then return false end
	return c:IsType(TYPE_NORMAL) and c:IsRace(rc)
end
function c26052015.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	local tg=Duel.GetMatchingGroup(c26052015.filter1,tp,0,LOCATION_GRAVE,nil,e,tp)
	if chkc then return tg:IsContains(chkc) end
	if chk==0 then return --true end
	aux.SelectUnselectGroup(tg,e,tp,1,1,c26052015.rescon2,0) end
	local sg=aux.SelectUnselectGroup(tg,e,tp,1,#tg,c26052015.rescon2,1,tp,HINTMSG_RELEASE,c26052015.rescon2)
	Duel.SetTargetCard(sg)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,#g,tp,LOCATION_DECK)
end
function c26052015.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
	local g=Duel.GetMatchingGroup(c26052015.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tg:GetSum(Card.GetRace))
	local sg=aux.SelectUnselectGroup(g,e,tp,1,#g,c26052015.rescon2,1,tp,HINTMSG_TOGRAVE,c26052015.rescon2)
	if #sg>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c26052015.matfilter(c,e,tp)
	return c:IsAbleToDeck() and c:IsType(TYPE_NORMAL+TYPE_FUSION)
end
function c26052015.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
end
function c26052015.stage2(e,tc,tp,sg,chk)
	if chk==1 then
		--returns to ED
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(26052015,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
		tc:RegisterEffect(e1,true)
	end
end
function c26052015.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26052015)==0 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	c:RegisterFlagEffect(26052015,RESETS_STANDARD_PHASE_END,0,0)
end