--The Sublime Nomencreator
function c26052011.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,false,false,c26052011.mfilter,1,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FUSION),5)
	--Special Summon procedure
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052011,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c26052011.spcon)
	e2:SetTarget(c26052011.sptg)
	e2:SetOperation(c26052011.spop)
	c:RegisterEffect(e2)
	--Increase ATK/DEF
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c26052011.atkval)
	c:RegisterEffect(e2)
	--Decrease ATK/DEF
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c26052011.rctg)
	e3:SetValue(c26052011.val)
	c:RegisterEffect(e3)
	--lock typed Monsters
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c26052011.negtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--todeck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26052011,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c26052011.tdtg)
	e5:SetOperation(c26052011.tdop)
	c:RegisterEffect(e5)
end
function c26052011.mfilter(c,sc,st,tp)
	return c:IsSetCard(0x2652,sc,st,tp) and c:IsType(TYPE_FUSION,sc,st,tp) and c:IsOnField()
end
function c26052011.atkval(e,c)
	return Duel.GetMatchingGroup(Card.IsMonster,0,LOCATION_GRAVE,LOCATION_GRAVE,nil):GetClassCount(Card.GetRace)*200
end
function c26052011.val(e,c)
	return Duel.GetMatchingGroup(Card.IsMonster,0,LOCATION_GRAVE,LOCATION_GRAVE,nil):GetClassCount(Card.GetRace)*(-200)
end
function c26052011.spcostfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_FUSION) and c:GetMaterialCount()>0
end
function c26052011.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c26052011.spcostfilter,tp,LOCATION_MZONE,0,nil)
	return aux.SelectUnselectGroup(g,e,tp,2,#g,c26052011.rescon,0)
end
function c26052011.rescon(sg,e,tp,mg)
	return sg:GetSum(Card.GetMaterialCount)>11
end
function c26052011.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c26052011.spcostfilter,tp,LOCATION_MZONE,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,#g,c26052011.rescon,1,tp,HINTMSG_RELEASE,c26052011.rescon)
	if sg:GetSum(Card.GetMaterialCount)>11 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function c26052011.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST|REASON_RELEASE)
	g:DeleteGroup()
end
function c26052011.normtg(c,rc)
	return c:IsType(TYPE_NORMAL) and c:IsRace(rc)
end
function c26052011.rctg(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c26052011.normtg,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c:GetRace())
end
function c26052011.negtg(e,c)
	return c:GetAttack()==0 and c26052011.rctg(e,c)
end
function c26052011.tdfilter(c)
	return c:IsMonster() and c:IsAbleToDeck()
end
function c26052011.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c26052011.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26052011.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26052011.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,e:GetHandler()):Filter(Card.IsRace,nil,g:GetFirst():GetRace())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c26052011.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,e:GetHandler()):Filter(Card.IsRace,nil,tc:GetRace())
		Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end