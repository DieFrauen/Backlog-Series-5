--Tetramius Cauda
function c26056015.initial_effect(c)
	--Extra Material (thx edo9300)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_EXTRA_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetOperation(c26056015.extracon)
	e0:SetValue(c26056015.extraval)
	c:RegisterEffect(e0)
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetCode(EFFECT_ADD_TYPE)
	e0a:SetRange(LOCATION_SZONE)
	e0a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0a:SetCondition(c26056015.addtypecon)
	e0a:SetValue(TYPE_MONSTER)
	c:RegisterEffect(e0a)
	--Activate
	local e0b=Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_SINGLE)
	e0b:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0b:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DELAY)
	e0b:SetCondition(c26056015.actcon)
	c:RegisterEffect(e0b)
	if c26056015.flagmap==nil then
		c26056015.flagmap={}
	end
	if c26056015.flagmap[c]==nil then
		c26056015.flagmap[c] = {}
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add 1 "Tetram" monster to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056015,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,26056015)
	e2:SetTarget(c26056015.thtg)
	e2:SetOperation(c26056015.thop)
	c:RegisterEffect(e2)
	--special summon from GY to zone
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26056015,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetTarget(c26056015.sptg)
	e3:SetOperation(c26056015.spop)
	c:RegisterEffect(e3)
end
function c26056015.actcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local zone=c:GetColumnZone(LOCATION_MZONE,0,0,tp)
	zone=Duel.GetZoneWithLinkedCount(3,tp)&zone
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone&ZONES_MMZ)>0
end
function c26056015.extrafilter(c,e,tp)
	local g=c:GetColumnGroup()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and g and g:IsContains(e:GetHandler())
end
function c26056015.matfilter(c)
	return c:IsCode(26056015) and c:IsFaceup()
end
function c26056015.extracon(c,e,tp,sg,mg,lc,og,chk)
	local c=e:GetHandler()
	return (sg+mg):Filter(c26056015.extrafilter,nil,e,e:GetHandlerPlayer(),tp):IsExists(Card.IsSetCard,1,og,0x656) and
	(c:GetCounter(0x1656)>0 or c:GetCounter(0x1657)>0 or
	c:GetCounter(0x1658)>0 or c:GetCounter(0x1659)>0)
end
function c26056015.extraval(chk,summon_type,e,...)
	local c=e:GetHandler()
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or not (sc and sc:IsSetCard(0x656)) then
			return Group.CreateGroup()
		else
			Duel.RegisterFlagEffect(tp,26056015,0,0,1)
			table.insert(c26056015.flagmap[c],c:RegisterFlagEffect(26056015,0,EFFECT_FLAG_SET_AVAILABLE,1))
			return Group.FromCards(c)
		end
	elseif chk==1 then
		local sg,sc,tp=...
		if summon_type&SUMMON_TYPE_LINK == SUMMON_TYPE_LINK and #sg>0 then
			Duel.Hint(HINT_CARD,tp,26056015)
		end
	elseif chk==2 then
		for _,eff in ipairs(c26056015.flagmap[c]) do
			eff:Reset()
		end
		c26056015.flagmap[c]={}
		Duel.ResetFlagEffect(e:GetHandlerPlayer(),26056015)
	end
end
function c26056015.addtypecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),26056015)>0
end

function c26056015.thfilter(c,e,p)
	return c:IsSetCard(0x1656) and c:IsAbleToHand() and (
	c26056015.counter(c,e,p,0x1656) or
	c26056015.counter(c,e,p,0x1657) or
	c26056015.counter(c,e,p,0x1658) or
	c26056015.counter(c,e,p,0x1659))
end
function c26056015.counter(c,e,p,ct)
	if c:PlacesCounter(ct) and
	Duel.IsCanRemoveCounter(p,1,0,ct,1,REASON_EFFECT) then
	   e:SetLabel(ct) 
	   return true
	end
end
function c26056015.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c26056015.thfilter(c,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c26056015.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectTarget(tp,c26056015.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26056015.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local ct=e:GetLabel()
	if tc and tc:IsRelateToEffect(e) and
	ct and Duel.IsCanRemoveCounter(tp,1,0,ct,1,REASON_EFFECT) then
		Duel.RemoveCounter(tp,1,0,ct,1,REASON_EFFECT)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c26056015.tetrafilter(c)
	return c:IsSetCard(0x656) and c:IsFaceup()
end
function c26056015.zones(e,tp)
	local zone=0
	local left_right=0
	local lg=Duel.GetMatchingGroup(c26056015.tetrafilter,tp,LOCATION_ONFIELD,0,nil)
	for tc in lg:Iter() do
		left_right=tc:IsInMainMZone() and 1 or 0
		zone=(zone|tc:GetColumnZone(LOCATION_MZONE,left_right,left_right,tp))
	end
return zone&ZONES_MMZ
end
function c26056015.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c26056015.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=c26056015.zones(e,tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c26056015.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26056015.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c26056015.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c26056015.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local zone=c26056015.zones(e,tp)
	if tc:IsRelateToEffect(e) and zone>0 then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		local g=tc:GetMutualLinkedGroup()
		local hc=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		local tt=#g-hc
		if tt>=1 and Duel.IsPlayerCanDraw(tp,tt) and Duel.SelectYesNo(tp,aux.Stringid(26051015,3)) then
			Duel.BreakEffect()
			Duel.Draw(tp,tt,REASON_EFFECT)
		end
	end
end