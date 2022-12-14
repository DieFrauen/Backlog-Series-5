--Nomencreation
function c26051012.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	--e2:SetCountLimit(1)
	e2:SetCondition(c26051012.drcon)
	e2:SetTarget(c26051012.drtg)
	e2:SetOperation(c26051012.drop)
	c:RegisterEffect(e2)
end
function c26051012.drfilter(c,tp)
	return c:GetType()&0x11==0x11 
	and c:IsControler(tp)
	and not Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c,c:GetRace())
	and c:GetFlagEffect(26051012)==0
end
function c26051012.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26051012.drfilter,1,nil,tp)
end
function c26051012.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c26051012.drfilter(chkc,tp) end
	if chk==0 then return eg:IsExists(c26051012.drfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c26051012.drfilter,1,1,nil,tp)
	Duel.SetTargetCard(g)
	g:GetFirst():RegisterFlagEffect(26051012,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26051012.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
