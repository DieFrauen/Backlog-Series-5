--Tetramius Flare - Rubea
function c26056002.initial_effect(c)
	--Special Summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:SetCountLimit(1,26056002)
	e1:SetValue(c26056002.hspval)
	c:RegisterEffect(e1)
	--Place 1 Tetraflare Counter on field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056002,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c26056002.cttg)
	e2:SetOperation(c26056002.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
local COUNTER_TETRAFLARE =0x1656
c26056002.counter_place_list={COUNTER_TETRAFLARE }
c26056002.tetrafilter=aux.FaceupFilter(Card.IsSetCard,0x656)
function c26056002.hspval(e,c)
	local zone=0
	local left_right=0
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(c26056002.tetrafilter,tp,LOCATION_ONFIELD,0,nil)
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
function c26056002.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,COUNTER_TETRAFLARE,1) end
end
function c26056002.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,COUNTER_TETRAFLARE,1):GetFirst()
	if tc and tc:AddCounter(COUNTER_TETRAFLARE,1) then
		c26056002.TETRAFLARE(e,tp)
	end
end
function c26056002.TETRAFLARE(e,tp)
	if Duel.GetFlagEffect(0,26056002)==0 then
		Duel.RegisterFlagEffect(0,26056002,0,0,0)
		local c=e:GetHandler()
		--defdown
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		ge1:SetOperation(c26056002.atop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_LEAVE_FIELD_P)
		ge2:SetOperation(c26056002.ctspop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c26056002.ctspop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		ct=tc:GetCounter(COUNTER_TETRAFLARE)
		if ct>0 and tc:GetFlagEffect(26056002)==0 and tc:IsReason(REASON_MATERIAL) then
			tc:RegisterFlagEffect(26056002,RESET_EVENT|RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_BE_MATERIAL)
			e1:SetLabel(ct)
			e1:SetCondition(c26056002.efcon)
			e1:SetOperation(c26056002.efop)
			tc:RegisterEffect(e1)
		end
	end
end
function c26056002.efcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return rc:IsFaceup() and r&REASON_LINK ~=0
end
function c26056002.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	rc:AddCounter(COUNTER_TETRAFLARE,e:GetLabel())
	e:Reset()
end
function c26056002.atcon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	local ac,dc=a:GetCounter(COUNTER_TETRAFLARE),d:GetCounter(COUNTER_TETRAFLARE)
	local tc=a
	if d and ac==0 and dc>0 then tc=d end
	e:SetLabelObject(tc)
	return tc
end
function c26056002.atop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	local p=Duel.GetTurnPlayer()
	if d and d:IsControler(p) then a,d=d,a end
	if not a or not a:IsRelateToBattle() then return end
	local ac,dc=a:GetCounter(COUNTER_TETRAFLARE),d and d:GetCounter(COUNTER_TETRAFLARE)
	local av,dv=a and 1 or 0,d and 1 or 0
	local c=e:GetHandler()
	while (av>0 or dv>0) do
		if av>0 and ac>0 and Duel.SelectEffectYesNo(p,a,aux.Stringid(26056002,2)) then
			c26056002.count(e,p,a)
			ac=a:GetCounter(COUNTER_TETRAFLARE)
			av=ac>0 and dv and 1 or 0
			dv=1
		else av=0 end
		if d and dv>0 and dc>0 and Duel.SelectEffectYesNo(1-p,d,aux.Stringid(26056002,2)) then
			c26056002.count(e,1-p,d) 
			dc=d:GetCounter(COUNTER_TETRAFLARE)
			dv=dc>0 and av and 1 or 0
			av=1
		else dv=0 end
	end
end
function c26056002.count(e,p,c)
	local at={}
	local ct,c2t=c:GetCounter(0x1656),0
	local ALLCT=c26056011.ALLCOUNTERS
	if Duel.IsPlayerAffectedByEffect(p,26056011) then
		c2t=c:GetCounter(0x1657)+c:GetCounter(0x1658)
		+c:GetCounter(0x1659);
		ct=ct+c2t
	end
	for i=1,ct do at[i]=i end
	Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(26056002,3))
	local cv=Duel.AnnounceNumber(p,table.unpack(at))
	if ALLCT and c2t>0 and (ct-c2t<cv or Duel.SelectYesNo(p,aux.Stringid(26056011,1))) then
		ALLCT(e,p,c,ct,cv)
	else
		c:RemoveCounter(p,COUNTER_TETRAFLARE,cv,REASON_COST)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cv*800)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE)
	c:RegisterEffect(e1)
	Duel.AdjustInstantly(c)
end