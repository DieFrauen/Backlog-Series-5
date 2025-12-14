--Sturdy Tetramius - Carcera
function c26056007.initial_effect(c)
	--link summon
	Link.AddProcedure(c,c26056007.matfilter,2)
	c:EnableReviveLimit()
	--Place 1 TETRALAND Counter on this card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056007,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c26056007.tgcost)
	e2:SetOperation(c26056007.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--enable target protection ignore
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(26056003)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	--atk halve
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26056007,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetLabel(1)
	e5:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(c26056007.condition)
	e5:SetCost(c26056007.cost)
	e5:SetTarget(c26056007.target)
	e5:SetOperation(c26056007.operation)
	c:RegisterEffect(e5)
	--Quick if colinked
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(26056007,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e6:SetLabel(2)
	c:RegisterEffect(e6)
end
c26056007.listed_series={0x656,0x1656}
local COUNTER_TETRALAND =0x1657
c26056007.listed_names={26056003}
c26056007.counter_list={COUNTER_TETRALAND }
function c26056007.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x656,scard,sumtype,tp)
	or c:IsAttribute(ATTRIBUTE_EARTH,scard,sumtype,tp)
end
function c26056007.cfilter(c)
	return c:IsCode(26056003) and c:IsAbleToGraveAsCost() 
end
function c26056007.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26056007.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.GetFirstMatchingCard(c26056007.cfilter,tp,LOCATION_DECK,0,nil)
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabelObject(tc)
	tc:CreateEffectRelation(e)
end
function c26056007.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToEffect(e) and c:AddCounter(COUNTER_TETRALAND,1) then
		c26056003.TETRALAND(e,tp)
	end
end
function c26056007.costfilter(c,tp)
	return c:IsFaceup() and c:IsMonster() and c:IsCanAddCounter(tp,COUNTER_TETRALAND,1) and c:IsSetCard(0x656)
end
function c26056007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c26056007.ext(e,tp,c,1,0) end
	local POPULAS =Duel.IsPlayerAffectedByEffect(tp,26056011) and c26056011.ANYCOUNTER
	if c:GetCounter(0x1656)+c:GetCounter(0x1658)+c:GetCounter(0x1659)>0 and POPULAS and Duel.SelectYesNo(tp,aux.Stringid(26056011,1)) then
		POPULAS (e,tp,c,1)
	else c26056007.ext(e,tp,c,1,1) end
end
function c26056007.ext(e,tp,c,ct,chk)
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_TETRALAND,ct,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_TETRALAND,ct,REASON_COST)
end
function c26056007.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMutualLinkedGroup()
	local lb=e:GetLabel()
	return #g>0 and
	(#g>=lb 
	or g:IsExists(c26056007.colinkfilter,1,c,lb))
end
function c26056007.colinkfilter(c,lb)
	return c:GetMutualLinkedGroupCount()>=lb
end
function c26056007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c26056007.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end