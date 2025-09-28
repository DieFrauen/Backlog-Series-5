--Elegiac Diminuendo
function c26053014.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053014,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26053014)
	e1:SetTarget(c26053014.target)
	e1:SetOperation(c26053014.activate)
	c:RegisterEffect(e1)
	--Register a flag on monster that activate effects on the field
	aux.GlobalCheck(c26053014,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c26053014.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
c26053014.listed_series={0x653,0x1653}
function c26053014.thfilter(c)
	return c:IsSetCard(0x653) and c:IsAbleToHand()
end
function c26053014.tffilter(c)
	return c:IsSetCard(0x1653) and c:IsSummonable(true,nil)
end
function c26053014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c26053014.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	local p1=#g1>0 and Duel.GetFieldCard(tp,LOCATION_FZONE,0)==nil
	local g2=Duel.GetMatchingGroup(c26053014.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local p2=#g2>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local p3=Duel.IsExistingMatchingCard(c26053014.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return (p1 or p2 or p3) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c26053014.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26053014.thfilter,tp,LOCATION_GRAVE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(c26053014.tffilter,tp,LOCATION_MZONE|LOCATION_HAND,0,nil,e,tp)
	local rparams={lvtype=RITPROC_EQUAL,
		filter=aux.FilterBoolFunction(Card.IsSetCard,0x2653),
		location=LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK,
		matfilter=aux.FilterBoolFunction(Card.IsSetCard,0x1653),
		extrafil=c26053014.extramat,
		extraop=c26053014.extraop,
		stage2=c26053014.stage2,
		forcedselection=c26053014.ritcheck}
	local rtg,rop=
	Ritual.Target(rparams),
	Ritual.Operation(rparams)
	local b1,b2,b3=
	#g1>0,
	rtg(e,tp,eg,ep,ev,re,r,rp,0),
	#g2>0
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(26053014,0))
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26053014,1)},
		{b2,aux.Stringid(26053014,2)},
		{b3,aux.Stringid(26053014,3)})
	if op==1 then
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if tc:IsSummonable(true,nil) then
			g2:AddCard(tc); b3=#g2>0
		end
		if Duel.SelectYesNo(tp,aux.Stringid(26053014,4)) then
			op=Duel.SelectEffect(tp,{false,nil},
			{b2,aux.Stringid(26053014,2)},
			{b3,aux.Stringid(26053014,3)})
		else return end
	end
	if op==2 then
		Duel.BreakEffect()
		rop(e,tp,eg,ep,ev,re,r,rp)
		g2=Duel.GetMatchingGroup(c26053014.tffilter,tp,LOCATION_MZONE|LOCATION_HAND,0,nil,e,tp)
		b3=#g2>0
		if b3 and Duel.SelectYesNo(tp,aux.Stringid(26053014,3))
		then op=3 end
	end
	if op==3 then 
		g2=Duel.GetMatchingGroup(c26053014.tffilter,tp,LOCATION_MZONE|LOCATION_HAND,0,nil,e,tp)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		Duel.BreakEffect()
		Duel.Summon(tp,tc,true,nil)
	end
end
function c26053014.ritcheck(e,tp,g,sc)
	return g:GetClassCount(Card.GetLevel)==#g
	and (Duel.IsPlayerAffectedByEffect(tp,26053011)
	and g:GetSum(Card.GetLevel)==sc:GetLevel()
	and sc:IsSetCard(0x2653)
	or not sc:IsLocation(LOCATION_DECK))
end
function c26053014.extrafilter(c)
	return c:IsFaceup() and c:HasLevel()
	and c:IsAbleToGrave() and c:GetFlagEffect(26053014)>0
end
function c26053014.extramat(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(c26053014.extrafilter,tp,0,LOCATION_MZONE,nil)
end
function c26053014.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	Duel.ConfirmCards(1-tp,tc)
	Duel.ReleaseRitualMaterial(mat)
end
function c26053014.stage2(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	if tc:GetSummonLocation()==LOCATION_DECK and Duel.GetFlagEffect(tp,26053011)==0 then
		Duel.RegisterFlagEffect(tp,26053011,RESET_PHASE|PHASE_END,0,1)
		Duel.Hint(HINT_CARD,tp,26053011)
	end
end
function c26053014.checkop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	if re:IsMonsterEffect() and tc:IsRelateToEffect(re) and loc==LOCATION_MZONE then
		tc:RegisterFlagEffect(26053014,RESETS_STANDARD_PHASE_END,0,1)
	end
end