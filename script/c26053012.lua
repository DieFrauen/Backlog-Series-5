--Elegiac Crescendo
function c26053012.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053012,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,26053012,EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(1)
	e1:SetCost(c26053012.cost)
	e1:SetTarget(c26053012.target1)
	e1:SetOperation(c26053012.activate1)
	c:RegisterEffect(e1)
	--send to GY
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26053012,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetLabel(2)
	e2:SetTarget(c26053012.target2)
	e2:SetOperation(c26053012.activate2)
	c:RegisterEffect(e2)
	--spsummon
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(26053012,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetLabel(3)
	e3:SetTarget(c26053012.target3)
	e3:SetOperation(c26053012.activate3)
	c:RegisterEffect(e3)
	--ritual
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26053012,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(2,26053012,EFFECT_COUNT_CODE_OATH)
	e4:SetTarget(c26053012.target4)
	e4:SetOperation(c26053012.activate4)
	c:RegisterEffect(e4)
	--Register a flag on monster that activate effects on the field
	aux.GlobalCheck(c26053012,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c26053012.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
c26053012.listed_series={0x653,0x1653,0x2653}
function c26053012.rfilter(c,e,tp,lab)
	local g1=Duel.GetMatchingGroup(c26053012.filter1,tp,LOCATION_DECK,0,nil,c)
	local g2=Duel.GetMatchingGroup(c26053012.filter2,tp,LOCATION_DECK,0,nil,c)
	local g3=Duel.GetMatchingGroup(c26053012.filter3,tp,LOCATION_DECK,0,nil,e,tp,c)
	return c:IsMonster() and c:IsSetCard(0x2653)
	and c:IsType(TYPE_RITUAL) and not c:IsPublic()
	and((lab==1 and #g1>0)
	or (lab==2 and #g2>0)
	or(lab==3 and #g3>0))
end
function c26053012.filter1(c,tc)
	return c:IsMonster() and c:IsSetCard(0x653) and c:IsAbleToHand()
	and c26053012.table(c,tc)
end
function c26053012.filter2(c,tc)
	return c:IsMonster() and c:IsAbleToGrave() and c26053012.table(c,tc)
end
function c26053012.filter3(c,e,tp,tc)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c26053012.table(c,tc)
end
function c26053012.table(c,tc)
	local tab=tc.ELEGIAC
	if not tab then return false end
	for i=1,5 do
		if c:GetLevel()==tab[i] then return true end
	end
	return false
end
function c26053012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26053012.rfilter,tp,LOCATION_HAND,0,nil,e,tp,e:GetLabel())
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(tc)
	Duel.SetTargetCard(tc)
end
function c26053012.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26053012.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26053012.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26053012.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26053012.filter1,tp,LOCATION_DECK,0,1,1,nil,tc)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		g:AddCard(tc)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26053012.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26053012.filter2,tp,LOCATION_DECK,0,1,1,nil,tc)
	if #g>0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c26053012.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26053012.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
	if #g>0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26053012.extrafilter(c)
	return c:HasLevel() and c:IsAbleToGrave()
	and c:GetFlagEffect(26053012)>0
end
function c26053012.extramat(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(c26053012.extrafilter,tp,0,LOCATION_MZONE,nil)
end
function c26053012.filter4(c,e,tp,eg,ep,ev,re,r,rp)
	local rparams={lvtype=RITPROC_EQUAL,
		filter=aux.FilterBoolFunction(Card.IsCode,c:GetCode()),
		location=LOCATION_HAND,
		extrafil=c26053012.extramat}
	return c:IsMonster() and c:IsSetCard(0x2653)
	and c:IsType(TYPE_RITUAL) and not c:IsPublic()
	and Ritual.Target(rparams)(e,tp,eg,ep,ev,re,r,rp,0)
end
function c26053012.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053012.filter4,tp,LOCATION_HAND,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	local tc=Duel.SelectMatchingCard(tp,c26053012.filter4,tp,LOCATION_HAND,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetTargetCard(tc)
	local rparams={lvtype=RITPROC_EQUAL,
		filter=aux.FilterBoolFunction(tc),
		location=LOCATION_HAND,
		extrafil=c26053012.extramat,
		stage2=c26053012.stage2}
	Ritual.Target(rparams)(e,tp,eg,ep,ev,re,r,rp,1)
end
function c26053012.activate4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	e:SetLabelObject(g)
	local rparams={lvtype=RITPROC_EQUAL,
		filter=aux.FilterBoolFunction(c26053012.this,g),
		location=LOCATION_HAND,
		extrafil=c26053012.extramat}
	local rtg,rop=Ritual.Target(rparams),Ritual.Operation(rparams)
	if rtg(e,tp,eg,ep,ev,re,r,rp,0) then
		rop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c26053012.this(c,g)
	return g:IsContains(c)
end
function c26053012.checkop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	if re:IsMonsterEffect() and tc:IsRelateToEffect(re) and loc==LOCATION_MZONE then
		tc:RegisterFlagEffect(26053012,RESET_CHAIN|RESET_EVENT|RESETS_STANDARD,0,1)
	end
end