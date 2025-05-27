--Guldengeist Phion
function c26051002.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,1,c26051002.exmatfilter)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26051002,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,26051002)
	e1:SetCondition(function(e)
		return e:GetHandler():IsSynchroSummoned() end)
	e1:SetTarget(c26051002.sptg)
	e1:SetOperation(c26051002.spop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_PRE_MATERIAL)
	e2:SetCondition(c26051002.effcon)
	e2:SetOperation(c26051002.effop1)
	c:RegisterEffect(e2)
end
function c26051002.exmatfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x651,scard,sumtype,tp)
end
c26051002.listed_series={0x651}
function c26051002.sumfilter(c,tp,tc)
	return c:GetLevel()==1 and c:IsSummonable(true,nil)
	and (c:IsOnField() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c26051002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26051002.sumfilter,tp,LOCATION_HAND,0,1,nil,tp,tc) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26051002.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local sc=Duel.SelectMatchingCard(tp,c26051002.sumfilter,ep,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp,tc):GetFirst()
	if sc then
		Duel.Summon(tp,sc,true,nil)
	end
end
function c26051002.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c26051002.effop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26051002,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESETS_STANDARD_PHASE_END)
	rc:RegisterEffect(e1)
end