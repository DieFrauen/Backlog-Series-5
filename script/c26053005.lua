--Elegiac Falsetto
function c26053005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053005,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(0)
	e1:SetCountLimit(1,26053005)
	e1:SetCondition(c26053005.spcon1)
	e1:SetTarget(c26053005.sptg)
	e1:SetOperation(c26053005.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetLabel(1)
	e2:SetCondition(c26053005.spcon2)
	c:RegisterEffect(e2)
	--tribute your cards because youre bored lol
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053002,1))
	e2:SetCategory(CATEGORY_RELEASE|CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c26053005.tgtg)
	e2:SetOperation(c26053005.tgop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2c)
end
function c26053005.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE|LOCATION_GRAVE) and tc:IsFaceup()
		and tc:IsSetCard(0x653)
end
function c26053005.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsTurnPlayer(tp) then return false end
	local tc=Duel.GetAttackTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and tc:IsSetCard(0x653)
end
function c26053005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local label=e:GetLabel()
	if chk==0 then return  Duel.GetMZoneCount(tp,c)>0 and not c:IsPublic() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (label==0 or (label==1 and not c:IsStatus(STATUS_CHAINING))) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c26053005.spfilter(c,e,tp)
	return c:IsMonster() and c:IsSetCard(0x1653)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26053005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and c:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>2 then ft=2 end
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
		local g=Group.CreateGroup()
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		then g:AddCard(c) else return end
		local t2=Duel.SelectMatchingCard(tp,c26053005.spfilter,tp,LOCATION_HAND,0,0,ft-1,c,e,tp)
		if #t2>0 then g:Merge(t2) end
		Duel.BreakEffect()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26053005.ritcheck(e,tp,g,sc)
	return (Duel.IsPlayerAffectedByEffect(tp,26053011)
	and g:GetSum(Card.GetLevel)==sc:GetLevel()
	or not sc:IsLocation(LOCATION_DECK))
	and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==#g
	and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==0
end
function c26053005.stage2(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	if tc:GetSummonLocation()==LOCATION_DECK and Duel.GetFlagEffect(tp,26053011)==0 then
		Duel.RegisterFlagEffect(tp,26053011,RESET_PHASE|PHASE_END,0,1)
		Duel.Hint(HINT_CARD,tp,26053011)
	end
end
function c26053005.tgfilter(c)
	return c:IsMonster() and c:IsAbleToGrave()
end
function c26053005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053005.thfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE|LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function c26053005.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26053005.tgfilter,tp,LOCATION_MZONE|LOCATION_HAND,0,1,99,nil)
	local rparams={lvtype=RITPROC_GREATER,
		filter=aux.FilterBoolFunction(Card.IsSetCard,0x2653),
		location=LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK,
		stage2=c26053005.stage2,
		forcedselection=c26053005.ritcheck}
	local rtg,rop=
	Ritual.Target(rparams),
	Ritual.Operation(rparams)
	local b1=#g>0
	local b2=rtg(e,tp,eg,ep,ev,re,r,rp,0)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26053005,1))
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26053005,2)},
		{b2,aux.Stringid(26053005,3)})
	if op==1 then
		local tc=g:Select(tp,1,#g,nil)
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	if op==2 then
		rop(e,tp,eg,ep,ev,re,r,rp)
	end
end