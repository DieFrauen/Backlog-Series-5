--SNI-Pyre Ace - Obendorf
function c26054009.initial_effect(c)
	c:SetUniqueOnField(1,0,26054009)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,6,2,c26054009.ovfilter,aux.Stringid(26054009,0),6,c26054009.xyzop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26054009,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	--e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetValue(c26054009.spval)
	e1:SetCondition(c26054009.selfspcon)
	e1:SetTarget(c26054009.selfsptg)
	e1:SetOperation(c26054009.selfspop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054009,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c26054009.target)
	e2:SetOperation(c26054009.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e)
		return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
	end)
	c:RegisterEffect(e3)
	--enable target protection ignore
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(26054009)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
end
c26054009.listed_series={0x654,0x1654}
c26054009.listed_names={26054003}
c26054009.material={26054003}
function c26054009.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsCode(26054003)
end
function c26054009.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.GetFlagEffect(tp,26054009)==0 end
	local mct=mc:GetOverlayGroup()
	if #mct>0 then Duel.SendtoGrave(mct,REASON_RULE) end
	Duel.RegisterFlagEffect(tp,26054009,RESET_PHASE|PHASE_END,0,1)
	return true
end
function c26054009.spval(e,c)
	return SUMMON_TYPE_XYZ,ZONES_EMZ 
end
function c26054009.selfspcostfilter(c,tp,sc)
	return c:IsCode(26054003) and c:IsCanBeXyzMaterial(sc)
	and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c26054009.selfspcon(e,c)
	if not c then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c26054009.selfspcostfilter,tp,LOCATION_HAND,0,1,nil,tp,c) and Duel.GetFlagEffect(tp,26054009)==0
end
function c26054009.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectMatchingCard(tp,c26054009.selfspcostfilter,tp,LOCATION_HAND,0,1,1,true,nil,tp,c)
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		Duel.ConfirmCards(1-tp,g)
		--Duel.ShuffleHand(tp)
		return true
	end
	return false
end
function c26054009.selfspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local c=e:GetHandler()
	if not g then return end
	Duel.Overlay(c,g)
	c:SetMaterial(g)
	Duel.ShuffleHand(tp)
	--Duel.RegisterFlagEffect(tp,26054009,RESET_PHASE|PHASE_END,0,1)
	g:DeleteGroup()
end
function c26054009.atfilter(c,tp)
	return c:IsCanBeXyzMaterial(xyzc,tp,REASON_EFFECT)
end
function c26054009.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x654)
end
function c26054009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanBeXyzMaterial,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler(),tp,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function c26054009.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanBeXyzMaterial,tp,LOCATION_GRAVE,0,1,1,nil,c,tp,REASON_EFFECT):GetFirst()
	if tc then
		Duel.HintSelection(tc)
		Duel.Overlay(c,tc)
		local g=c:GetOverlayGroup():Filter(c26054009.thfilter,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26054009,3)) then
			local tc=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end