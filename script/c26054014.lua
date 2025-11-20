--Cross SNI-Pyre
function c26054014.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26054014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c26054014.condition)
	e1:SetTarget(c26054014.target)
	e1:SetOperation(c26054014.activate)
	c:RegisterEffect(e1)
	--Can be activated from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054014,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c26054014.handcon)
	c:RegisterEffect(e2)
end
c26054014.listed_series={0x654}
function c26054014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase() or Duel.IsMainPhase()
end
function c26054014.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase() and Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c26054014.spfilter(c,e,tp)
	return c:IsSetCard(0x654) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26054014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c end
	local ct1=Duel.GetMatchingGroupCount(c26054014.spfilter,tp,LOCATION_OVERLAY,0,c,e,tp)
	local ct2=Duel.GetMatchingGroupCount(c26054014.spfilter,tp,LOCATION_HAND|LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return ct1>0 or (ct2>0 and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,c)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,0,7,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_GRAVE|LOCATION_OVERLAY)
end
function c26054014.rescon(ct)
	return function(sg,e,tp,mg)
		local count=sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND|LOCATION_GRAVE)
		return count<=ct,count>ct
	end
end
function c26054014.xfilter(c,g)
	return c:IsSetCard(0x654) and c:IsType(TYPE_XYZ) and c:IsFaceup()  and c:GetSequence()>4 and g:IsExists(Card.IsCanBeXyzMaterial,1,c,c)
end
function c26054014.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e)
	local ct=#tg
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local g1=Duel.GetOverlayGroup(tp,1,0):Filter(c26054014.spfilter,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c26054014.spfilter,tp,LOCATION_HAND|LOCATION_GRAVE,0,nil,e,tp)
	local rg=g1+g2
	ft=math.min(ft,#rg)
	local sg=aux.SelectUnselectGroup(rg,e,tp,1,ft,c26054014.rescon(ct),1,tp,HINTMSG_SPSUMMON,c26054014.rescon(ct))
	if #sg>0 then
		local tc=sg:GetFirst()
		for tc in aux.Next(sg) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_DAMAGE_STEP_END)
			e1:SetCountLimit(1)
			e1:SetLabelObject(tc)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			e1:SetCondition(c26054014.descon)
			e1:SetOperation(c26054014.desop)
			Duel.RegisterEffect(e1,tp)
			tc:RegisterFlagEffect(26054114,RESET_PHASE|PHASE_BATTLE,0,1)
		end
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		if Duel.GetTurnPlayer()~=tp and Duel.IsBattlePhase() then
			local THIS_PHASE =RESET_PHASE|PHASE_BATTLE
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_MUST_ATTACK)
			e2:SetTargetRange(0,LOCATION_MZONE)
			e2:SetLabelObject(sg)
			e2:SetCondition(function(e) return Duel.IsExistingMatchingCard(c26054014.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) end)
			e2:SetReset(THIS_PHASE)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(0,1)
			e3:SetCondition(function(e) return Duel.IsExistingMatchingCard(c26054014.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) end)
			e3:SetReset(THIS_PHASE)
			Duel.RegisterEffect(e3,tp)
		end
		--Destroy them during the End Phase
		aux.DelayedOperation(sg,PHASE_END,26054014,e,tp,
		function(ag)
			local tc=Duel.GetFirstMatchingCard(c26054014.xfilter,tp,LOCATION_MZONE,0,nil,ag)
			if tc and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(26054014,3)) then
				local og=ag:Filter(Card.IsCanBeXyzMaterial,nil,tc)
				if #og>0 then
					Duel.Overlay(tc,og)
					ag:Sub(og)
				end
			end
			Duel.Destroy(ag,REASON_EFFECT)
		end
		,nil,0,0,aux.Stringid(26054014,2))
	end
end
function c26054014.atfilter(c)
	local g=e:GetLabelObject()
	return g:iscontains(c) and c:IsOnField()
end
function c26054014.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:HasFlagEffect(26054014) and tc:IsRelateToBattle() and tc:IsFaceup()
end
function c26054014.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end