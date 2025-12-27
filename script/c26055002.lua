--Etherweight Excaliber
function c26055002.initial_effect(c)
	--Pendulum Effect
		Pendulum.AddProcedure(c)
		--If your Pendulum monster attacks, your opponent cannot activate cards or effects until the end of the Damage Step
		local pe1=Effect.CreateEffect(c)
		pe1:SetType(EFFECT_TYPE_FIELD)
		pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		pe1:SetCode(EFFECT_CANNOT_ACTIVATE)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetTargetRange(0,1)
		pe1:SetCondition(c26055002.actcon)
		pe1:SetValue(1)
		c:RegisterEffect(pe1)
		--halve battle target's ATK
		local pe2=Effect.CreateEffect(c)
		pe2:SetType(EFFECT_TYPE_FIELD)
		pe2:SetCode(EFFECT_SET_BASE_ATTACK)
		pe2:SetRange(LOCATION_PZONE)
		pe2:SetTarget(c26055002.atktg)
		pe2:SetTargetRange(0,LOCATION_MZONE)
		pe2:SetValue(c26055002.atkval)
		c:RegisterEffect(pe2)
	--equip effect (equipped by an "Etherweight" card effect)
		--atk up
		local eq1=Effect.CreateEffect(c)
		eq1:SetType(EFFECT_TYPE_EQUIP)
		eq1:SetCode(EFFECT_UPDATE_ATTACK)
		eq1:SetCondition(c26055002.eqcon)
		eq1:SetValue(900)
		c:RegisterEffect(eq1)
		--prevent battle response
		eq2=pe1:Clone()
		eq2:SetRange(LOCATION_SZONE)
		eq2:SetCondition(aux.AND(c26055002.eqcon,c26055002.actcon))
		c:RegisterEffect(eq2)
		--halve battle target's ATK
		eq3=pe2:Clone()
		eq3:SetRange(LOCATION_SZONE)
		eq3:SetCondition(aux.AND(c26055002.eqcon,c26055002.actcon))
		c:RegisterEffect(eq3)
	--Monster Effect
		--Special Summon "Etherweight" from gy
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26055002,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCountLimit(1,26055002)
		e1:SetCondition(c26055002.spcon)
		e1:SetTarget(c26055002.sptg)
		e1:SetOperation(c26055002.spop)
		c:RegisterEffect(e1)
		--Equip 1 "Etherweight" monster to itself
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26055002,1))
		e2:SetCategory(CATEGORY_EQUIP)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1,{26055002,1})
		e2:SetCondition(c26055002.pcond)
		e2:SetTarget(c26055002.eqtg)
		e2:SetOperation(c26055002.eqop)
		c:RegisterEffect(e2)
		aux.AddEREquipLimit(c,nil,c26055002.eqval,c26055002.equipop,e2)
		--send self and other to GY
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_TOGRAVE)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DELAY)
		e3:SetCountLimit(1,{26055002,2})
		e3:SetCondition(c26055002.tgcond)
		e3:SetTarget(c26055002.tgtg)
		e3:SetOperation(c26055002.tgop)
		c:RegisterEffect(e3)
end
c26055002.listed_series={0x655}
function c26055002.actcon(e)
	local tp=e:GetHandlerPlayer()
	local ac,dc=Duel.GetAttacker(),Duel.GetAttackTarget()
	return ac and dc and ac:IsControler(tp)
	and ac:IsType(TYPE_PENDULUM) and ac:IsRelateToBattle()
	and Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)>0
end
function c26055002.atktg(e,c)
	local ph=Duel.GetCurrentPhase()
	if not (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) then return end
	local ac=Duel.GetAttacker()
	return ac:IsType(TYPE_PENDULUM) and ac:IsRelateToBattle()  
	and c:IsRelateToBattle() and c~=ac
	and Duel.GetMatchingGroupCount(Card.IsFacedown,e:GetHandlerPlayer(),0,LOCATION_EXTRA,nil)>0 
end
function c26055002.atkval(e,c)
	return c:GetBaseAttack()/2
end
function c26055002.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsType(TYPE_PENDULUM) then return false end
	return (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c26055002.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(26055001) and c:GetEquipTarget()
end
function c26055002.spfilter(c,e,tp)
	return c:IsSetCard(0x655) and c:IsCanBeSpecialSummoned()
end
function c26055002.pcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end
function c26055002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and c26055002.pcond(e,tp,eg,ep,ev,re,r,rp)
end
function c26055002.spfilter(c,e,sp,sc1,sc2)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
	and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c26055002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26055002.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sc1,sc2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26055002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26055002.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc1,sc2)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26055002.eqfilter(c)
	return c:IsSetCard(0x655) and c:IsType(TYPE_PENDULUM) and c:IsMonster() and c:IsFaceup() and not c:IsForbidden()
end
function c26055002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c26055002.eqfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c26055002.eqval(ec,c,tp)
	return ec:IsControler(tp) and ec:IsType(TYPE_PENDULUM)
end
function c26055002.equipop(c,e,tp,tc)
	c:EquipByEffectAndLimitRegister(e,tp,tc,nil,true)
end
function c26055002.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26055002.eqfilter,tp,LOCATION_EXTRA,0,nil)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(tc)
		c26055002.equipop(e:GetHandler(),e,tp,tc)
		tc:RegisterFlagEffect(26055001,RESET_EVENT|RESETS_STANDARD,0,1)
	end
end
function c26055002.tgcond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and not e:GetHandler():IsLocation(LOCATION_DECK) and c26055002.pcond(e,tp,eg,ep,ev,re,r,rp)
end
function c26055002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() and c:IsLocation(LOCATION_HAND|LOCATION_EXTRA) and Duel.IsExistingMatchingCard(Card.IsAbleToExtra,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),2,0,0)
end
function c26055002.ptxfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_PENDULUM ==TYPE_PENDULUM and c:IsAbleToExtra()
end
function c26055002.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToExtra,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.HintSelection(g)
	if #g>0 then
		local g1,g2=g:Split(c26055002.ptxfilter,nil)
		if #g1>0 then Duel.SendtoExtraP(g1,nil,REASON_EFFECT) end
		if #g2>0 then Duel.SendtoDeck(g2,nil,0,REASON_EFFECT) end
	end
end