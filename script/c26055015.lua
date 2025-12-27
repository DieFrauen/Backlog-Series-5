--Etherweight Smite from the Heavens
function c26055015.initial_effect(c)
	--Activate(effect)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetLabel(0)
	e1:SetCountLimit(1,26055015)
	e1:SetCondition(c26055015.cond)
	e1:SetCost(c26055015.cost)
	e1:SetTarget(c26055015.target)
	e1:SetOperation(c26055015.activate)
	c:RegisterEffect(e1)
	--Can be activated from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052015,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c26055015.handcon)
	c:RegisterEffect(e2)
end
function c26055015.handcon(e)
	local tp=e:GetHandlerPlayer()
	local b1=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil) and 1 or 0
	local b2=Duel.GetMatchingGroupCount(nil,tp,LOCATION_GRAVE,0,nil) and 1 or 0
	local b3=Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler()) and 1 or 0
	return b1+b2+b3>1
end
function c26055015.cond(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain()-1
	return ch>0 and ep==1-tp and Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_CONTROLER)==tp and Duel.IsChainDisablable(ev)
end
function c26055015.costfilter(c)
	return c:IsSetCard(0x655) and c:IsType(TYPE_PENDULUM) and c:IsReleasable()
end
function c26055015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local LOC =LOCATION_HAND|LOCATION_ONFIELD|LOCATION_EXTRA
	local rc=re:GetHandler()
	local sg=Duel.GetMatchingGroup(c26055015.costfilter,tp,LOC,0,nil)
	if chk==0 then return #sg>0 end
	sg=sg:Select(tp,1,1,nil)
	e:SetLabel(sg:GetSum(Card.GetAttack))
	Duel.SendtoGrave(sg,REASON_COST|REASON_DISCARD)
end
function c26055015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,eg,e:GetLabel()-rc:GetAttack(),0,0)
end
function c26055015.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local atk=e:GetLabel()-rc:GetAttack()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)
	then
		if Duel.Destroy(eg,REASON_EFFECT)~=0 and atk>0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end