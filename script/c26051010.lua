--Guldengeist Wanderlusk
function c26051010.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26051010.spcon)
	e1:SetOperation(c26051010.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(c26051010.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--add target from gy to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26051010,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,26051010)
	e3:SetCost(c26051010.announcecost)
	e3:SetTarget(c26051010.thtg)
	e3:SetOperation(c26051010.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c26051010.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x651) and
	not c:IsCode(26051010)
end
function c26051010.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x651)
end
function c26051010.filter2(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c26051010.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c26051010.filter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not Duel.IsExistingMatchingCard(c26051010.filter2,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetCode())
end
function c26051010.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if e:GetHandler():GetOriginalCode()~=26051010 then
		e:GetHandler():RegisterFlagEffect(26051000,RESET_EVENT|RESETS_STANDARD_DISABLE -RESET_TOFIELD,0,1)
	end
end
function c26051010.announcecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26051000)==0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:RegisterFlagEffect(26051000,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26051010.thfilter(c,tp)
	local code=c:GetCode()
	return c:IsSetCard(0x651) and c:IsAbleToHand()
	and not Duel.IsExistingMatchingCard(c26051010.t2filter,tp,LOCATION_MZONE,0,1,nil,code)
end
function c26051010.t2filter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c26051010.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26051010.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c26051010.thfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26051010.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26051010.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end