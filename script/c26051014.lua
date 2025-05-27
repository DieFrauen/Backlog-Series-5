--Guldengeist Sequence
function c26051014.initial_effect(c)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26051014.target)
	e1:SetOperation(c26051014.activate)
	c:RegisterEffect(e1)
	--Can be activated from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26051014,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c26051014.handcon)
	c:RegisterEffect(e2)
	--activate effect from graveyard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26051014,3))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetLabel(1)
	e3:SetCost(c26051014.cost)
	e3:SetTarget(c26051014.target1)
	e3:SetOperation(c26051014.operation1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(26051014,4))
	e4:SetTarget(c26051014.target2)
	e4:SetOperation(c26051014.operation2)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(26051014,5))
	e5:SetLabel(2)
	e5:SetTarget(c26051014.target3)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetDescription(aux.Stringid(26051014,6))
	e6:SetLabel(3)
	e6:SetTarget(c26051014.target4)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetDescription(aux.Stringid(26051014,7))
	e7:SetLabel(5)
	e7:SetTarget(c26051014.target5)
	c:RegisterEffect(e7)
	local e8=e3:Clone()
	e8:SetDescription(aux.Stringid(26051014,8))
	e8:SetLabel(8)
	e8:SetTarget(c26051014.target6)
	c:RegisterEffect(e8)
end
c26051014.counter_list={0x1100}
function c26051014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26051014.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if #g>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051014,9))
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
function c26051014.tuner(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c26051014.handcon(e)
	return not Duel.IsExistingMatchingCard(c26051014.tuner,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c26051014.costfilter(c,e,tp,lb)
	return c:IsType(TYPE_SYNCHRO) and c:GetCounter(0x1100)>=lb
end
function c26051014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lb=e:GetLabel()
	local g=Duel.GetMatchingGroup(c26051014.costfilter,tp,LOCATION_ONFIELD,0,nil,e,tp,lb)
	if chk==0 then return #g>0 and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	tc:RemoveCounter(tp,0x1100,lb,REASON_COST)
end
function c26051014.filter1(c)
	return c:IsFaceup() and c:IsMonster() and c:IsType(TYPE_TUNER)
end
function c26051014.filter2(c)
	return c:IsFaceup() and c:IsMonster() and c:IsLevelAbove(1)
end
function c26051014.filter3(c)
	return c:IsFaceup() and c:IsMonster()
	and (c:IsCanBeFusionMaterial()
		or c:IsCanBeLinkMaterial()
		or c:IsCanBeXyzMaterial())
end
function c26051014.filter4(c)
	return c:IsFaceup() and c:IsMonster()
	and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c26051014.filter5(c,e,tp)
	return c:IsFaceup() and c:IsMonster() and c:IsAbleToRemove(tp)
end
function c26051014.filter6(c)
	return c:IsFaceup() and c:IsMonster()
	and c:IsType(TYPE_EFFECT) and not c:IsDisabled() and c:IsAbleToRemove(tp)
end
function c26051014.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local func=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c26051014.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26051014.filter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26051014.filter1,tp,0,LOCATION_MZONE,1,1,nil)
end
function c26051014.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local func=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c26051014.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26051014.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26051014.filter2,tp,0,LOCATION_MZONE,1,1,nil)
end
function c26051014.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local func=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c26051014.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26051014.filter3,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26051014.filter3,tp,0,LOCATION_MZONE,1,1,nil)
end
function c26051014.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	local func=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c26051014.filter4(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26051014.filter4,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26051014.filter4,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c26051014.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	local func=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c26051014.filter5(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26051014.filter5,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26051014.filter5,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c26051014.target6(e,tp,eg,ep,ev,re,r,rp,chk)
	local func=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c26051014.filter6(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26051014.filter6,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26051014.filter6,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c26051014.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local lb=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup()
	and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if lb==1 then c26051014.op1(e,c,tc)
		elseif lb==2 then c26051014.op3(e,c,tc)
		elseif lb==3 then c26051014.op4(e,c,tc)
		elseif lb==5 then c26051014.op5(e,c,tc)
		elseif lb==8 then
			c26051014.op4(e,c,tc)
			c26051014.op5(e,c,tc)
		end
	end
end
function c26051014.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup()
	and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local op=0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051014,2))
		if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(id,0))
		else op=Duel.SelectOption(tp,aux.Stringid(26051014,9),aux.Stringid(26051014,10)) end 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		if op==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end
function c26051014.op1(e,c,tc)
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMOVE_TYPE)
	e1:SetValue(TYPE_TUNER)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
function c26051014.op3(e,c,tc)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetReset(RESETS_STANDARD_PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	tc:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetDescription(aux.Stringid(26051014,11))
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e4:SetReset(RESETS_STANDARD_PHASE_END)
	e4:SetValue(1)
	e4:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
	tc:RegisterEffect(e4)
end
function c26051014.op4(e,c,tc)
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DISABLE)
	e7:SetReset(RESETS_STANDARD_PHASE_END)
	tc:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_DISABLE_EFFECT)
	e8:SetValue(RESET_TURN_SET)
	e8:SetReset(RESETS_STANDARD_PHASE_END)
	tc:RegisterEffect(e8)
end
function c26051014.op5(e,c,tc)
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
end