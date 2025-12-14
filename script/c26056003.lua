--Tetramius Mold - Amnisos
function c26056003.initial_effect(c)
	--Special Summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:SetCountLimit(1,26056003)
	e1:SetValue(c26056003.hspval)
	c:RegisterEffect(e1)
	--Place 1 TETRALAND Counter on field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056003,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c26056003.cttg)
	e2:SetOperation(c26056003.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
end
local COUNTER_TETRALAND =0x1657
c26056003.counter_place_list={COUNTER_TETRALAND }
c26056003.tetrafilter=aux.FaceupFilter(Card.IsSetCard,0x656)
function c26056003.hspval(e,c)
	local zone=0
	local left_right=0
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(c26056003.tetrafilter,tp,LOCATION_ONFIELD,0,nil)
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
function c26056003.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,COUNTER_TETRALAND,1) end
end
function c26056003.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,COUNTER_TETRALAND,1):GetFirst()
	if tc and tc:AddCounter(COUNTER_TETRALAND,1) then
		c26056003.TETRALAND(e,tp)
	end
end
function c26056003.TETRALAND(e,tp)
	if Duel.GetFlagEffect(0,26056003)==0 then
		Duel.RegisterFlagEffect(0,26056003,0,0,0)
		local c=e:GetHandler()
		--destroy replace
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_DESTROY_REPLACE)
		ge1:SetValue(c26056003.repval)
		ge1:SetTarget(c26056003.reptg)
		ge1:SetOperation(c26056003.repop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_LEAVE_FIELD_P)
		ge2:SetOperation(c26056003.ctspop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c26056003.repfilter(c,tp)
	if not tp then tp=c:GetControler() end
	return c:IsFaceup() and c:IsControler(tp) and not c:IsReason(REASON_REPLACE) and c:IsCanRemoveCounter(tp,COUNTER_TETRALAND,1,REASON_COST)
end
function c26056003.repval(e,c)
	local lab=e:GetLabelObject()
	if lab then return lab:IsContains(c) end
	return c26056003.repfilter(c,c:GetControler())
end
function c26056003.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c26056003.repfilter,1,nil,nil) end
	local p,op=Duel.GetTurnPlayer()
	local op=1-p
	local g0=eg:Filter(c26056003.repfilter,nil,p)
	local g1=eg:Filter(c26056003.repfilter,nil,op)
	local g=Group.CreateGroup()
	c26056003.repct(e, p,g0,g)
	c26056003.repct(e,op,g1,g)
	if #g>0 then
		e:SetLabelObject(g)
		g:KeepAlive()
		return true
	else return false end
end
function c26056003.repct(e,p,g,sg)
	local str=aux.Stringid(26056003,2)
	if #g>0 then
		if #g>1 then
			if Duel.SelectYesNo(p,str) then
				g=g:Select(p,1,#g,nil)
			end
		elseif not Duel.SelectEffectYesNo(p,g:GetFirst(),str) then return end 
		sg:Merge(g)
	end
end
function c26056003.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in g:Iter() do
		local p=tc:GetControler()
		tc:RemoveCounter(p,COUNTER_TETRALAND,1,REASON_COST)
	end
	g:DeleteGroup()
end
function c26056003.ctspop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		ct=tc:GetCounter(COUNTER_TETRALAND)
		if ct>0 and tc:GetFlagEffect(26056003)==0 and tc:IsReason(REASON_MATERIAL) then
			tc:RegisterFlagEffect(26056003,RESET_EVENT|RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_BE_MATERIAL)
			e1:SetLabel(ct)
			e1:SetCondition(c26056003.efcon)
			e1:SetOperation(c26056003.efop)
			tc:RegisterEffect(e1)
		end
	end
end
function c26056003.efcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return rc:IsFaceup() and r&REASON_LINK ~=0
end
function c26056003.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	rc:AddCounter(COUNTER_TETRALAND,e:GetLabel())
	e:Reset()
end