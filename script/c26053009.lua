--Divinus Elegiant - Lydias
function c26053009.initial_effect(c)
	c:EnableReviveLimit()
	c:AddMustBeRitualSummoned()
	--Check materials
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c26053009.valcheck)
	c:RegisterEffect(e0)
	--Set "Crescendo"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053009,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26053009)
	e1:SetCost(Cost.SelfDiscard)
	e1:SetTarget(c26053009.tftg)
	e1:SetOperation(c26053009.tfop)
	c:RegisterEffect(e1)
	--Special summon a Monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053009,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{26053009,1})
	e2:SetCondition(aux.NOT (c26053009.spcon2))
	e2:SetTarget(c26053009.sptg)
	e2:SetOperation(c26053009.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26053009,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e3:SetCondition(c26053009.spcon2)
	c:RegisterEffect(e3)
end
c26053009.listed_series={0x653,0x1653}
c26053009.ELEGIAC ={2,3,4,5,7}
function c26053009.ritual_custom_check(e,tp,g,c)
	return g:GetClassCount(Card.GetLevel)==#g
end
function c26053009.valcheck(e,c)
	local g=c:GetMaterial()
	if #g<2 then
		c:RegisterFlagEffect(26053009,RESET_EVENT|RESETS_STANDARD&~(RESET_TOFIELD|RESET_LEAVE|RESET_TEMP_REMOVE),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26053009,4))
	elseif #g==2 then
		c:RegisterFlagEffect(26053009,RESET_EVENT|RESETS_STANDARD&~(RESET_TOFIELD|RESET_LEAVE|RESET_TEMP_REMOVE),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26053009,3))
	end
end
function c26053009.mat_filter(c)
	local tp=c:GetControler()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26053013)}) do
		if c26053013.upfilter(c,i,2,3,4,5,7) then return true end
	end
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26053015)}) do
		if c26053015.dwfilter(c,i,2,3,4,5,7) then return true end
	end
	return c:IsLevel(2) or c:IsLevel(3) or 
	c:IsLevel(4) or c:IsLevel(5) or c:IsLevel(7)
end
function c26053009.setfilter(c)
	return c:IsCode(26053012) and c:IsSSetable()
end
function c26053009.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053009.setfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
end
function c26053009.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26053009.setfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then Duel.SSet(tp,g) end
end
function c26053009.spfilter(c,e,tp,tid)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and
	((c:IsSetCard(0x1653) and c:IsLocation(LOCATION_HAND)) or
	(c:GetTurnID()<tid))
end
function c26053009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mt,tid=e:GetHandler():GetMaterialCount(),Duel.GetTurnCount()
	if mt<3 then tid=tid-1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26053009.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,LOCATION_GRAVE,1,nil,e,tp,tid) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c26053009.spop(e,tp,eg,ep,ev,re,r,rp)
	local mt,tid=e:GetHandler():GetMaterialCount(),Duel.GetTurnCount()
	if mt<3 then tid=tid-1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26053009.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,LOCATION_GRAVE,1,1,nil,e,tp,tid)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26053009.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()&SUMMON_TYPE_RITUAL ~=0
	and c:GetMaterialCount()>1
end