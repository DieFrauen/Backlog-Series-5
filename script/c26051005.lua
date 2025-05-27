--Guldengeist - The Pentagram
function c26051005.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsSetCard,0x651),1,1,c26051005.exmatfilter)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26051005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,26051005)
	e1:SetCondition(function(e)
		return e:GetHandler():IsSynchroSummoned() end)
	e1:SetTarget(c26051005.sptg)
	e1:SetOperation(c26051005.spop)
	c:RegisterEffect(e1)
	--return to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26051005,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,{26051005,1})
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetTarget(c26051005.txtg)
	e2:SetOperation(c26051005.txop)
	c:RegisterEffect(e2)
end
c26051005.listed_series={0x651}
function c26051005.exmatfilter(c,scard,sumtype,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_SYNCHRO,scard,sumtype,tp) and (lv==2 or lv==3)
end
function c26051005.spfilter(c)
	return c:GetLevel()==1
end
function c26051005.s1filter(c,e,tp,sg)
	loc=c:GetLocation()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	and sg:FilterCount(Card.IsLocation,c,loc)==0
end
function c26051005.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==5
	and sg:GetClassCount(Card.GetLocation)==3
	and sg:IsExists(c26051005.s1filter,1,nil,e,tp,sg)
end
function c26051005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK 
	local g=Duel.GetMatchingGroup(c26051005.spfilter,tp,loc,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,5,5,c26051005.rescon,0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,loc)
end
function c26051005.spop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK 
	local g=Duel.GetMatchingGroup(c26051005.spfilter,tp,loc,0,nil)
	if g:GetClassCount(Card.GetCode)<4 then return end
	local sg=aux.SelectUnselectGroup(g,e,tp,5,5,c26051005.rescon,1,tp,HINTMSG_CONFIRM,c26051005.rescon)
	local hg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	Duel.ConfirmCards(1-tp,hg)
	local gg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.HintSelection(gg)
	local dg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	Duel.ConfirmCards(1-tp,dg)
	local spg=Group.CreateGroup()
	if #hg==1 then spg:Merge(hg) end
	if #gg==1 then spg:Merge(gg) end
	if #dg==1 then spg:Merge(dg) end
	Duel.ShuffleHand(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
	then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local spg=spg:FilterSelect(tp,aux.NecroValleyFilter,1,2,nil)
	if #spg>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c26051005.txfilter(c)
	return c:IsFaceup() and c:IsAbleToExtra()
	--and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c26051005.txtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26051005.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c26051005.txfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c26051005.mgfilter(c,e,tp,tc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
	and (c:GetReason()&(REASON_MATERIAL))==REASON_MATERIAL 
	and (c:GetReason()&(REASON_FUSION|REASON_SYNCHRO|REASON_XYZ|REASON_LINK))~=0
	and c:GetReasonCard()==tc
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26051005.txop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c26051005.txfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	local mg=tc:GetMaterial()
	local ovg=tc:GetOverlayGroup()
	if tc:IsType(TYPE_XYZ) then mg:Merge(ovg) end
	local sumtype=tc:GetSummonType()
	mg=mg:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	local ct=#mg
	if Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)>0
	and (sumtype&SUMMON_TYPE_LINK+SUMMON_TYPE_XYZ+SUMMON_TYPE_FUSION+SUMMON_TYPE_SYNCHRO)~=0
	and #mg>0
	and ct>0
	and tc:IsLocation(LOCATION_EXTRA)
	then
		local p=tc:GetControler()
		local ft=Duel.GetLocationCount(p,LOCATION_MZONE)
		if Duel.IsPlayerAffectedByEffect(p,CARD_BLUEEYES_SPIRIT)
		then ft=1 end
		if ft>0 and mg:IsExists(aux.NecroValleyFilter(c26051005.mgfilter),1,nil,e,p,tc)
		and Duel.SelectYesNo(p,aux.Stringid(26051005,4)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local sg=mg:FilterSelect(p,c26051005.mgfilter,1,ft,nil,e,p,tc)
			if #sg>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEUP)
			end
		end
	end
end