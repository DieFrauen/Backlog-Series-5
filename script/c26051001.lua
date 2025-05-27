--Guldengeist Liber Abaci
function c26051001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26051001,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c26051001.announcecost)
	e1:SetCondition(c26051001.tfcon)
	e1:SetTarget(c26051001.tftg)
	e1:SetOperation(c26051001.tfop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c26051001.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	c:RegisterEffect(e1)
	--add target from gy to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26051001,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,26051001)
	e3:SetCost(c26051001.announcecost)
	e3:SetTarget(c26051001.thtg)
	e3:SetOperation(c26051001.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
c26051001.listed_series={0x651}
c26051001.listed_names={26051004}
function c26051001.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x651)
	and c:GetFlagEffect(26051004)==0 and c:GetCode()~=26051001
end
function c26051001.tffilter(c,tp)
	return c:IsSetCard(0x651) and c:IsSpellTrap() and c:IsSSetable()
end
function c26051001.announcecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26051001)==0
	and (c:GetFlagEffect(26051000)==0 or c:GetOriginalCode()==26051001) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:RegisterFlagEffect(26051000,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
	c:RegisterFlagEffect(26051001,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26051001.tfcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsStatus(STATUS_SUMMON_TURN)
end
function c26051001.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetHandler():GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(c26051001.tffilter,tp,LOCATION_DECK,0,1,nil,code) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c26051001.tfop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26051001.tffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,code):GetFirst()
	if tc and Duel.SSet(tp,tc)>0 then
		--Cannot be activated this turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT|RESETS_CANNOT_ACT|RESET_PHASE|PHASE_END)
		--tc:RegisterEffect(e1)
	end
end
function c26051001.thfilter(c,tp)
	return c:IsSpellTrap() and c:IsAbleToHand()
	and ((c:IsSetCard(0x651) and Duel.IsEnvironment(26051004))
	or c:IsCode(26051004))
end
function c26051001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26051001.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c26051001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26051001.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end