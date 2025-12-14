--Swift Tetramius - Laethia
function c26056009.initial_effect(c)
	--link summon
	Link.AddProcedure(c,c26056009.matfilter,2)
	c:EnableReviveLimit()
	--Place 1 TETRAIR Counter on this card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056009,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c26056009.tgcost)
	e2:SetOperation(c26056009.tgop)
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
	e5:SetCode(26056005)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	--atk halve
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26056009,1))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e5:SetLabel(1)
	e5:SetCondition(c26056009.condition)
	e5:SetCost(c26056009.cost)
	e5:SetTarget(c26056009.target)
	e5:SetOperation(c26056009.operation)
	c:RegisterEffect(e5)
	--Quick if colinked
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(26056009,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e6:SetLabel(2)
	c:RegisterEffect(e6)
end
c26056009.listed_series={0x656,0x1656}
local COUNTER_TETRAIR =0x1659
c26056009.listed_names={26056005}
c26056009.counter_list={COUNTER_TETRAIR }
function c26056009.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x656,scard,sumtype,tp)
	or c:IsAttribute(ATTRIBUTE_WIND,scard,sumtype,tp)
end
function c26056009.cfilter(c)
	return c:IsCode(26056005) and c:IsAbleToGraveAsCost() 
end
function c26056009.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26056009.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.GetFirstMatchingCard(c26056009.cfilter,tp,LOCATION_DECK,0,nil)
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabelObject(tc)
	tc:CreateEffectRelation(e)
end
function c26056009.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToEffect(e) and c:AddCounter(COUNTER_TETRAIR,1) then
		c26056005.TETRAIR(e,tp)
	end
end
function c26056009.costfilter(c,tp)
	return c:IsFaceup() and c:IsMonster() and c:IsCanAddCounter(tp,COUNTER_TETRAIR,1) and c:IsSetCard(0x656)
end
function c26056009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c26056009.ext(e,tp,c,1,0) end
	local POPULAS =Duel.IsPlayerAffectedByEffect(tp,26056011) and c26056011.ANYCOUNTER
	if c:GetCounter(0x1656)+c:GetCounter(0x1657)+c:GetCounter(0x1658)>0 and POPULAS and Duel.SelectYesNo(tp,aux.Stringid(26056011,1)) then
		POPULAS (e,tp,c,1)
	else c26056009.ext(e,tp,c,1,1) end
end
function c26056009.ext(e,tp,c,ct,chk)
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_TETRAIR,ct,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_TETRAIR,ct,REASON_COST)
end
function c26056009.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMutualLinkedGroup()
	local lb=e:GetLabel()
	return #g>0 and
	(#g>=lb or g:IsExists(c26056009.colinkfilter,1,c,lb))
end
function c26056009.colinkfilter(c,lb)
	return c:GetMutualLinkedGroupCount()>=lb
end
function c26056009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) --and chkc:IsControler(1-tp) and chkc:IsFaceup()
	and c:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c26056009.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end