--Guldengeist - The Vitruvian
function c26051008.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SYNCHRO),1,1,Synchro.NonTunerEx(Card.IsType,TYPE_SYNCHRO),1,1,c26051008.exmatfilter)
	--negate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26051008,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26051008)
	e1:SetCondition(c26051008.condition1)
	e1:SetTarget(c26051008.target1)
	e1:SetOperation(c26051008.activate1)
	c:RegisterEffect(e1)
	--Activate(effect)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26051008,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,26051008)
	e2:SetCondition(c26051008.condition2)
	e2:SetTarget(c26051008.target2)
	e2:SetOperation(c26051008.activate2)
	c:RegisterEffect(e2)
	--shuffle all extras into deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26051008,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,26051008)
	e3:SetCondition(c26051008.tdcon)
	e3:SetTarget(c26051008.tdtg)
	e3:SetOperation(c26051008.tdop)
	c:RegisterEffect(e3)
end
function c26051008.exmatfilter(c,scard,sumtype,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_SYNCHRO,scard,sumtype,tp) and (lv==3 or lv==5)
end
function c26051008.disfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c26051008.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
	and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
	and eg:IsExists(c26051008.disfilter,1,nil)
end
function c26051008.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function c26051008.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c26051008.condition2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c26051008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c26051008.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c26051008.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSynchroSummoned() and c:IsPreviousPosition(POS_FACEUP)
	and c:GetLocation()~=LOCATION_DECK 
end
function c26051008.tdfilter(c)
	local TYPES = TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK 
	return c:IsMonster() and c:IsType(TYPES) and c:IsAbleToDeck()
end
function c26051008.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c26051008.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,LOCATION_GRAVE)
end
function c26051008.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26051008.tdfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end