--Tetramius Bridge - Vias
function c26056010.initial_effect(c)
	--link summon
	Link.AddProcedure(c,nil,2,2,c26056010.lcheck)
	c:EnableReviveLimit()
	--add 1 "Tetramancer" card from Deck to Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26056010,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,26056010)
	e1:SetCondition(function(e)
	return e:GetHandler():IsLinkSummoned() end)
	e1:SetTarget(c26056010.thtg)
	e1:SetOperation(c26056010.thop)
	c:RegisterEffect(e1)
	--Place 1 Spell Counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26056010,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(1)
	e2:SetCountLimit(1,{26056010,1})
	e2:SetTarget(c26056010.target)
	e2:SetOperation(c26056010.operation)
	c:RegisterEffect(e2)
	--Quick if colinked
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26056010,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	local timings=TIMING_END_PHASE|TIMING_BATTLE_STEP_END 
	e3:SetHintTiming(timings,timings|TIMINGS_CHECK_MONSTER)
	e3:SetLabel(2)
	c:RegisterEffect(e3)
	--Add counter2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c26056010.addop2)
	c:RegisterEffect(e4)
end
c26056010.listed_series={0x656,0x1656}
function c26056010.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,2,nil,0x656,lc,sumtype,tp)
end
function c26056010.thfilter(c)
	return c:IsSetCard(0x2656) and c:IsAbleToHand()
end
function c26056010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26056010.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function c26056010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26056010.thfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26056010.filter1(c,e,p)
	return Duel.IsExistingTarget(c26056010.filter2,p,LOCATION_ONFIELD,0,1,c,c,e,p)
end
function c26056010.filter2(c,tc,e,p)
	local ct=nil
	local ctg={0x1656,0x1657,0x1658,0x1659}
	for i=1,4 do
		if c26056010.rctfilter(c,tc,p,ctg[i])
		or c26056010.rctfilter(tc,c,p,ctg[i])
		then ct=ctg[i] end
	end
	local lb=e:GetLabel()
	local lg=c:GetMutualLinkedGroup()
	return c:IsFaceup() and ct
	and (lb==1
	or (c:IsType(TYPE_LINK) and #lg>0 and lg:IsContains(tc)))
end
function c26056010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c26056010.filter1,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26056010,2))
	local tc=Duel.SelectTarget(tp,c26056010.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp):GetFirst() 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26056010,2))
	local tc2=Duel.SelectTarget(tp,c26056010.filter2,tp,LOCATION_ONFIELD,0,1,1,tc,tc,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end

function c26056010.rctfilter(c,oc,p,ct)
	return c:IsCanRemoveCounter(p,ct,1,REASON_EFFECT)
	and oc:IsCanAddCounter(ct,1)
end
function c26056010.ctfilter(c,p,oc,ct)
	local tg={0x1656,0x1657,0x1658,0x1659}
	for i=1,4 do
		if c:IsCanRemoveCounter(p,tg[i],1,REASON_EFFECT)
		then return true end
	end
	return false
end
function c26056010.op5(b1,b2,b3,b4)
	if b1 then return (b2 or b3 or b4)
	elseif b2 then return (b3 or b4)
	elseif b3 then return b4 end
	return false
end
function c26056010.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e):Filter(Card.IsFaceup,nil)
	if #g<2 then return end
	local hg=g:Filter(c26056010.ctfilter,nil,tp)
	if #hg==0 then return end
	local hc=hg:GetFirst()
	if #hg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26056010,8))
		hc=hg:Select(tp,1,1,nil):GetFirst()
	end
	Duel.HintSelection(hc)
	g:RemoveCard(hc)
	oc=g:GetFirst()
	local b1=c26056010.rctfilter(hc,oc,tp,0x1656)
	local b2=c26056010.rctfilter(hc,oc,tp,0x1657)
	local b3=c26056010.rctfilter(hc,oc,tp,0x1658)
	local b4=c26056010.rctfilter(hc,oc,tp,0x1659)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26056010,3))
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26056010,4)},
		{b2,aux.Stringid(26056010,5)},
		{b3,aux.Stringid(26056010,6)},
		{b4,aux.Stringid(26056010,7)})
	local ct=op and 0x1655+op or 0
	hc:RemoveCounter(tp,ct,1,REASON_EFFECT)
	oc:AddCounter(ct,1)
end
function c26056010.addop2(e,tp,eg,ep,ev,re,r,rp)
	for c in aux.Next(eg) do
		local ct={0,0,0,0}
		local tg={0x1656,0x1657,0x1658,0x1659}
		local og=c:GetLinkedGroup()
		og:Sub(eg)
		if c:IsLocation(LOCATION_MZONE) and #og>0 and not (c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_LINK)) then
			for i=1,4 do
				local tct=c:GetCounter(tg[i])
				if c:IsCanRemoveCounter(tp,tg[i],tct,REASON_EFFECT)
				then ct[i]=ct[i]+tct
			end
		end
		if #eg>0 and (ct[1]>0 or ct[2]>0 or ct[3]>0 or ct[4]>0)
		and Duel.SelectEffectYesNo(tp,c,aux.Stringid(26056010,14)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26056010,3))
			while ct[1]>0 or ct[2]>0 or ct[3]>0 or ct[4]>0 do
				local b1=ct[1]
				local b2=ct[2]
				local b3=ct[3]
				local b4=ct[4]
				local b5=ct[1]+ct[2]+ct[3]+ct[4]
				local op=0
				if b5==b1 or b5==b2 or b5==b3 or b5==b4 then op=5
				else
					op=Duel.SelectEffect(tp,
						{b1>0,aux.Stringid(26056010,9)},
						{b2>0,aux.Stringid(26056010,10)},
						{b3>0,aux.Stringid(26056010,11)},
						{b4>0,aux.Stringid(26056010,12)},
						{b5>1,aux.Stringid(26056010,13)})
				end
				if op==5 then
					local oc=og:GetFirst()
					if #og>1 then
						Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26056010,9+op))
						oc=og:Select(tp,1,1,nil):GetFirst()
					end
					if ct[1]>0 then
						oc:AddCounter(tg[1],ct[1]);ct[1]=0
					end
					if ct[2]>0 then
						oc:AddCounter(tg[2],ct[2]);ct[2]=0
					end
					if ct[3]>0 then
						oc:AddCounter(tg[3],ct[3]);ct[3]=0
					end
					if ct[4]>0 then
						oc:AddCounter(tg[4],ct[4]);ct[4]=0
					end
				else
					for i=1,ct[op] do
						local oc=og:GetFirst()
						if #og>1 then
							Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26056010,9+op))
							oc=og:Select(tp,1,1,nil):GetFirst()
						end
						oc:AddCounter(tg[op],1)
						ct[op]=ct[op]-1
						end
					end
				end
			end
		end
	end
end