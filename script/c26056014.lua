--Tetramius Caput
function c26056014.initial_effect(c)
	--Extra Material (thx edo9300)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_EXTRA_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetOperation(c26056014.extracon)
	e0:SetValue(c26056014.extraval)
	c:RegisterEffect(e0)
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetCode(EFFECT_ADD_TYPE)
	e0a:SetRange(LOCATION_SZONE)
	e0a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0a:SetCondition(c26056014.addtypecon)
	e0a:SetValue(TYPE_MONSTER)
	c:RegisterEffect(e0a)
	if c26056014.flagmap==nil then
		c26056014.flagmap={}
	end
	if c26056014.flagmap[c]==nil then
		c26056014.flagmap[c] = {}
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056014,0))
	e2:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,26056014)
	--e2:SetCost(c26056014.cost)
	e2:SetTarget(c26056014.target1)
	e2:SetOperation(c26056014.operation1)
	c:RegisterEffect(e2)
	--extra NS to column
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26056014,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c26056014.sumcon2)
	e3:SetTarget(c26056014.nsumtg)
	e3:SetValue(c26056014.sumval)
	c:RegisterEffect(e3)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(c26056014.sumval)
	c:RegisterEffect(e4)
	--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c26056014.limcon)
	e5:SetOperation(c26056014.limop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCode(EVENT_CHAIN_END)
	e8:SetOperation(c26056014.limop2)
	c:RegisterEffect(e8)
end
function c26056014.sumval(e,c)
	return c:IsSetCard(0x656) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c26056014.extrafilter(c,tc,tp)
	local g=c:GetColumnGroup()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
	and g and g:IsContains(tc)
end
function c26056014.matfilter(c)
	return c:IsCode(26056014) and c:IsFaceup()
end
function c26056014.extracon(c,e,tp,sg,mg,lc,og,chk)
	local c=e:GetHandler()
	return (sg+mg):Filter(c26056014.extrafilter,c,c,tp):IsExists(Card.IsSetCard,1,og,0x656) and
	(c:GetCounter(0x1656)>0 or c:GetCounter(0x1657)>0 or
	c:GetCounter(0x1658)>0 or c:GetCounter(0x1659)>0)
end
function c26056014.extraval(chk,summon_type,e,...)
	local c=e:GetHandler()
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or not (sc and sc:IsSetCard(0x656)) then
			return Group.CreateGroup()
		else
			Duel.RegisterFlagEffect(tp,26056014,0,0,1)
			table.insert(c26056014.flagmap[c],c:RegisterFlagEffect(26056014,0,EFFECT_FLAG_SET_AVAILABLE,1))
			return Group.FromCards(c)
		end
	elseif chk==1 then
		local sg,sc,tp=...
		if summon_type&SUMMON_TYPE_LINK == SUMMON_TYPE_LINK and #sg>0 then
			Duel.Hint(HINT_CARD,tp,26056014)
		end
	elseif chk==2 then
		for _,eff in ipairs(c26056014.flagmap[c]) do
			eff:Reset()
		end
		c26056014.flagmap[c]={}
		Duel.ResetFlagEffect(e:GetHandlerPlayer(),26056014)
	end
end
function c26056014.addtypecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),26056014)>0
end
function c26056014.filter1(c)
	return c:IsSetCard(0x1656) and c:IsMonster() and c:IsAbleToHand()
end
function c26056014.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26056014.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26056014.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26056014.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26056014.nsumtg(e,c)
	return c:IsSetCard(0x1656) and c:IsLevel(4)
end
function c26056014.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5
end
function c26056014.sumval(e,c)
	local ec=e:GetHandler()
	local tp=ec:GetControler()
	local sumzone=ec:GetColumnZone(LOCATION_MZONE,0,0,tp)&aux.GetMMZonesPointedTo(tp,Card.IsSetCard,nil,nil,nil,0x1656)
	local relzone=0x7f007f--&~(1<<c:GetSequence())
	return 0,sumzone,relzone
end
function c26056014.limfilter(c,p)
	return c:IsSetCard(0x656) and c:IsSummonPlayer(p)
end
function c26056014.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26056014.limfilter,1,nil,tp)
end
function c26056014.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c26056014.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(26056014,RESETS_STANDARD_PHASE_END,0,1)
	end
end
function c26056014.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(26056014)~=0 then
		Duel.SetChainLimitTillChainEnd(c26056014.chainlm)
	end
	e:GetHandler():ResetFlagEffect(26056014)
end
function c26056014.chainlm(e,rp,tp)
	return tp==rp
end