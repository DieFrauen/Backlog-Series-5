--Guldengeist Ratio
function c26051007.initial_effect(c)
	c:SetUniqueOnField(1,0,26051007)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c26051007.immval)
	--c:RegisterEffect(e1)
	--shuffle copy back to Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26051007,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c26051007.tdtg)
	e2:SetOperation(c26051007.tdop)
	--c:RegisterEffect(e2)
	--Synchro Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26051007,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_BATTLE_START|TIMING_BATTLE_END)
	e3:SetCondition(c26051007.sccon)
	e3:SetTarget(c26051007.sctg)
	e3:SetOperation(c26051007.scop)
	--c:RegisterEffect(e3)
	--resummon Synchro material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26051007,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(function(e)
		local c=e:GetHandler()
		return c:IsSynchroSummoned() and c:IsStatus(STATUS_SPSUMMON_TURN) end)
	e4:SetTarget(c26051007.sptg)
	e4:SetOperation(c26051007.spop)
	--c:RegisterEffect(e4)
	--grant effects
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c26051007.eftg)
	e5:SetLabelObject(e5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetLabelObject(e2)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetLabelObject(e3)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetLabelObject(e4)
	c:RegisterEffect(e8)
	Duel.AddCustomActivityCounter(26051007,ACTIVITY_CHAIN,c26051007.chainfilter)
end
function c26051007.chainfilter(re,tp,cid)
	if re:IsMonsterEffect() and re:GetHandler():IsSetCard(0x651) then
		re:GetHandler():RegisterFlagEffect(26051000,RESETS_STANDARD_PHASE_END,0,1)
		return false
	end
end
function c26051007.eftg(e,c)
	return c:IsType(TYPE_EFFECT)
	and (c:GetLevel()==1 or c:IsType(TYPE_SYNCHRO)
	and c:GetCounter(0x1100)==c:GetLevel())
	and c:GetFlagEffect(26051000)==0
end
function c26051007.immval(e,te)
	local c=e:GetHandler()
	if not (re:IsActivated() and e:GetOwnerPlayer()==1-re:GetOwnerPlayer()) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c)
end
function c26051007.tdfilter(c,code)
	return c:IsCode(code) and c:IsAbleToDeck()
end
function c26051007.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local code=e:GetHandler():GetCode()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26051007.tdfilter(chkc,code) end
	if chk==0 then return Duel.IsExistingTarget(c26051007.tdfilter,tp,LOCATION_GRAVE,0,1,nil,code) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26051007.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,code)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c26051007.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c26051007.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function c26051007.mfilter(c)
	return c:IsFaceup() and (c:GetLevel()==1 or c:IsType(TYPE_SYNCHRO))
end
function c26051007.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c26051007.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26051007.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c26051007.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
function c26051007.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and not c:IsType(TYPE_TUNER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c26051007.ratio(c)
	return c:IsFaceup() and c:IsCode(26051007) and c:IsAbleToGrave()
end
function c26051007.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=e:GetHandler():GetMaterial()
	--if mg:IsExists(Card.IsType,1,nil,TYPE_TUNER) then mg:Clear() end
	if chkc then return mg:IsContains(chkc) and c26051007.spfilter(chkc,e,tp) end 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and #mg>0 and Duel.IsExistingMatchingCard(c26051007.ratio,tp,LOCATION_ONFIELD,0,1,nil)
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=mg:Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
end
function c26051007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.SelectMatchingCard(tp,c26051007.ratio,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoGrave(rc,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end