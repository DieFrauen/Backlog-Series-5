--Tetramius Geomaestrus - Populas
function c26056011.initial_effect(c)
	--link summon
	Link.AddProcedure(c,nil,2,4,c26056011.lcheck)
	c:EnableReviveLimit()
	--global tetra counters
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(26056011)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--shuffle Tetramius from GY to gain Counters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056011,0))
	e2:SetCategory(CATEGORY_TODECK|CATEGORY_LEAVE_GRAVE|CATEGORY_COIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c26056011.target)
	e2:SetOperation(c26056011.operation)
	c:RegisterEffect(e2)
end
c26056011.listed_series={0x656,0x1656}
function c26056011.lcheck(g,lc,sumtype,tp)
	return g:IsExists(c26056011.lcfilter,2,nil,lc,sumtype,tp)
end
function c26056011.lcfilter(c)
	return not (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5)
end
function c26056011.ALLCOUNTERS(e,p,c,ct,cv)
	local d1,d2,d3,d4=0,0,0,0
	if ct==cv then
	   d1=c:GetCounter(0x1656);d2=c:GetCounter(0x1657);
	   d3=c:GetCounter(0x1658);d4=c:GetCounter(0x1659);
	else
		local v1,v2,v3,v4=0,0,0,0
		for cc=1,cv do
			v1=c:IsCanRemoveCounter(p,0x1656,d1+1,REASON_EFFECT)
			v2=c:IsCanRemoveCounter(p,0x1657,d2+1,REASON_EFFECT)
			v3=c:IsCanRemoveCounter(p,0x1658,d3+1,REASON_EFFECT)
			v4=c:IsCanRemoveCounter(p,0x1659,d4+1,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(26056011,2))
			local op=Duel.SelectEffect(p,
				{v1,aux.Stringid(26056011,4)},
				{v2,aux.Stringid(26056011,5)},
				{v3,aux.Stringid(26056011,6)},
				{v4,aux.Stringid(26056011,7)})
			if op==1 then d1=d1+1
			elseif op==2 then d2=d2+1
			elseif op==3 then d3=d3+1
			elseif op==4 then d4=d4+1 end
		end
	end
	if d1>0 then c:RemoveCounter(p,0x1656,d1,REASON_EFFECT) end
	if d2>0 then c:RemoveCounter(p,0x1657,d2,REASON_EFFECT) end
	if d3>0 then c:RemoveCounter(p,0x1658,d3,REASON_EFFECT) end
	if d4>0 then c:RemoveCounter(p,0x1659,d4,REASON_EFFECT) end
end
function c26056011.ANYCOUNTER(e,p,c,chk)
	v1=c:IsCanRemoveCounter(p,0x1656,1,REASON_EFFECT)
	v2=c:IsCanRemoveCounter(p,0x1657,1,REASON_EFFECT)
	v3=c:IsCanRemoveCounter(p,0x1658,1,REASON_EFFECT)
	v4=c:IsCanRemoveCounter(p,0x1659,1,REASON_EFFECT)
	if chk==0 then return v1 or v2 or v3 or v4 end
	Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(26056011,2))
	local op=Duel.SelectEffect(p,
		{v1,aux.Stringid(26056011,4)},
		{v2,aux.Stringid(26056011,5)},
		{v3,aux.Stringid(26056011,6)},
		{v4,aux.Stringid(26056011,7)})
	local ct,ext,ctg=0,nil
	if op==1 then 
		ct=0x1656;ctg=26056006;ext=c26056006.ext
	elseif op==2 then 
		ct=0x1657;ctg=26056007;ext=c26056007.ext
	elseif op==3 then 
		ct=0x1658;ctg=26056008;ext=c26056008.ext
	elseif op==4 then 
		ct=0x1659;ctg=26056009;ext=c26056009.ext end
	if ctg and Duel.IsPlayerAffectedByEffect(p,ctg) then
	   if ext then ext(e,p,c,1,1)end
	end
end
function c26056011.tdfilter(c)
	return c:IsSetCard(0x1656) and c:IsMonster() and c:IsAbleToDeck()
end
function c26056011.lkfilter(c)
	return c:IsSetCard(0x656) and c:IsFaceup()
end
function c26056011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if c:IsLinkMarker(LINK_MARKER_BOTTOM) and c:GetSequence()<5 then
		local sg=c:GetColumnGroup():Filter(Card.IsColumn,nil,c:GetSequence(),tp,LOCATION_SZONE)
		lg:Merge(sg)
	end
	lg=lg:Filter(c26056011.lkfilter,nil)
	if chkc then return false end
	if chk==0 then return #lg>0 and Duel.IsExistingTarget(c26056011.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.HintSelection(lg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26056011.tdfilter,tp,LOCATION_GRAVE,0,1,#lg,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c26056011.chkfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsAbleToDeck()
end
function c26056011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(c26056011.chkfilter,nil,e)
	if #sg>0 then
		local exg=Group.FromCards(c)
		exg:Merge(Duel.GetMatchingGroup(Card.IsExtraLinked,tp,LOCATION_MZONE,0,nil))
		local sc=sg:GetFirst()
		local ct={false,false,false,false}
		local ctg={0x1656,0x1657,0x1658,0x1659}
		if c26056002.TETRAFLARE then c26056002.TETRAFLARE(e,tp) end
		if c26056003.TETRALAND then c26056003.TETRALAND(e,tp) end
		if c26056004.TETRAQUA then c26056004.TETRAQUA(e,tp) end
		if c26056005.TETRAIR then c26056005.TETRAIR(e,tp) end
		for sc in aux.Next(sg) do
			Duel.HintSelection(sc)
			for i=1,4 do
				if sc:PlacesCounter(ctg[i]) then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26056011,7+i))
					local pc=exg:FilterSelect(tp,Card.IsCanAddCounter,1,1,nil,ctg[i],1):GetFirst()
					if pc then pc:AddCounter(ctg[i],1) end
				end
				Duel.DisableShuffleCheck()
				Duel.SendtoDeck(sc,nil,0,REASON_EFFECT)
				Duel.AdjustInstantly(sc)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end