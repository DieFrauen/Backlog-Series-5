--Etherweight Caladbolg
function c26055004.initial_effect(c)
	--pendulum effect
		Pendulum.AddProcedure(c)
		--add to Hand
		local pe1=Effect.CreateEffect(c)
		pe1:SetDescription(aux.Stringid(26055004,0))
		pe1:SetCategory(CATEGORY_DESTROY|CATEGORY_TOHAND)
		pe1:SetType(EFFECT_TYPE_IGNITION)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetCountLimit(1,26055004)
		pe1:SetTarget(c26055004.pentg)
		pe1:SetOperation(c26055004.penop)
		c:RegisterEffect(pe1)
	--equip effect (equipped by an "Etherweight" card effect)
		--atk up
		local eq1=Effect.CreateEffect(c)
		eq1:SetType(EFFECT_TYPE_EQUIP)
		eq1:SetCode(EFFECT_UPDATE_ATTACK)
		eq1:SetCondition(c26055004.eqcon)
		eq1:SetValue(700)
		c:RegisterEffect(eq1)
		--add to Hand
		local eq2=pe1:Clone()
		eq2:SetRange(LOCATION_SZONE)
		eq2:SetCondition(c26055004.eqcon)
		c:RegisterEffect(eq2)
	--monster effect
		--return target to hand (Ignition)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26055004,1))
		e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1,26055004)
		e1:SetCost(Cost.SelfDiscardToGrave)
		e1:SetCondition(aux.NOT(c26055004.quickcon))
		e1:SetTarget(c26055004.thtg)
		e1:SetOperation(c26055004.thop)
		c:RegisterEffect(e1)
		--return target to hand (Quick)
		local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
		e2:SetCondition(c26055004.quickcon)
		c:RegisterEffect(e2)
		--equip
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(1068)
		e3:SetCategory(CATEGORY_EQUIP)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetRange(LOCATION_HAND|LOCATION_GRAVE|LOCATION_EXTRA)
		e3:SetCountLimit(1,26055004)
		e3:SetCondition(aux.NOT(c26055004.quickcon))
		e3:SetTarget(c26055004.eqtg)
		e3:SetOperation(c26055004.eqop)
		c:RegisterEffect(e3)
		--return target to hand (Quick)
		local e4=e3:Clone()
		e4:SetType(EFFECT_TYPE_QUICK_O)
		e4:SetCode(EVENT_FREE_CHAIN)
		e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
		e4:SetCondition(c26055004.quickcon)
		c:RegisterEffect(e4)
end
function c26055004.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(26055001) and c:GetEquipTarget()
end
function c26055004.penfilter(c)
	return c:IsSetCard(0x655) and c:IsType(TYPE_PENDULUM)
	and c:IsFaceup() and c:IsAbleToHand()
end
function c26055004.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26055004.penfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c26055004.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c26055004.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c26055004.quickcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end
function c26055004.thfilter(c,tp)
	return c:IsSetCard(0x655) and c:IsAbleToHand()
end
function c26055004.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26055004.thfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26055004.thfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26055004.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function c26055004.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c26055004.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x655)
end
function c26055004.eq2filter(c)
	return c:IsSetCard(0x655) and c:IsMonster() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c26055004.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local LOC=c:GetLocation()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26055004.eqfilter(ec) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c26055004.eqfilter,tp,LOCATION_MZONE,0,1,c,c,LOC) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26055004.eqfilter,tp,LOCATION_MZONE,0,1,1,c,c,LOC)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
	if LOC==LOCATION_GRAVE then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
	end
end
function c26055004.equipop(c,e,tp,tc)
	Duel.Equip(tp,c,tc)
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(true)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(26055001,RESET_EVENT|RESETS_STANDARD,0,1)
end
function c26055004.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and ft>0 then
		local g=Group.FromCards(c)
		local qg=Duel.GetMatchingGroup(c26055004.eq2filter,tp,c:GetLocation(),0,c)
		if #qg>0 and ft>1 then
			qg=qg:Select(tp,0,1,c)
			g:AddCard(qg)
		end
		local sc=g:GetFirst()
		for sc in aux.Next(g) do
			c26055004.equipop(sc,e,tp,tc)
		end
	end
end