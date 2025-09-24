--Elegiac Fortissimo
function c26053013.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Fortissimo
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(26053013)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	--c:RegisterEffect(e2)
	--Discard to search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26053013,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,26053013)
	e3:SetTarget(c26053013.thtg)
	e3:SetOperation(c26053013.thop)
	c:RegisterEffect(e3)
	--Raise level
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26053013,1))
	e4:SetCategory(CATEGORY_LVCHANGE+CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c26053013.lvtg)
	e4:SetOperation(c26053013.lvop)
	c:RegisterEffect(e4)
	--trigger on opponent's turn
	local e3a=e3:Clone()
	e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3a:SetProperty(EFFECT_FLAG_DELAY)
	e3a:SetCode(EVENT_CUSTOM+26053013)
	e3a:SetCost(c26053013.recost)
	c:RegisterEffect(e3a)
	local e4a=e4:Clone()
	e4a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4a:SetProperty(EFFECT_FLAG_DELAY)
	e4a:SetCost(c26053013.recost)
	e4a:SetCode(EVENT_CUSTOM+26053013)
	c:RegisterEffect(e4a)
	--register
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c26053013.regop)
	c:RegisterEffect(e5)
end
c26053013.listed_series={0x653,0x1653}
function c26053013.upfilter(c,num,lv1,lv2,lv3,lv4,lv5)
	local tp=c:GetControler()
	if lv1 then return lv1>0 and c:GetLevel()==(lv1+num) end
	if lv2 then return lv2>0 and c:GetLevel()==(lv2+num) end
	if lv3 then return lv3>0 and c:GetLevel()==(lv3+num) end
	if lv4 then return lv4>0 and c:GetLevel()==(lv4+num) end
	if lv5 then return lv5>0 and c:GetLevel()==(lv5+num) end
	return false
end
function c26053013.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local phase=Duel.GetCurrentPhase()
	if chk==0 then return c:GetFlagEffect(26053013)==0
	and Duel.IsMainPhase() and Duel.GetTurnPlayer()~=tp end
	c:RegisterFlagEffect(26053013,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|phase,0,1)
end
function c26053013.thfilter(c,lv)
	return c:IsMonster() and c:IsSetCard(0x1653) and c:IsAbleToHand() 
end
function c26053013.disfilter(c)
	return c:IsMonster() and c:IsType(TYPE_RITUAL) and c:IsDiscardable()
end
function c26053013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c26053013.disfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c26053013.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
end
function c26053013.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=Duel.SelectMatchingCard(tp,c26053013.disfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)==0
	then return end 
	local lv=tc.ELEGIAC
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sc=Duel.SelectMatchingCard(tp,c26053013.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SendtoHand(sc,nil,REASON_EFFECT)~=0 then 
		Duel.ConfirmCards(1-tp,sc)
		Duel.ShuffleHand(tp)
		for i=1,5 do if lv[i] and sc:GetLevel()==lv[i] then
			Duel.Draw(tp,1,REASON_EFFECT) return end
		end
	end
end
function c26053013.lvfilter(c)
	return c:IsMonster() and (c:IsOnField()
	or c:IsSetCard(0x653) --and not c:IsPublic()
	)
end
function c26053013.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local loc=LOCATION_MZONE 
	local lab=e:GetLabel()
	if chkc then return c26053013.lvfilter(e,tp,0) and chkc:IsLocation(loc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c26053013.lvfilter,tp,loc+LOCATION_HAND,loc,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,c26053013.lvfilter,tp,loc+LOCATION_HAND,loc,1,1,nil):GetFirst()
	Duel.SetTargetCard(tc)
	if tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc) end
end
function c26053013.forte(c)
	return c:IsFaceup() and c:IsCode(26053013)
end
function c26053013.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local lv={1}
		local forte=Duel.GetMatchingGroupCount(c26053013.forte,tp,LOCATION_ONFIELD,0,nil)
		for vl=1,forte do
			lv[vl]=vl
		end
		local ct=Duel.AnnounceNumber(tp,table.unpack(lv))
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			--tc:RegisterEffect(e1)
		end
		local e3a=Effect.CreateEffect(c)
		e3a:SetType(EFFECT_TYPE_SINGLE)
		e3a:SetCode(EFFECT_UPDATE_LEVEL)
		e3a:SetReset(RESET_EVENT|(RESETS_STANDARD_PHASE_END&~RESET_TOFIELD))
		e3a:SetValue(ct)
		tc:RegisterEffect(e3a)
		local e3=e3a:Clone()
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(ct*100)
		tc:RegisterEffect(e3)
	end
end
function c26053013.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=1-Duel.GetTurnPlayer()
	local tg=eg:Filter(c26053013.regfilter,nil,e,p)
	if #tg>0 and Duel.IsMainPhase()
	and Duel.GetFlagEffect(p,26053013)==0 then
		Duel.RegisterFlagEffect(p,26053013,RESET_CHAIN,0,1)
		Duel.RaiseEvent(eg,EVENT_CUSTOM+26053013,e,0,p,p,0)
	end
end
function c26053013.regfilter(c,e,p)
	return c:IsFaceup() and c:IsMonster()
	and c:GetSummonPlayer()==Duel.GetTurnPlayer()
end