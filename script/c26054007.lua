--SNI-Pyre Ace - Mosin
function c26054007.initial_effect(c)
	c:SetUniqueOnField(1,0,26054007)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,6,2,c26054007.ovfilter,aux.Stringid(26054007,0),6,c26054007.xyzop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26054007,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	--e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetValue(c26054007.spval)
	e1:SetCondition(c26054007.selfspcon)
	e1:SetTarget(c26054007.selfsptg)
	e1:SetOperation(c26054007.selfspop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054007,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c26054007.target)
	e2:SetOperation(c26054007.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e)
		return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
	end)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c26054007.damage)
	c:RegisterEffect(e4)
end
c26054007.listed_series={0x654}
c26054007.listed_names={26054001}
c26054007.material={26054001}
function c26054007.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsCode(26054001)
end
function c26054007.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.GetFlagEffect(tp,26054007)==0 end
	local mct=mc:GetOverlayGroup()
	if #mct>0 then Duel.SendtoGrave(mct,REASON_RULE) end
	Duel.RegisterFlagEffect(tp,26054007,RESET_PHASE|PHASE_END,0,1)
	return true
end
function c26054007.spval(e,c)
	return SUMMON_TYPE_XYZ,ZONES_EMZ 
end
function c26054007.selfspcostfilter(c,tp,sc)
	return c:IsCode(26054001) and c:IsCanBeXyzMaterial(sc)
	and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c26054007.selfspcon(e,c)
	if not c then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c26054007.selfspcostfilter,tp,LOCATION_HAND,0,1,nil,tp,c) and Duel.GetFlagEffect(tp,26054007)==0
end
function c26054007.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectMatchingCard(tp,c26054007.selfspcostfilter,tp,LOCATION_HAND,0,1,1,true,nil,tp,c)
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		Duel.ConfirmCards(1-tp,g)
		--Duel.ShuffleHand(tp)
		return true
	end
	return false
end
function c26054007.selfspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local c=e:GetHandler()
	if not g then return end
	Duel.Overlay(c,g)
	c:SetMaterial(g)
	Duel.ShuffleHand(tp)
	--Duel.RegisterFlagEffect(tp,26054007,RESET_PHASE|PHASE_END,0,1)
	g:DeleteGroup()
end
function c26054007.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x654)
end
function c26054007.tdfilter(c)
	return c:IsSetCard(0x654) and not c:IsForbidden()
end
function c26054007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26054007.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE|LOCATION_DECK)
end
function c26054007.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c26054007.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		if not c:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
		local tg=Duel.SelectMatchingCard(tp,c26054007.tdfilter,tp,LOCATION_HAND,0,1,2,nil)
		if #tg>0 then Duel.Overlay(c,tg) end
	end
end
function c26054007.damage(e,tp,eg,ep,ev,re,r,rp)
	local te,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not tg or #tg==0 then return end
	tg=tg:Filter(Card.IsRelateToEffect,nil,te)
	local tv=#tg*100
	if tv>0 then
		Duel.Hint(HINT_CARD,1-tp,26054007)
		Duel.Damage(1-tp,tv,REASON_EFFECT)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tv)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end

function c26054007.chainsolvedop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(id+1)
	if ct>0 then
		Duel.Hint(HINT_CARD,1-tp,26054007)
		Duel.Damage(1-tp,ct*100,REASON_EFFECT)
		e:GetHandler():ResetFlagEffect(26054007)
	end
end