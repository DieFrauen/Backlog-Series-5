--Sem Vystrelok, the Peerless
function c26054010.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon
	Xyz.AddProcedure(c,nil,7,3,c26054010.ovfilter,aux.Stringid(26054010,0))
	--Unaffected by your activated effects, unless they target this card
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c26054010.immval)
	c:RegisterEffect(e2)
	--dice reroll
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TOSS_DICE_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c26054010.recond)
	e3:SetOperation(c26054010.diceop)
	c:RegisterEffect(e3)
	--coin retoss
	local e4=e3:Clone()
	e4:SetCode(EVENT_TOSS_COIN_NEGATE)
	e4:SetOperation(c26054010.coinop)
	c:RegisterEffect(e4)
	--Register a flag on monster that gets targeted
	aux.GlobalCheck(c26054010,function()
		c26054010[0]=Group.CreateGroup()
		c26054010[0]:KeepAlive()
		c26054010[1]=Group.CreateGroup()
		c26054010[1]:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c26054010.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(c26054010.clearop)
		Duel.RegisterEffect(ge2,0)
		
	end)
	--prevent targets from triggering
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(26054010)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetValue(c26054010.actlimval)
	c:RegisterEffect(e6)
end
c26054010.listed_series={0x654,0x1654}
function c26054010.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsSetCard(0x654) and not Duel.IsPlayerAffectedByEffect(rp,26054010) then return end
	local RESETS = RESET_EVENT+RESETS_STANDARD+RESET_CHAIN 
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		c26054010[rp]:AddCard(tc)
		if tc:IsOnField() and Duel.IsPlayerAffectedByEffect(rp,26054010) then
			tc:RegisterFlagEffect(26054010,RESETS,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26054010,4))
		end
	end
end
function c26054010.clearop(e,tp,eg,ep,ev,re,r,rp)
	c26054010[0]:Clear()
	c26054010[1]:Clear()
end
function c26054010.actlimval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsOnField()
	and c26054010[e:GetHandlerPlayer()]:IsContains(rc)
end
function c26054010.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsRank(6) and c:GetOverlayCount()+c:GetCounter(0x1654)>5
end
function c26054010.xyzop(e,tp,chk,mc)
	if chk==0 then return mc:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	mc:RemoveOverlayCard(tp,1,1,REASON_COST)
	return true
end
function c26054010.immval(e,re)
	local c=e:GetHandler()
	if not re:IsActivated() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c)
end
function c26054010.recond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and c:GetFlagEffect(26054010)==0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c26054010.diceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(tp,26054010)~=0 then return end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(26054010,1)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		Duel.Hint(HINT_CARD,tp,26054010)
		c:RegisterFlagEffect(26054006,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26054010,3)) 
		local ct1=(ev&0xff)
		local ct2=(ev>>16)
		Duel.TossDice(ep,ct1,ct2)
	end
end
function c26054010.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(tp,26054010)~=0 then return end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(26054010,2)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		Duel.Hint(HINT_CARD,tp,26054010)
		c:RegisterFlagEffect(26054006,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26054010,3)) 
		Duel.TossCoin(tp,ev)
	end
end