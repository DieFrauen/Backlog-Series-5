--SNI-Pyre Ace - Mauser
function c26054006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26054006.spcon)
	e1:SetOperation(c26054006.spop)
	c:RegisterEffect(e1)
	--summon eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054006,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,26054006)
	e2:SetTarget(c26054006.tgtg)
	e2:SetOperation(c26054006.tgop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2c)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26054006,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c26054006.discon1)
	e3:SetTarget(c26054006.distg)
	e3:SetOperation(c26054006.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O|EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(26054006,3))
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(c26054006.discon2)
	e5:SetCost(c26054006.xyzcost)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(26054006,3))
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCost(c26054006.xyzcost)
	c:RegisterEffect(e6)
	--Register a flag on monster that gets targeted
	aux.GlobalCheck(c26054006,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c26054006.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
c26054006.listed_names={26054003}
c26054006.listed_series={0x654,0x1654}
function c26054006.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if tc:GetFlagEffect(26054006)==0 then
		tc:RegisterFlagEffect(26054006,RESETS_STANDARD_PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26054006,3)) end
	end
end
function c26054006.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(Card.IsSetCard,c:GetControler(),LOCATION_HAND,0,1,c,0x654)
end
function c26054006.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,c,0x654)
	Duel.SendtoGrave(g,REASON_DISCARD|REASON_COST)
end
function c26054006.tgfilter(c)
	return c:IsSetCard(0x654) and c:IsAbleToGrave()
end
function c26054006.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26054006.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26054006.lvfilter(c,g)
	return g:IsExists(Card.IsLevel,1,nil,c:GetLevel())
end
function c26054006.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26054006.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		local tc=Duel.GetOperatedGroup():GetFirst()
		if not tc:IsMonster() then return end
		local code=tc:GetOriginalCode()
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(lv)
		e2:SetLabelObject(e1)
		e2:SetReset(RESETS_STANDARD_PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c26054006.discon1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	if e:GetType()&EFFECT_TYPE_XMATERIAL ~=0 and not e:GetHandler():IsSetCard(0x654) then return false end
	return #g>0 and rp~=tp
end
function c26054006.discon2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetType()&EFFECT_TYPE_XMATERIAL ~=0 and not e:GetHandler():IsSetCard(0x654) then return false end
	return Duel.GetAttackTarget()
end
function c26054006.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c26054006.disfilter(c,e,tp)
	return c:IsFaceup() and c:IsNegatable() and c:GetFlagEffect(26054006)>0
	and c:IsCanBeEffectTarget(e) or Duel.IsPlayerAffectedByEffect(tp,26054009)
end
function c26054006.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local LOC = LOCATION_ONFIELD
	if chkc then return chkc:IsLocation(LOC) and c26054006.disfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingMatchingCard(c26054006.disfilter,tp,LOC,LOC,1,c,e,tp) and c26054006.ovg(e,c,tp,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local tc=Duel.SelectMatchingCard(tp,c26054006.disfilter,tp,LOC,LOC,1,1,c,e,tp)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,tp,0)
end
function c26054006.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c26054006.ovg(e,c,tp,0) then return end
	if tc:IsRelateToEffect(e) and c26054006.ovg(e,c,tp,1) and tc:IsNegatable() and tc:IsCanBeDisabledByEffect(e) then
		--Negate its effects
		tc:NegateEffects(e:GetHandler())
	end
end
function c26054006.ovg(e,c,tp,chk)
	local ov1=c:GetOverlayGroup()
	local ov2=Duel.GetOverlayGroup(tp,1,0)
	if not Duel.IsPlayerAffectedByEffect(tp,26054011) then
		ov2=ov2:Filter(Card.IsCode,nil,26054003)
	end
	ov1:Merge(ov2)
	if Duel.IsPlayerAffectedByEffect(tp,26054015) then
		local ov3=Duel.GetMatchingGroup(c26054015.ammo,tp,LOCATION_HAND,0,nil)
		ov1:Merge(ov3)
	end
	if chk==0 then
		return #ov1>0
	end
	if chk==1 then
		local dc=ov1:Select(tp,1,1,nil):GetFirst()
		if dc:IsLocation(LOCATION_OVERLAY) then
			return Duel.SendtoGrave(dc,REASON_EFFECT+REASON_XYZ)>0
		end
		if dc:IsLocation(LOCATION_HAND) then
			return Duel.SendtoGrave(dc,REASON_EFFECT+REASON_DISCARD)>0
		end
		return false
	end
end