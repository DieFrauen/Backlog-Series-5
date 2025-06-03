--Dissertation: on Nomencreatures
function c26052015.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	--exchange monsters from Deck and GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052015,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26052015)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c26052015.tgtg)
	e2:SetOperation(c26052015.tgop)
	c:RegisterEffect(e2)
	--fusion (target)
	local params = {extrafil=c26052015.fextra,
					matfilter=c26052015.mfilter,
					extratg=c26052015.extratg,
					stage2=c26052015.stage2,
					extraop=Fusion.ShuffleMaterial,}
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26052015,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,26052015)
	e3:SetCondition(function() return Duel.IsMainPhase() or Duel.IsBattlePhase() end)
	e3:SetTarget(Fusion.SummonEffTG(params))
	e3:SetOperation(Fusion.SummonEffOP(params))
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetOperation(c26052015.desop)
	c:RegisterEffect(e4)
	--Can be activated from the hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26052015,2))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e5:SetCondition(c26052015.handcon)
	c:RegisterEffect(e5)
end
function c26052015.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetRace)==#sg
end
function c26052015.regfilter(c,e,tp)
	return c:IsMonster() and c:IsType(TYPE_EFFECT) and c:IsControler(1-tp)
end
function c26052015.filter1(c,e,tp)
	local rc=c:GetRace()
	return c:IsType(TYPE_EFFECT) and c:IsAbleToDeck()
	and rc and Duel.IsExistingMatchingCard(c26052015.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,rc)
end
function c26052015.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetRace)==#sg 
end
function c26052015.filter2(c,rc)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToGrave() and c:IsRace(rc)
end
function c26052015.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(c26052015.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chkc then return c26052015.filter1(chkc,e,tp) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return --true end
	aux.SelectUnselectGroup(tg,e,tp,1,1,c26052015.rescon,0) end
	local sg=aux.SelectUnselectGroup(tg,e,tp,1,3,c26052015.rescon,1,tp,HINTMSG_RELEASE,c26052015.rescon)
	Duel.SetTargetCard(sg)
	Duel.SetTargetPlayer(tp)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,#sg,tp,LOCATION_DECK|LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,sg,#sg,tp,0)
end
function c26052015.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g1:Filter(Card.IsRelateToEffect,nil,e)
	local g2=Duel.GetMatchingGroup(c26052015.filter2,tp,LOCATION_DECK|LOCATION_HAND,0,nil,tg:GetSum(Card.GetRace))
	if tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
	local sg=aux.SelectUnselectGroup(g2,e,tp,1,3,c26052015.rescon2,1,tp,HINTMSG_TOGRAVE,c26052015.rescon2)
	if #sg>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
		sg=Duel.GetOperatedGroup()
		tg=tg:Filter(Card.IsRace,nil,sg:GetSum(Card.GetRace))
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
function c26052015.mfilter(c,e,tp)
	return c:IsAbleToDeck() and c:GetType()&(TYPE_NORMAL|TYPE_FUSION)~=0
end
function c26052015.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
end
function c26052015.stage2(e,tc,tp,sg,chk)
	if chk==1 then
		e:GetHandler():SetCardTarget(tc)
	end
end
function c26052015.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c26052015.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26052015)==0 end
	c:RegisterFlagEffect(26052015,RESET_CHAIN,0,1)
end
function c26052015.desfilter(c,rc)
	return rc:IsHasCardTarget(c)
end
function c26052015.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26052015.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
end
function c26052015.handcon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x4652),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end