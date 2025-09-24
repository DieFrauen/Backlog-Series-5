--Diabolus Elegiant - Phrygios
function c26053010.initial_effect(c)
	c:EnableReviveLimit()
	c:AddMustBeRitualSummoned()
	--Set "Diminuendo"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053010,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26053010)
	e1:SetCost(Cost.SelfDiscard)
	e1:SetTarget(c26053010.tftg)
	e1:SetOperation(c26053010.tfop)
	c:RegisterEffect(e1)
	--send target(s) to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053010,1))
	e2:SetCategory(CATEGORY_TOGRAVE|CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetLabel(0)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c26053010.tgcon)
	e2:SetTarget(c26053010.tgtg)
	e2:SetOperation(c26053010.tgop)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26053010,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetLabel(1)
	e3:SetCondition(function(e) return e:GetHandler():IsRitualSummoned() end)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	c:RegisterEffect(e3)
end
c26053010.listed_series={0x653,0x1653}
c26053010.ELEGIAC ={1,2,4,6,7}
function c26053010.ritual_custom_check(e,tp,g,c)
	return g:GetClassCount(Card.GetLevel)==#g
end
function c26053010.mat_filter(c)
	local tp=c:GetControler()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26053013)}) do
		if c26053013.upfilter(c,i,1,2,4,6,7) then return true end
	end
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26053015)}) do
		if c26053015.dwfilter(c,i,1,2,4,6,7) then return true end
	end
	return c:IsLevel(1) or c:IsLevel(2)
	or c:IsLevel(4) or c:IsLevel(6) or c:IsLevel(7)
end
function c26053010.setfilter(c)
	return c:IsCode(26053014) and c:IsSSetable()
end
function c26053010.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053010.setfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
end
function c26053010.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26053010.setfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then Duel.SSet(tp,g) end
end
function c26053010.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26053010.setfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then Duel.SSet(tp,g) end
end
function c26053010.tgconf(c)
	return c:IsFaceup() and c:IsRitualMonster() and c:IsRitualSummoned()
end
function c26053010.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26053010.tgconf,1,nil)
end
function c26053010.tgfilter(c,p)
	return Duel.IsPlayerCanRelease(p,c)
end
function c26053010.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and Duel.IsPlayerCanRelease(tp,chkc) and not chkc==c end
	local mg=1
	if e:GetLabel()==1 then mg=c:GetMaterialCount() end
	if chk==0 then return mg>0 and Duel.IsExistingTarget(c26053010.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c26053010.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,mg,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,tp,0)
end
function c26053010.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.Release(tg,REASON_EFFECT)
	end
end