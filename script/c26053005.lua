--Elegiac Falsetto
function c26053005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053005,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:SetLabel(0)
	e1:SetCountLimit(1,26053005)
	e1:SetCondition(c26053005.tgcon1)
	e1:SetTarget(c26053005.tgtg)
	e1:SetOperation(c26053005.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetLabel(1)
	e2:SetCondition(c26053005.tgcon2)
	c:RegisterEffect(e2)
end
function c26053005.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE|LOCATION_GRAVE) and tc:IsFaceup()
		and tc:IsSetCard(0x653)
end
function c26053005.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsTurnPlayer(tp) then return false end
	local tc=Duel.GetAttackTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and tc:IsSetCard(0x653)
end
function c26053005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local label=e:GetLabel()
	if chk==0 then return  Duel.GetMZoneCount(tp,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (label==0 or (label==1 and not c:IsStatus(STATUS_CHAINING))) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,c:GetLocation())
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_HAND|LOCATION_GRAVE)
end
function c26053005.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1)
		local b1=tc:IsAbleToHand()
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(26053005,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26053005,2))
			local op=Duel.SelectEffect(tp,
				{b1,aux.Stringid(26053005,3)},
				{b2,aux.Stringid(26053005,4)})
			if op==1 then
				Duel.BreakEffect()
				Duel.SendtoHand(tc,nil,REASON_EFFECT) end
			if op==2 then
				Duel.BreakEffect()
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		local rparams={lvtype=RITPROC_GREATER,
			filter=aux.FilterBoolFunction(Card.IsSetCard,0x2653),
			location=LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK,
			extraop=c26053005.extraop,
			forcedselection=c26053005.ritcheck}
		local rtg,rop=
		Ritual.Target(rparams),
		Ritual.Operation(rparams)
		if rtg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(26053005,5)) then
			Duel.BreakEffect()
			rop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function c26053005.ritcheck(e,tp,g,sc)
	return (Duel.IsPlayerAffectedByEffect(tp,26053011)
	and g:GetSum(Card.GetLevel)==sc:GetLevel()
	or not sc:IsLocation(LOCATION_DECK))
	and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==#g
	and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==0
end
function c26053005.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	if tc:IsLocation(LOCATION_DECK) and Duel.GetFlagEffect(tp,26053011)==0 then
		Duel.RegisterFlagEffect(tp,26053011,RESET_PHASE|PHASE_END,0,1)
		Duel.Hint(HINT_CARD,tp,26053011)
	end
	Duel.ReleaseRitualMaterial(mat)
end