--Etherweight Almace
function c26055005.initial_effect(c)
	--pendulum effect
		Pendulum.AddProcedure(c)
		--destroy replace
		local pe1=Effect.CreateEffect(c)
		pe1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		pe1:SetCode(EFFECT_DESTROY_REPLACE)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetTarget(c26055005.reptg)
		pe1:SetValue(c26055005.repval)
		pe1:SetOperation(c26055005.repop)
		c:RegisterEffect(pe1)
	--equip effect (equipped by an "Etherweight" card effect)
		--atk up
		local eq1=Effect.CreateEffect(c)
		eq1:SetType(EFFECT_TYPE_EQUIP)
		eq1:SetCode(EFFECT_UPDATE_ATTACK)
		eq1:SetCondition(c26055005.eqcon)
		eq1:SetValue(600)
		c:RegisterEffect(eq1)
		--destroy replace
		eq2=pe1:Clone()
		eq2:SetRange(LOCATION_SZONE)
		eq2:SetCondition(c26055005.eqcon)
		c:RegisterEffect(eq2)
	--Monster Effect
		--add "Etherweight" card(s) to Hand
		local e1a=Effect.CreateEffect(c)
		e1a:SetDescription(aux.Stringid(26055005,0))
		e1a:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1a:SetProperty(EFFECT_FLAG_DELAY)
		e1a:SetCode(EVENT_SUMMON_SUCCESS)
		e1a:SetCountLimit(1,26055005)
		e1a:SetTarget(c26055005.thtg)
		e1a:SetOperation(c26055005.thop)
		c:RegisterEffect(e1a)
		local e1b=e1a:Clone()
		e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(e1b)
		local e1c=e1a:Clone()
		e1c:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e1c)
		--place scales
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26055005,1))
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCountLimit(1,{26055005,1})
		e2:SetTarget(c26055005.tptg)
		e2:SetOperation(c26055005.tpop)
		c:RegisterEffect(e2)
end
function c26055005.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(26055001) and c:GetEquipTarget()
end
function c26055005.repcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsOddScale),e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil)
end
function c26055005.repfilter(c,tp)
	return c:IsFaceup() and c:IsOriginalType(TYPE_PENDULUM) and c:IsOriginalType(TYPE_MONSTER) and c:IsOnField()
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_REPLACE)
end
function c26055005.orepfilter(c,e,tp)
	return c:IsFaceup() and c:IsOriginalType(TYPE_PENDULUM) and c:IsOriginalType(TYPE_MONSTER) and c:IsDestructable() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
	and (c:IsLocation(LOCATION_PZONE) or e:GetHandler()==c)
end
function c26055005.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(c26055005.orepfilter,tp,LOCATION_ONFIELD,0,nil,e,tp)
	dg:AddCard(c)
	dg:Sub(eg)
	if chk==0 then
		return #dg>0 and eg:IsExists(c26055005.repfilter,1,nil,tp)
	end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(26055005,1)) then
		local g=eg:Filter(c26055005.repfilter,nil,tp)
		if #g==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,#dg,nil)
			cg:KeepAlive()
			e:SetLabelObject(cg)
			Duel.HintSelection(cg)
		end
		return true
	else return false end
end
function c26055005.repval(e,c)
	return c:IsFaceup() and Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0):IsContains(c) and c:IsType(TYPE_PENDULUM)
end
function c26055005.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=e:GetLabelObject()
	if not cg or cg==0 then return end
	local dg=Duel.GetMatchingGroup(c26055005.orepfilter,tp,LOCATION_ONFIELD,0,nil,e,tp)
	dg:AddCard(c)
	dg:Sub(cg)
	local sg=dg:Clone()
	if #dg<#cg then
		sg=dg:Select(tp,#cg,#cg,nil)
	end
	local sc=dg:GetFirst()
	for sc in aux.Next(sg) do
		sc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	end
	Duel.Destroy(sg,REASON_EFFECT|REASON_REPLACE)
end
function c26055005.thfilter(c)
	return c:IsSetCard(0x655) and c:IsMonster() and not c:IsCode(26055005) and c:IsAbleToHand()
end
function c26055005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26055005.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c26055005.thop(e,tp,eg,ep,ev,re,r,rp)
	local xg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	local sg=Duel.SelectMatchingCard(tp,c26055005.thfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not sc then return end
	aux.ToHandOrElse(sc,tp,
		function() return sc:IsAbleToExtraP() end,
		function() Duel.SendtoExtraP(sc,tp,REASON_EFFECT) end,
		aux.Stringid(26055005,2)
	)
end
function c26055005.pcfilter(c)
	return c:IsSetCard(0x655) and c:IsType(TYPE_PENDULUM)   
	and c:IsFaceup() and not c:IsForbidden()
end
function c26055005.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) and Duel.IsExistingMatchingCard(c26055005.pcfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function c26055005.tpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26055005.pcfilter,tp,LOCATION_GRAVE,0,nil)
	if Duel.CheckPendulumZones(tp) and #g>0 then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false)~=0 then
			g:Sub(tc)
			local xg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
			if Duel.CheckPendulumZones(tp) and #g>0 and #xg==0 then
				local tc2=g:Select(tp,0,1,nil):GetFirst()
				if tc2 and Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false)~=0  then
					tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
				end
			end
		end
		tc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end