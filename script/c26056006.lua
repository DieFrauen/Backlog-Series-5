--Tetramius Fury - Tristia
function c26056006.initial_effect(c)
	--link summon
	Link.AddProcedure(c,c26056006.matfilter,2)
	c:EnableReviveLimit()
	--shift Tetraflare counters
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(26056006)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--Place 1 Tetraflare Counter on this card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056002,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,26056006)
	e2:SetCost(c26056006.tgcost)
	e2:SetOperation(c26056006.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--atk halve
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26056006,1))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(aux.NOT(c26056006.condition))
	e5:SetCountLimit(1,{26056006,1})
	e5:SetCost(c26056006.cost)
	e5:SetTarget(c26056006.target)
	e5:SetOperation(c26056006.operation)
	c:RegisterEffect(e5)
	--Quick if colinked
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(26056006,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e6:SetCondition(c26056006.condition)
	c:RegisterEffect(e6)
end
c26056006.listed_series={0x656,0x1656}
local COUNTER_TETRAFLARE =0x1656
c26056006.listed_names={26056002}
c26056006.counter_list={COUNTER_TETRAFLARE }
function c26056006.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x656,scard,sumtype,tp)
	or c:IsAttribute(ATTRIBUTE_FIRE,scard,sumtype,tp)
end
function c26056006.cfilter(c)
	return c:IsCode(26056002) and c:IsAbleToGraveAsCost() 
end
function c26056006.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26056006.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.GetFirstMatchingCard(c26056006.cfilter,tp,LOCATION_DECK,0,nil)
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabelObject(tc)
	tc:CreateEffectRelation(e)
end
function c26056006.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=e:GetLabelObject()
	local FLARE=c26056002.TETRAFLARE
	if tc and tc:IsRelateToEffect(e) and c:AddCounter(COUNTER_TETRAFLARE,1) and FLARE then
		c26056002.TETRAFLARE(e,tp)
	end
end
function c26056006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c26056006.ext(e,tp,c,1,0) end
	local POPULAS =Duel.IsPlayerAffectedByEffect(tp,26056011) and c26056011.ANYCOUNTER
	if c:GetCounter(0x1657)+c:GetCounter(0x1658)+c:GetCounter(0x1659)>0 and POPULAS and Duel.SelectYesNo(tp,aux.Stringid(26056011,1)) then
		POPULAS (e,tp,c,1)
	else c26056006.ext(e,tp,c,1,1) end
end
function c26056006.ext(e,tp,c,ct,chk)
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_TETRAFLARE,ct,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_TETRAFLARE,ct,REASON_COST)
end
function c26056006.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMutualLinkedGroup():Filter(Card.IsMonster,nil)
	return #g>0
end
function c26056006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) --and chkc:IsControler(1-tp)
	and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c26056006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(tc:GetAttack()/2)
		tc:RegisterEffect(e1)
	end
end