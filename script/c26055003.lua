--Etherweight Durandal
function c26055003.initial_effect(c)
	--Pendulum Effect
		Pendulum.AddProcedure(c)
		--splimit
		local pe1=Effect.CreateEffect(c)
		pe1:SetType(EFFECT_TYPE_FIELD)
		pe1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CANNOT_NEGATE)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetTargetRange(1,0)
		pe1:SetTarget(c26055003.splimit)
		c:RegisterEffect(pe1)
		--pierce
		local pe2=Effect.CreateEffect(c)
		pe2:SetType(EFFECT_TYPE_FIELD)
		pe2:SetCode(EFFECT_PIERCE)
		pe2:SetRange(LOCATION_PZONE)
		pe2:SetTargetRange(LOCATION_MZONE,0)
		pe2:SetTarget(function(e,c) return c:IsType(TYPE_PENDULUM) end)
		c:RegisterEffect(pe2)
		--Double damage
		local pe3=Effect.CreateEffect(c)
		pe3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		pe3:SetRange(LOCATION_PZONE)
		pe3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		pe3:SetCondition(c26055003.rdcon)
		pe3:SetOperation(c26055003.rdop)
		c:RegisterEffect(pe3)
	--equip effect (equipped by an "Etherweight" card effect)
		--atk up
		local eq1=Effect.CreateEffect(c)
		eq1:SetType(EFFECT_TYPE_EQUIP)
		eq1:SetCode(EFFECT_UPDATE_ATTACK)
		eq1:SetCondition(c26055003.eqcon)
		eq1:SetValue(800)
		c:RegisterEffect(eq1)
		--piercing
		eq2=pe2:Clone()
		eq2:SetRange(LOCATION_SZONE)
		eq2:SetCondition(c26055003.eqcon)
		c:RegisterEffect(eq2)
		--double damage
		eq3=pe3:Clone()
		eq3:SetRange(LOCATION_SZONE)
		eq3:SetCondition(aux.AND(c26055003.eqcon,c26055003.rdcon))
		c:RegisterEffect(eq3)
	--Monster Effect
		--Special Summon "Etherweight" from gy
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26055003,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1,26055003)
		e1:SetCondition(c26055003.spcon)
		e1:SetTarget(c26055003.sptg)
		e1:SetOperation(c26055003.spop)
		c:RegisterEffect(e1)
		--Equip 1 "Etherweight" monster to itself
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26055003,1))
		e2:SetCategory(CATEGORY_EQUIP)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1,{26055003,1})
		e2:SetCondition(c26055003.pcond)
		e2:SetTarget(c26055003.eqtg)
		e2:SetOperation(c26055003.eqop)
		c:RegisterEffect(e2)
		aux.AddEREquipLimit(c,nil,c26055003.eqval,c26055003.equipop,e2)
		--send self and other to GY
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_TOGRAVE)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DELAY)
		e3:SetCountLimit(1,{26055003,2})
		e3:SetCondition(c26055003.tgcond)
		e3:SetTarget(c26055003.tgtg)
		e3:SetOperation(c26055003.tgop)
		c:RegisterEffect(e3)
end
c26055003.listed_series={0x655}
function c26055003.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsType(TYPE_PENDULUM) then return false end
	return (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c26055003.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(26055001) and c:GetEquipTarget()
end
function c26055003.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	if not (a and d) then return false end
	if d:IsControler(tp) then a,d=d,a end
	local lac,ldc=a:GetSummonLocation(),d:GetSummonLocation()
	local val=1
	if lac==ldc and lac&LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK|LOCATION_EXTRA ~=0 then val=2 end
	e:SetLabel(val)
	return a:IsType(TYPE_PENDULUM) and ev>0 and (e:GetLabel()==1 or c26055003.eqcon(e,tp,eg,ep,ev,re,r,rp))
end
function c26055003.rdop(e,tp,eg,ep,ev,re,r,rp)
	local lb=e:GetLabel()
	if lb>1 then
		Duel.ChangeBattleDamage(ep,ev*lb)
		Duel.Hint(HINT_CARD,tp,26055003)
	end
end
function c26055003.spfilter(c,e,tp)
	return c:IsSetCard(0x655) and c:IsCanBeSpecialSummoned()
end

function c26055003.pcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end
function c26055003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and c26055003.pcond(e,tp,eg,ep,ev,re,r,rp)
end
function c26055003.scales(e,tp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local sc1,sc2=0,0
	if tc1 and tc2 then
		sc1=tc1:GetLeftScale()
		sc2=tc2:GetRightScale()
	end
	if sc1>sc2 then sc1,sc2=sc2,sc1 end
	return sc1 and sc2
end
function c26055003.spfilter(c,e,sp,sc1,sc2)
	if not (c:IsSetCard(0x655) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)) then return false end
	local a=Duel.GetAttacker()
	return (a and c:GetLevel()>=a:GetLevel()) or
	(sc1 and sc2 and c:GetLevel()>sc1 and c:GetLevel()<sc2)
end
function c26055003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc1,sc2=c26055003.scales(e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26055003.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,sc1,sc2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c26055003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc1,sc2=c26055003.scales(e,tp)
	local g=Duel.SelectMatchingCard(tp,c26055003.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,sc1,sc2)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26055003.eqfilter(c)
	return c:IsSetCard(0x655) and c:IsType(TYPE_PENDULUM) and c:IsMonster() and not c:IsForbidden()
end
function c26055003.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c26055003.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c26055003.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c26055003.eqval(ec,c,tp)
	return ec:IsControler(tp) and ec:IsSetCard(0x655)
end
function c26055003.equipop(c,e,tp,tc)
	c:EquipByEffectAndLimitRegister(e,tp,tc,nil,true)
end
function c26055003.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		c26055003.equipop(c,e,tp,tc)
		tc:RegisterFlagEffect(26055001,RESET_EVENT|RESETS_STANDARD,0,1)
	end
end
function c26055003.tgcond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and not e:GetHandler():IsLocation(LOCATION_DECK) and c26055003.pcond(e,tp,eg,ep,ev,re,r,rp)
end
function c26055003.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() and c:IsLocation(LOCATION_HAND|LOCATION_EXTRA) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),2,0,0)
end
function c26055003.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.HintSelection(g)
	g:AddCard(c)
	Duel.ConfirmCards(1-tp,c)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end