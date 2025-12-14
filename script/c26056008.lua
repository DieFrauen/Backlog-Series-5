--Tetramius Spur - Junthia
function c26056008.initial_effect(c)
	--link summon
	Link.AddProcedure(c,c26056008.matfilter,2)
	c:EnableReviveLimit()
	--Place 1 TETRAQUA Counter on this card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056008,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c26056008.tgcost)
	e2:SetOperation(c26056008.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--transfer Tetraqua Counters
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(26056008)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	--atk halve
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26056008,1))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(aux.NOT(c26056008.condition))
	e5:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCost(c26056008.cost)
	e5:SetTarget(c26056008.target)
	e5:SetOperation(c26056008.operation)
	c:RegisterEffect(e5)
	--Quick if colinked
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(26056008,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e6:SetCondition(c26056008.condition)
	c:RegisterEffect(e6)
end
c26056008.listed_series={0x656,0x1656}
local COUNTER_TETRAQUA =0x1658
c26056008.listed_names={26056004}
c26056008.counter_list={COUNTER_TETRAQUA }
function c26056008.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x656,scard,sumtype,tp)
	or c:IsAttribute(ATTRIBUTE_WATER,scard,sumtype,tp)
end
function c26056008.cfilter(c)
	return c:IsCode(26056004) and c:IsAbleToGraveAsCost() 
end
function c26056008.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26056008.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.GetFirstMatchingCard(c26056008.cfilter,tp,LOCATION_DECK,0,nil)
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabelObject(tc)
	tc:CreateEffectRelation(e)
end
function c26056008.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToEffect(e) and c:AddCounter(COUNTER_TETRAQUA,1) then
		c26056004.TETRAQUA(e,tp)
	end
end
function c26056008.costfilter(c,tp)
	return c:IsFaceup() and c:IsMonster() and c:IsCanAddCounter(tp,COUNTER_TETRAQUA,1) and c:IsSetCard(0x656)
end
function c26056008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c26056008.ext(e,tp,c,1,0) end
	local POPULAS =Duel.IsPlayerAffectedByEffect(tp,26056011) and c26056011.ANYCOUNTER 
	if c:GetCounter(0x1656)+c:GetCounter(0x1657)+c:GetCounter(0x1659)>0 and POPULAS and Duel.SelectYesNo(tp,aux.Stringid(26056011,1)) then
		POPULAS (e,tp,c,1)
	else c26056008.ext(e,tp,c,chk) end
end
function c26056008.ext(e,tp,c,ct,chk)
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_TETRAQUA,ct,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_TETRAQUA,ct,REASON_COST)
end
function c26056008.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMutualLinkedGroup():Filter(Card.IsSetCard,nil,0x656)
	return #g>0
end
function c26056008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) --and chkc:IsControler(1-tp)
	and chkc:IsNegatable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsNegatable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsNegatable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c26056008.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:NegateEffects(e:GetHandler(),RESET_PHASE|PHASE_END,true)
	end
end