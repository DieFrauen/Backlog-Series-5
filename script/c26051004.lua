--Guldengeist Lattice
function c26051004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26051004,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c26051004.reg)
	e1:SetTarget(c26051004.target1)
	e1:SetOperation(c26051004.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26051004,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,26051004,EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c26051004.condition2)
	e2:SetTarget(c26051004.target2)
	e2:SetOperation(c26051004.activate2)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c26051004.ctop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--Add counter2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_LEAVE_FIELD_P)
	e6:SetRange(LOCATION_FZONE)
	e6:SetOperation(c26051004.ctspop)
	c:RegisterEffect(e6)
end
function c26051004.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(26051004,RESET_PHASE|PHASE_END,EFFECT_FLAG_OATH,1)
end
function c26051004.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if tc:IsFaceup() and tc:GetLevel()==1 and not tc:IsType(TYPE_TUNER) then
			tc:AddCounter(0x1100,tc:GetLevel())
		end
	end
end
function c26051004.ctspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsContains(c) then return end
	local ct=nil
	for tc in aux.Next(eg) do
		if tc:GetCounter(0x1100)>0 and tc:IsReason(REASON_MATERIAL)
		--and tc:GetOriginalType()&TYPE_TUNER ~=0
		then
			ct=tc:GetCounter(0x1100)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_BE_MATERIAL)
			e1:SetLabel(ct)
			e1:SetCondition(c26051004.efcon)
			e1:SetOperation(c26051004.efop)
			tc:RegisterEffect(e1)
		end
	end
end
function c26051004.efcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return rc:IsFaceup() and r&(REASON_SYNCHRO)~=0 
end
function c26051004.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local lb=e:GetLabel()
	if lb>0 then
		rc:AddCounter(0x1100,e:GetLabel())
		e:Reset()
	end
end
function c26051004.cfilter(c)
	return c:IsMonster() and c:GetCounter(0x1100)==0
	and c:GetLevel()==1
end
function c26051004.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_COUNTER,nil,1,0,COUNTER_SPELL)
end
function c26051004.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26051004.cfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26051004,0)) then 
		local tc=g:GetFirst()
		local lv=0
		for tc in aux.Next(g) do
			tc:AddCounter(0x1100,1)
		end
	end
end
function c26051004.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(26051004)~=0
end
function c26051004.showfilter(c)
	local loc=c:GetLocation()
	return c:IsSetCard(0x651) and c:IsMonster() and (
	loc==LOCATION_DECK and c:IsAbleToHand() or
	loc==LOCATION_HAND and c:IsSummonable(true,nil))
end
function c26051004.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26051004.showfilter,tp,LOCATION_HAND|LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>2 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,0)
end
function c26051004.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26051004.showfilter,tp,LOCATION_HAND|LOCATION_DECK,0,nil)
	if #g<2 then return end
	local g=aux.SelectUnselectGroup(g,e,tp,3,3,aux.dncheck,1,tp,HINTMSG_CONFIRM)
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELECT)
	local ng=g:Select(1-tp,1,1,nil)
	g:Sub(ng)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local sc=g:Select(tp,1,1,nil):GetFirst()
	if sc:IsLocation(LOCATION_DECK) then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	else
		Duel.Summon(tp,sc,true,nil)
	end
end