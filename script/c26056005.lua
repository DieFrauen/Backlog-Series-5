--Tetramius Alba
function c26056005.initial_effect(c)
	--Special Summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:SetCountLimit(1,26056005)
	e1:SetValue(c26056005.hspval)
	c:RegisterEffect(e1)
	--Place 1 TETRAIR Counter on field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056005,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c26056005.cttg)
	e2:SetOperation(c26056005.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)	
end
local COUNTER_TETRAIR =0x1659
c26056005.counter_place_list={COUNTER_TETRAIR }
c26056005.tetrafilter=aux.FaceupFilter(Card.IsSetCard,0x656)
c26056005.TETRATOKEN={COUNTER_TETRAIR,26056105}
function c26056005.hspval(e,c)
	local zone=0
	local left_right=0
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(c26056005.tetrafilter,tp,LOCATION_ONFIELD,0,nil)
	if c:IsLocation(LOCATION_HAND) then
		for tc in lg:Iter() do
			left_right=tc:IsInMainMZone() and 1 or 0
			zone=(zone|tc:GetColumnZone(LOCATION_MZONE,left_right,left_right,tp))
		end
	end
	--if c:IsLocation(LOCATION_GRAVE) then
		zone=(zone|aux.GetMMZonesPointedTo(c:GetControler(),Card.IsSetCard,nil,nil,nil,0x656))
	--end
	return 0,zone&ZONES_MMZ
end
function c26056005.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,COUNTER_TETRAIR,1) end
end
function c26056005.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,COUNTER_TETRAIR,1):GetFirst()
	if tc and tc:AddCounter(COUNTER_TETRAIR,1) then
		c26056005.TETRAIR(e,tp)
	end
end
function c26056005.TETRAIR(e,tp)
	if Duel.GetFlagEffect(0,26056005)==0 then
		Duel.RegisterFlagEffect(0,26056005,0,0,0)
		local c=e:GetHandler()
		--negate targeting
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetProperty(EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL)
		ge1:SetCondition(c26056005.discon)
		ge1:SetOperation(c26056005.disop)
		Duel.RegisterEffect(ge1,0)
		local ge0=ge1:Clone()
		Duel.RegisterEffect(ge0,1)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge2:SetProperty(EFFECT_FLAG_DELAY)
		ge2:SetOperation(c26056005.atop)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCondition(c26056005.atcon)
		ge3:SetCode(EVENT_ADD_COUNTER+0x1659)
		Duel.RegisterEffect(ge3,1)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge4:SetCode(EVENT_LEAVE_FIELD_P)
		ge4:SetOperation(c26056005.ctspop)
		Duel.RegisterEffect(ge4,0)
	end
end
function c26056005.cfilter(c,tp,rp)
	if not tp then tp=c:GetControler() end
	return c:IsFaceup() and c:IsControler(tp) and c:IsCanRemoveCounter(tp,COUNTER_TETRAIR,1,REASON_COST)
end
function c26056005.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and g and g:IsExists(c26056005.cfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c26056005.disop(e,tp,eg,ep,ev,re,r,rp)
	local str=aux.Stringid(26056005,2)
	local eg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local p=1-rp
	local g=eg:Filter(c26056005.cfilter,nil,p)
	local tc=g:GetFirst()
	if #g>0 then
		if #eg>1 then
			if Duel.SelectYesNo(p,str) then
				tc=g:Select(p,1,1,nil):GetFirst()
			end
		elseif Duel.SelectEffectYesNo(p,g:GetFirst(),str) then 
			tc=g:GetFirst()
		else tc=nil end
		if tc and tc:RemoveCounter(p,COUNTER_TETRAIR,1,REASON_COST)~=0 then
			Duel.Hint(HINT_CARD,rp,26056005)
			Duel.NegateEffect(ev)
		end
	end
end
function c26056005.atcon(e,tp,eg,ep,ev,re,r,rp)
	local r1,g1,p1,ev,re,r,rp=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE,true)
	return r1
end
function c26056005.atop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a and a:IsStatus(STATUS_ATTACK_CANCELED) then return end
	local d=Duel.GetAttackTarget()
	if not d then return end
	local dp=d:GetControler()
	if d and d:IsCanRemoveCounter(tp,COUNTER_TETRAIR,1,REASON_COST) and Duel.SelectEffectYesNo(dp,d,aux.Stringid(26056005,3)) then
		d:RemoveCounter(dp,COUNTER_TETRAIR,1,REASON_COST)
		Duel.Hint(HINT_CARD,0,26056005)
		Duel.NegateAttack()
	end
end
function c26056005.ctspop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		ct=tc:GetCounter(COUNTER_TETRAIR)
		if ct>0 and tc:GetFlagEffect(26056005)==0 and tc:IsReason(REASON_MATERIAL) then
			tc:RegisterFlagEffect(26056005,RESET_EVENT|RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_BE_MATERIAL)
			e1:SetLabel(ct)
			e1:SetCondition(c26056005.efcon)
			e1:SetOperation(c26056005.efop)
			tc:RegisterEffect(e1)
		end
	end
end
function c26056005.efcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return rc:IsFaceup() and r&REASON_LINK ~=0
end
function c26056005.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	rc:AddCounter(COUNTER_TETRAIR,e:GetLabel())
	e:Reset()
end