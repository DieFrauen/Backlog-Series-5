--SNI-Pyre Ace - Chamelot
function c26054008.initial_effect(c)
	c:SetUniqueOnField(1,0,26054008)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,6,2,c26054008.ovfilter,aux.Stringid(26054008,0),6,c26054008.xyzop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26054008,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	--e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	--e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetValue(c26054008.spval)
	e1:SetCondition(c26054008.selfspcon)
	e1:SetTarget(c26054008.selfsptg)
	e1:SetOperation(c26054008.selfspop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054008,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c26054008.target)
	e2:SetOperation(c26054008.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e)
		return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
	end)
	c:RegisterEffect(e3)
	--Register a flag on monster that gets targeted
	aux.GlobalCheck(c26054008,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c26054008.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
	--enable protection
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(26054008)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTarget(c26054008.etarget)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c26054008.immval)
	--c:RegisterEffect(e5)
end
c26054008.listed_series={0x654}
c26054008.listed_names={26054002}
c26054008.material={26054002}
function c26054008.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,rp)
	local tc=g:GetFirst()
	local RESETS = RESET_EVENT+RESETS_STANDARD+RESET_CHAIN 
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(26054008+rp*100)==0 then
			if Duel.IsPlayerAffectedByEffect(rp,26054008) then
				tc:RegisterFlagEffect(26054008+rp*100,RESETS,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26054008,4)) 
			else
				tc:RegisterFlagEffect(26054008+rp*100,RESETS,0,1)
			end
		end
	end
end
function c26054008.immval(e,re)
	local c=e:GetHandler()
	if not re:IsActivated() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c)
end
function c26054008.etarget(e,c)
	local p=c:GetControler()
	return c:GetFlagEffect(26054008+(p*100))>0 
end
function c26054008.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsCode(26054002)
end
function c26054008.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.GetFlagEffect(tp,26054008)==0 end
	local mct=mc:GetOverlayGroup()
	if #mct>0 then Duel.SendtoGrave(mct,REASON_RULE) end
	--Duel.RegisterFlagEffect(tp,26054008,RESET_PHASE|PHASE_END,0,1)
	return true
end
function c26054008.spval(e,c)
	return SUMMON_TYPE_XYZ,ZONES_EMZ 
end
function c26054008.selfspcostfilter(c,tp,sc)
	return c:IsCode(26054002) and c:IsCanBeXyzMaterial(sc)
	and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c26054008.selfspcon(e,c)
	if not c then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c26054008.selfspcostfilter,tp,LOCATION_HAND,0,1,nil,tp,c) and Duel.GetFlagEffect(tp,26054008)==0
end
function c26054008.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectMatchingCard(tp,c26054008.selfspcostfilter,tp,LOCATION_HAND,0,1,1,true,nil,tp,c)
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		Duel.ConfirmCards(1-tp,g)
		--Duel.ShuffleHand(tp)
		return true
	end
	return false
end
function c26054008.selfspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local c=e:GetHandler()
	if not g then return end
	Duel.Overlay(c,g)
	c:SetMaterial(g)
	Duel.ShuffleHand(tp)
	--Duel.RegisterFlagEffect(tp,26054008,RESET_PHASE|PHASE_END,0,1)
	g:DeleteGroup()
end
function c26054008.tofilter(c)
	return c:IsSetCard(0x654) and not c:IsType(TYPE_XYZ)
	and not c:IsForbidden()
end
function c26054008.xzfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c26054008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26054008.tofilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c26054008.xzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
end
function c26054008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fg=Duel.GetMatchingGroup(c26054008.xzfilter,tp,LOCATION_MZONE,0,nil)
	local hg=Duel.GetMatchingGroup(c26054008.tofilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,nil)
	local t1,t2,ct=nil,nil,0
	while #fg>0 and #hg>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		t1=hg:Select(tp,1,1,nil)
		t2=fg:Select(tp,1,1,nil):GetFirst()
		if t2:IsPublic() then Duel.HintSelection(t1) else Duel.ConfirmCards(1-tp,t1) end
		Duel.Overlay(t2,t1)
		fg:Sub(t2);hg:Sub(t1)
		ct=ct+1
		if #fg==0 or #hg==0 or not Duel.SelectYesNo(tp,aux.Stringid(26054008,2)) then fg:Clear() end
	end
	Duel.Draw(tp,ct,REASON_EFFECT)
end