--Languid Elegiant - Dorias
function c26053007.initial_effect(c)
	c:EnableReviveLimit()
	c:AddMustBeRitualSummoned()
	--Set "Fortissimo"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053006,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26053007)
	e1:SetCost(Cost.SelfDiscard)
	e1:SetTarget(c26053007.tftg)
	e1:SetOperation(c26053007.tfop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053007,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{26053007,1})
	e2:SetCondition(function(e) return e:GetHandler():IsRitualSummoned() end)
	e2:SetTarget(c26053007.drtg)
	e2:SetOperation(c26053007.drop)
	c:RegisterEffect(e2)
	--cannot be target/indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c26053007.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
c26053007.listed_series={0x653,0x1653}
c26053007.ELEGIAC ={1,2,3,5,7}
function c26053007.ritual_custom_check(e,tp,g,c)
	return g:GetClassCount(Card.GetLevel)==#g
end
function c26053007.mat_filter(c)
	local tp=c:GetControler()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26053013)}) do
		if c26053013.upfilter(c,i,1,2,3,5,7) then return true end
	end
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26053015)}) do
		if c26053015.dwfilter(c,i,1,2,3,5,7) then return true end
	end
	return c:IsLevel(1) or c:IsLevel(2) or
	c:IsLevel(3) or c:IsLevel(5) or c:IsLevel(7)
end
function c26053007.setfilter(c)
	return c:IsCode(26053013) and c:IsSSetable()
end
function c26053007.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053007.setfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
end
function c26053007.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26053007.setfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then Duel.SSet(tp,g) end
end
function c26053007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=e:GetHandler():GetMaterialCount()
	if chk==0 then return val>0 and Duel.IsPlayerCanDraw(tp,val) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,val)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,val-1)
end
function c26053007.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 and d>0 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,d-1,d-1,REASON_EFFECT|REASON_DISCARD)
	end
end
function c26053007.tglimit(e,c)
	return c:IsType(TYPE_RITUAL)
	and c~=e:GetHandler()
end