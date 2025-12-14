--Tetramius Acquisos
function c26056004.initial_effect(c)
	--Special Summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:SetCountLimit(1,26056004)
	e1:SetValue(c26056004.hspval)
	c:RegisterEffect(e1)
	--Place 1 TETRAQUA Counter on field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056004,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c26056004.cttg)
	e2:SetOperation(c26056004.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
end
local COUNTER_TETRAQUA =0x1658
c26056004.counter_place_list={COUNTER_TETRAQUA }
c26056004.tetracounter=COUNTER_TETRAQUA
c26056004.tetrafilter=aux.FaceupFilter(Card.IsSetCard,0x656)
c26056004.TETRATOKEN={COUNTER_TETRAQUA,26056104}
function c26056004.hspval(e,c)
	local zone=0
	local left_right=0
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(c26056004.tetrafilter,tp,LOCATION_ONFIELD,0,nil)
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
function c26056004.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,COUNTER_TETRAQUA,1) end
end
function c26056004.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,COUNTER_TETRAQUA,1):GetFirst()
	if tc and tc:AddCounter(COUNTER_TETRAQUA,1) then
		c26056004.TETRAQUA(e,tp)
	end
end
function c26056004.TETRAQUA(e,tp)
	if Duel.GetFlagEffect(0,26056004)==0 then
		Duel.RegisterFlagEffect(0,26056004,0,0,0)
		local c=e:GetHandler()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(c26056004.ctspop)
		Duel.RegisterEffect(ge1,0)
		--prevent negate
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_CHAIN_SOLVING)
		ge2:SetCondition(c26056004.discon1)
		ge2:SetOperation(c26056004.disop)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCondition(c26056004.discon2)
		ge3:SetOperation(c26056004.disop)
		Duel.RegisterEffect(ge3,0)
		--cannot inactivate/disable
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD)
		ge4:SetCode(EFFECT_CANNOT_INACTIVATE)
		ge4:SetValue(c26056004.efilter)
		Duel.RegisterEffect(ge4,tp)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD)
		ge5:SetCode(EFFECT_CANNOT_DISEFFECT)
		ge5:SetValue(c26056004.efilter)
		Duel.RegisterEffect(ge5,tp)
		--cannot disable
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD)
		ge6:SetCode(EFFECT_CANNOT_DISABLE)
		ge6:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		ge6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge6:SetTarget(c26056004.distg)
		Duel.RegisterEffect(ge6,tp)
	end
end
function c26056004.discon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_NEGATE)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
	local tc=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):GetHandler()
	local g=Group.CreateGroup()
	if g1 then g:Merge(g1)   end; 
	if g2 then g:Merge(g2)   end; 
	if tc then g:AddCard(tc) end; 
	if #g>0 and (ex1 or ex2) then
		e:SetLabelObject(g)
		return true
	end
end
function c26056004.discon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT):GetHandler()
	if c26056004.disfilter(tc,nil) and tc:GetFlagEffect(26056004)==0 and tc:IsDisabled() then
		e:SetLabelObject(Group.FromCards(tc))
		return true
	end
end
function c26056004.disfilter(c,tp)
	if not tp then tp=c:GetControler() end
	return c:IsFaceup() and c:IsControler(tp)
	and c:IsCanRemoveCounter(tp,COUNTER_TETRAQUA,1,REASON_COST)
end
function c26056004.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local p =Duel.GetTurnPlayer()
	local op=1-p
	local g0=g:Filter(c26056004.disfilter,nil,p)
	local g1=g:Filter(c26056004.disfilter,nil,op)
	local g=Group.CreateGroup()
	c26056004.repct(e, p,g0,g)
	c26056004.repct(e,op,g1,g)
	if #g==0 then return end
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		tc:RemoveCounter(p,COUNTER_TETRAQUA,1,REASON_COST)
		tc:RegisterFlagEffect(26056004,RESET_CHAIN,0,1)
	end
end
function c26056004.efilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return tc:GetFlagEffect(26056004)>0
end
function c26056004.distg(e,c)
	return c:GetFlagEffect(26056004)>0
end
function c26056004.repct(e,p,g,sg)
	local str=aux.Stringid(26056004,2)
	if #g>0 then
		if #g>1 then
			if Duel.SelectYesNo(p,str) then
				g=g:Select(p,1,#g,nil)
			end
		elseif not Duel.SelectEffectYesNo(p,g:GetFirst(),str) then return end 
		sg:Merge(g)
	end
end
function c26056004.ctspop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		ct=tc:GetCounter(COUNTER_TETRAQUA)
		if ct>0 and tc:GetFlagEffect(26056004)==0 and tc:IsReason(REASON_MATERIAL) then
			tc:RegisterFlagEffect(26056004,RESET_EVENT|RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_BE_MATERIAL)
			e1:SetLabel(ct)
			e1:SetCondition(c26056004.efcon)
			e1:SetOperation(c26056004.efop)
			tc:RegisterEffect(e1)
		end
	end
end
function c26056004.efcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return rc:IsFaceup() and r&REASON_LINK ~=0
end
function c26056004.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	rc:AddCounter(COUNTER_TETRAQUA,e:GetLabel())
	e:Reset()
end