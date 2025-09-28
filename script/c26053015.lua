--Elegiac Pianissimo
function c26053015.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE|TIMING_MAIN_END,TIMING_MAIN_END|TIMING_BATTLE_START)
	c:RegisterEffect(e1)
	--Pianissimo
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(26053015)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	--c:RegisterEffect(e2)
	--reduce level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26053015,0))
	e3:SetCategory(CATEGORY_LVCHANGE+CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26053015.lvtg)
	e3:SetOperation(c26053015.lvop)
	c:RegisterEffect(e3)
	--return to deck/tokens/Ritual Summon
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(26053015,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TOKEN|CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(TIMING_MAIN_END,TIMING_BATTLE_START,TIMING_MAIN_END)
	e4:SetCost(c26053015.tdcost)
	e4:SetCondition(c26053015.tdcon)
	e4:SetTarget(c26053015.tdtg)
	e4:SetOperation(c26053015.tdop)
	c:RegisterEffect(e4)
end
function c26053015.dwfilter(c,num,lv1,lv2,lv3,lv4,lv5)
	local tp=c:GetControler()
	if lv1 and lv1>0 and c:IsLevelBelow(lv1-num) then return false end
	if lv2 and lv2>0 and c:GetLevel()==(lv2-num) then return false end
	if lv3 and lv3>0 and c:GetLevel()==(lv3-num) then return false end
	if lv4 and lv4>0 and c:GetLevel()==(lv4-num) then return false end
	if lv5 and lv5>0 and c:IsLevelAbove(lv5-num) then return false end
	return true
end
function c26053015.lvfilter(c)
	return c:IsMonster() and (c:IsOnField()
	or c:IsSetCard(0x653) --and not c:IsPublic()
	)
end
function c26053015.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE 
	local lab=e:GetLabel()
	local c=e:GetHandler()
	if chkc then return c26053015.lvfilter(e,tp,0) and chkc:IsLocation(loc) end
	if chk==0 then return c:GetFlagEffect(26053015)==0 and Duel.IsExistingMatchingCard(c26053015.lvfilter,tp,loc+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,c26053015.lvfilter,tp,loc+LOCATION_HAND,loc,1,1,nil):GetFirst()
	Duel.SetTargetCard(tc)
	if tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc) end
	c:RegisterFlagEffect(26053015,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26053015.piano(c)
	return c:IsFaceup() and c:IsCode(26053015)
end
function c26053015.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local lv={1}
		local piano=Duel.GetMatchingGroupCount(c26053015.piano,tp,LOCATION_ONFIELD,0,nil)
		for vl=1,piano do
			if tc:GetLevel()-piano>0 then
			lv[vl]=vl end
		end
		local ct=Duel.AnnounceNumber(tp,table.unpack(lv))
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			--tc:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT|(RESETS_STANDARD_PHASE_END&~RESET_TOFIELD))
		e2:SetValue(-ct)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(ct*-100)
		tc:RegisterEffect(e3)
	end
end
function c26053015.rfilter(c,e,tp,g,ct)
	if not c:IsSetCard(0x2653) or c:IsPublic()
	or not c.ELEGIAC then return false end 
	return g:IsExists(c26053015.tab,ct,nil,c)
	and (g:IsExists(c26053015.tkfilter,ct,nil,e,tp) or not ct~=2)
end
function c26053015.tab(c,tc)
	local tab=tc.ELEGIAC
	for i=1,5 do
		if tab[i] and c:GetLevel()==tab[i]
		then return true end
	end
	return false
end
function c26053015.tkfilter(c,e,tp)
	return c:IsMonster() and c:HasLevel() and c:IsAbleToDeck()
	and Duel.IsPlayerCanSpecialSummonMonster(tp,26053101,0x1653,TYPES_TOKEN,0,2450,c:GetLevel(),RACE_PSYCHIC,ATTRIBUTE_WATER,POS_FACEUP,tp)
