--Silent Elegiant - Locryos
function c26053008.initial_effect(c)
	c:EnableReviveLimit()
	c:AddMustBeRitualSummoned()
	--Set "Pianissimo"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053008,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26053008)
	e1:SetCost(Cost.SelfDiscard)
	e1:SetTarget(c26053008.tftg)
	e1:SetOperation(c26053008.tfop)
	c:RegisterEffect(e1)
	--Return monsters on the field and/or in any GY(s) to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053008,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,{26053008,1})
	e2:SetCondition(function(e) return e:GetHandler():IsRitualSummoned() end)
	e2:SetTarget(c26053008.tgtg)
	e2:SetOperation(c26053008.tgop)
	c:RegisterEffect(e2)
	--indestructible (Rituals)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c26053008.deslimit)
	e3:SetValue(aux.TRUE)
	c:RegisterEffect(e3)
end
c26053008.listed_series={0x653,0x1653}
c26053008.ELEGIAC ={1,2,3,4,6}
function c26053008.ritual_custom_check(e,tp,g,c)
	return g:GetClassCount(Card.GetLevel)==#g
end
function c26053008.mat_filter(c)
	local tp=c:GetControler()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26053013)}) do
		if c26053013.upfilter(c,i,1,2,3,4,6) then return true end
	end
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26053015)}) do
		if c26053015.dwfilter(c,i,1,2,3,4,6) then return true end
	end
	return c:IsLevel(1) or c:IsLevel(2) or
	c:IsLevel(3) or c:IsLevel(4) or c:IsLevel(6)
end
function c26053008.setfilter(c)
	return c:IsCode(26053015) and c:IsSSetable()
end
function c26053008.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053008.setfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
end
function c26053008.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26053008.setfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then Duel.SSet(tp,g) end
end
function c26053008.tgfilter(c,tp)
	return c:IsMonster() and c:HasLevel() and c:IsAbleToGrave()
	and not Duel.IsExistingMatchingCard(c26053008.lvfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel())
end
function c26053008.lvfilter(c,lv)
	return c:IsMonster() and c:GetLevel()==lv
end
function c26053008.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x1653)
	and sg:GetClassCount(Card.GetLevel)==#sg
end
function c26053008.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26053008.tgfilter,tp,LOCATION_DECK,0,c,tp)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,1,c26053008.rescon,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26053008.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local g=Duel.GetMatchingGroup(c26053008.tgfilter,tp,LOCATION_DECK,0,c,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,#mg,c26053008.rescon,1,tp,HINTMSG_TOGRAVE)
	if #sg>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c26053008.deslimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x653) and c~=e:GetHandler()
end