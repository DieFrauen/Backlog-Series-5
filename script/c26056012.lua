--Tetramancer's Majora
function c26056012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--enable mats from Hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_EXTRA_MATERIAL)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(1,0)
	e2:SetOperation(c26056012.extracon)
	e2:SetValue(c26056012.extraval)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c26056012.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--move towards arrow
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26056012,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c26056012.announcecost)
	e4:SetCountLimit(1,26056012)
	e4:SetTarget(c26056012.seqtg1)
	e4:SetOperation(c26056012.seqop1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c26056012.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--move towards target
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26056012,1))
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,{26056012,1})
	e6:SetCost(c26056012.announcecost)
	e6:SetTarget(c26056012.seqtg2)
	e6:SetOperation(c26056012.seqop2)
	local e7=e5:Clone()
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)
	--move off co-link
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(26056012,2))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCost(c26056012.announcecost)
	e8:SetCountLimit(1,{26056012,2})
	e8:SetCondition(c26056012.seqcon3)
	e8:SetTarget(c26056012.seqtg3)
	e8:SetOperation(c26056012.seqop3)
	local e9=e5:Clone()
	e9:SetLabelObject(e8)
	c:RegisterEffect(e9)
end
c26056012.listed_series={0x656}
function c26056012.linkfilter(c)
	return c:IsCanBeLinkMaterial() and c:IsLocation(LOCATION_HAND)
end
function c26056012.extracon(c,e,tp,sg,mg,lc,og,chk)
	if not c26056012.curgroup then return true end
	local g=c26056012.curgroup:Filter(Card.IsLocation,nil,LOCATION_HAND)
	return #(sg&g)<2
end
function c26056012.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or not (sc and sc:IsSetCard(0x656)) or sc~=e:GetHandler()  then
			return Group.CreateGroup()
		else
			c26056012.curgroup=Duel.GetMatchingGroup(c26056012.linkfilter,tp,LOCATION_HAND,0,nil)
			c26056012.curgroup:KeepAlive()
			return c26056012.curgroup
		end
	elseif chk==2 then
		if c26056012.curgroup then
			c26056012.curgroup:DeleteGroup()
		end
		c26056012.curgroup=nil
	end
end
function c26056012.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x656) --and c:GetSequence()<5 and g:IsContains(c)
end
function c26056012.announcecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26056012)==0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:RegisterFlagEffect(26056012,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26056012,3)) 
	--Cannot be used as link material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3312)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	e1:SetReset(RESETS_STANDARD_PHASE_END)
	c:RegisterEffect(e1)
end
function c26056012.remct(e,p,c,chk)
	local b1=c:IsCanRemoveCounter(p,0x1656,1,REASON_EFFECT)
	local b2=c:IsCanRemoveCounter(p,0x1657,1,REASON_EFFECT)
	local b3=c:IsCanRemoveCounter(p,0x1658,1,REASON_EFFECT)
	local b4=c:IsCanRemoveCounter(p,0x1659,1,REASON_EFFECT)
	if chk==0 then return b1 or b2 or b3 or b4 end
	Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(26056012,4))
	local op=Duel.SelectEffect(p,
		{b1,aux.Stringid(26056012,6)},
		{b2,aux.Stringid(26056012,7)},
		{b3,aux.Stringid(26056012,8)},
		{b4,aux.Stringid(26056012,9)})
	local ct=op>0 and 0x1655+op
	c:RemoveCounter(p,ct,1,REASON_EFFECT)
end
function c26056012.seqtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone()&0x1f
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0 and c26056012.remct(e,tp,c,0) end
end
function c26056012.seqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone=c:GetLinkedZone()&0x1f
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0 and c26056012.remct(e,tp,c,0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local nseq=math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~zone),2)
		c26056012.remct(e,tp,c,1)
		Duel.MoveSequence(c,nseq)
	end
end
function c26056012.seqfilter(c,tc,tp)
	local b1,b2,b3,b4=c26056012.sortct(e,tp,tc,c)
	local zone=c26056012.zone(tp,tc,c)
	return zone and c:GetSequence()<5 and tc:IsType(TYPE_LINK) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0 and (b1 or b2 or b3 or b4)
end
function c26056012.seqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26056012.seqfilter(chkc,c,tp) end
	if chk==0 then return Duel.IsExistingTarget(c26056012.seqfilter,tp,LOCATION_MZONE,0,1,c,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c26056012.seqfilter,tp,LOCATION_MZONE,0,1,1,c,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,0)
end
function c26056012.seqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsControler(tp)
	and tc:IsRelateToEffect(e) and tc:IsControler(tp) then 
		local zone=c26056012.zone(tp,c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		Duel.MoveSequence(c,math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0x1f&~(zone)),2))
		local b1,b2,b3,b4=c26056012.sortct(e,tp,c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26056012,5))
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(26056012,6)},
			{b2,aux.Stringid(26056012,7)},
			{b3,aux.Stringid(26056012,8)},
			{b4,aux.Stringid(26056012,9)})
		local ct=op>0 and 0x1655+op
		c:RemoveCounter(tp,ct,1,REASON_EFFECT)
		tc:AddCounter(ct,1)
	end
end
function c26056012.sortct(e,p,ac,rc)
	local b1=ac:IsCanRemoveCounter(p,0x1656,1,REASON_EFFECT)
	and rc:IsCanAddCounter(0x1656,1)
	local b2=ac:IsCanRemoveCounter(p,0x1657,1,REASON_EFFECT)
	and rc:IsCanAddCounter(0x1657,1)
	local b3=ac:IsCanRemoveCounter(p,0x1658,1,REASON_EFFECT)
	and rc:IsCanAddCounter(0x1658,1)
	local b4=ac:IsCanRemoveCounter(p,0x1659,1,REASON_EFFECT)
	and rc:IsCanAddCounter(0x1659,1)
	return b1,b2,b3,b4
end
function c26056012.zone(tp,c,tc)
	local left,right=
	c:IsLinkMarker(LINK_MARKER_RIGHT) and 1 or 0,
	c:IsLinkMarker(LINK_MARKER_LEFT) and 1 or 0
	local zone=tc:GetColumnZone(LOCATION_MZONE,left,right)-tc:GetColumnZone(LOCATION_MZONE,0,0)
	return zone&ZONES_MMZ
end
function c26056012.seqcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c26056012.seqtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckAdjacent() end
end
function c26056012.seqop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local seq=c:SelectAdjacent()
	if Duel.CheckLocation(tp,LOCATION_MZONE,seq) then Duel.MoveSequence(c,seq) end
end