end
function c26053015.tdfilter(c,e,tp)
	return c:IsMonster() and c:HasLevel() and c:IsAbleToDeck()
end
function c26053015.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,2,nil,0x1653)
	--and sg:GetClassCount(Card.GetLevel)==#sg
end
function c26053015.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsStatus(STATUS_EFFECT_ENABLED) end
	Duel.SendtoGrave(c,REASON_COST)
end
function c26053015.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() or Duel.IsBattlePhase()
end
function c26053015.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26053015.tkfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26053015.rfilter,tp,LOCATION_HAND,0,1,nil,e,tp,g,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c26053015.tdop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26053015.tkfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	local rparams={lvtype=RITPROC_EQUAL,
			filter=aux.FilterBoolFunction(Card.IsSetCard,0x2653),
			location=LOCATION_HAND,
			extrafil=c26053015.extramat,
			extraop=c26053015.extraop,
			forcedselection=c26053015.ritcheck}
	local rtg,rop=Ritual.Target(rparams),Ritual.Operation(rparams)
	local b1=Duel.IsExistingMatchingCard(c26053015.rfilter,tp,LOCATION_HAND,0,1,nil,e,tp,g,1)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c26053015.rfilter,tp,LOCATION_HAND,0,1,nil,e,tp,g,2) 
	local b3=rtg(e,tp,eg,ep,ev,re,r,rp,0)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26053015,2))
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26053015,3)},
		{b2,aux.Stringid(26053015,4)},
		{b3,aux.Stringid(26053015,5)})
	if op==1 then c26053015.noeffectlol(e,tp,g) end
	if op==2 then c26053015.tkop(e,tp,g) end
	if op==3 then rop(e,tp,eg,ep,ev,re,r,rp) end
end
function c26053015.noeffectlol(e,tp,g)
	local tc=Duel.SelectMatchingCard(tp,c26053015.rfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,g,1)
	if #tc>0 then 
		tc=tc:GetFirst()
		local sg=g:FilterSelect(tp,c26053015.tab,1,1,nil,tc)
		Duel.ConfirmCards(1-tp,tc)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_RULE)
	end
end
function c26053015.tkop(e,tp,g)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>3 then ft=3 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local tc=Duel.SelectMatchingCard(tp,c26053015.rfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,g,2)
	if #tc>0 then 
		tc=tc:GetFirst()
		local tg=g:Filter(c26053015.tab,nil,tc)
		local sg=aux.SelectUnselectGroup(tg,e,tp,2,2,aux.dpcheck(Card.GetLevel),1,tp,HINTMSG_SPSUMMON)
		local tkg=Group.CreateGroup()
		local ec=sg:GetFirst()
		while ec do
			local code=26053106
			local c=e:GetHandler()
			local lv=ec:GetLevel()
			if lv<12 then code=26053100+lv end
			local token=Duel.CreateToken(tp,code)
			c:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
			tkg:AddCard(token)
			ec=sg:GetNext()
		end
		Duel.ConfirmCards(1-tp,tc)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tkg=tkg:Select(tp,1,ft,nil)
		Duel.SpecialSummon(tkg,0,tp,tp,false,false,POS_FACEUP)
		--Send them to the GY during the End Phase
		aux.DelayedOperation(tkg,PHASE_END,26053015,e,tp,
			function(dg) Duel.Destroy(dg,REASON_EFFECT) end,
			nil,0,1,aux.Stringid(26053015,5)
		)
	end
end
function c26053015.extramat(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(c26053015.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
end
function c26053015.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	Duel.ConfirmCards(1-tp,tc)
	Duel.HintSelection(mat)
	Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function c26053015.three(c,g)
	return g:IsContains(c)
end
function c26053015.ritcheck(e,tp,g,sc)
	return #g==3 --and g:IsExists(Card.IsSetCard,2,nil,0x1653)
	and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==#g
end