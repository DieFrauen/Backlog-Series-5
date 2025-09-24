--Solemn Elegiant - Aionos
function c26053006.initial_effect(c)
	c:EnableReviveLimit()
	c:AddMustBeRitualSummoned()
	--Play "Orchestra of the Elegiants"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053006,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26053006)
	e1:SetCost(Cost.SelfDiscard)
	e1:SetTarget(c26053006.tftg)
	e1:SetOperation(c26053006.tfop)
	c:RegisterEffect(e1)
	--Return monsters on the field and/or in any GY(s) to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053006,0))
	e2:SetCategory(CATEGORY_TOHAND|CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,{26053006,1})
	e2:SetCondition(function(e) return e:GetHandler():IsRitualSummoned() end)
	e2:SetTarget(c26053006.thtg)
	e2:SetOperation(c26053006.thop)
	c:RegisterEffect(e2)
	--inactivatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c26053006.effectfilter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e4)
end
c26053006.listed_series={0x653,0x1653}
c26053006.ELEGIAC ={1,2,4,5,6}
function c26053006.ritual_custom_check(e,tp,g,c)
	return g:GetClassCount(Card.GetLevel)==#g
end
function c26053006.mat_filter(c)
	local tp=c:GetControler()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26053013)}) do
		if c26053013.upfilter(c,i,1,2,4,5,6) then return true end
	end
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26053015)}) do
		if c26053015.dwfilter(c,i,1,2,4,5,6) then return true end
	end
	return c:IsLevel(1) or c:IsLevel(2) or
	c:IsLevel(4) or c:IsLevel(5) or c:IsLevel(6)
end
function c26053006.setfilter(c,tp)
	return c:IsCode(26053011) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26053006.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053006.setfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,tp) end
end
function c26053006.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26053006.setfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp) end
end
function c26053006.thfilter(c,e,g)
	return c:IsMonster() and c:IsCanBeEffectTarget(e)
	and c:IsAbleToHand() and not g:IsContains(c)
end
function c26053006.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local g=Duel.GetMatchingGroup(c26053006.thfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,LOCATION_MZONE|LOCATION_GRAVE,c,e,mg)
	if chk==0 then return #g>0 end
	local tg=aux.SelectUnselectGroup(g,e,tp,1,#mg,aux.dncheck,1,tp,HINTMSG_ATOHAND)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,tp,0)
end
function c26053006.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c26053006.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x1653) and loc&LOCATION_ONFIELD|LOCATION_GRAVE|LOCATION_HAND~=0
end