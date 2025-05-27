--Guldengeist Phylliance
function c26051009.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c26051009.sumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26051009,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c26051009.announcecost)
	e2:SetCondition(c26051009.thcon)
	e2:SetTarget(c26051009.thtg)
	e2:SetOperation(c26051009.thop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c26051009.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	c:RegisterEffect(e2)
end
c26051009.listed_series={0x651}
function c26051009.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,26051009)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND|LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetDescription(aux.Stringid(26051009,1))
	e1:SetTarget(aux.TargetBoolFunction(Card.GetLevel,1))
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,26051009,RESET_PHASE|PHASE_END,0,1)
end
function c26051009.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x651)
	and c:GetFlagEffect(26051000)==0 and c:GetCode()~=26051009
end
function c26051009.thfilter(c,tp)
	return c:IsSetCard(0x651) and c:IsAbleToHand() and c:IsMonster()
	and not Duel.IsExistingMatchingCard(c26051009.snfilter,tp,LOCATION_MZONE|LOCATION_GRAVE|LOCATION_REMOVED,0,1,nil,c:GetCode())
end
function c26051009.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsStatus(STATUS_SUMMON_TURN)
end
function c26051009.snfilter(c,code)
	return c:IsCode(code) and c:IsFaceup() and c:IsMonster()
end
function c26051009.announcecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26051009)==0
	and (c:GetFlagEffect(26051000)==0 or c:GetOriginalCode()==26051009) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:RegisterFlagEffect(26051000,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
	c:RegisterFlagEffect(26051009,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26051009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26051009.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c26051009.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26051009.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end