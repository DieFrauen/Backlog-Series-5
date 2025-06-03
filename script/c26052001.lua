--Liddel the Nomencreator
function c26052001.initial_effect(c)
	--Set 1 "Nomencrea" card from Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26052001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,26052001)
	e1:SetTarget(c26052001.thtg)
	e1:SetOperation(c26052001.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26052001,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e4:SetCountLimit(1,{26052001,1})
	e4:SetCondition(c26052001.immcon)
	e4:SetCost(c26052001.cost)
	e4:SetOperation(c26052001.immop)
	c:RegisterEffect(e4)
end
function c26052001.setfilter(c)
	return c:IsSpellTrap() and ((
	c:IsCode(26052012) and not c:IsForbidden()) or
	c:IsSetCard(0x652) and c:IsAbleToHand())
end
function c26052001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26052001.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c26052001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26052001.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		if tc:IsCode(26052012) and Duel.SelectYesNo(tp,aux.Stringid(26052001,2)) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c26052001.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function c26052001.costfilter(c)
	return c:IsMonster() and c:IsReleasable()
end
function c26052001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	local c=e:GetHandler()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26052012)}) do
		fg:AddCard(pe:GetHandler())
	end
	local g1=Duel.GetMatchingGroup(c26052001.costfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,e:GetHandler())
	if #fg>0 then
		local g2=Duel.GetMatchingGroup(c26052012.costfilter,tp,LOCATION_DECK,0,nil,e,tp)
		g1:Merge(g2)
	end
	if chk==0 then return #g1>0 and c:IsReleasable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		local fc=nil
		if #fg==1 then
			fc=fg:GetFirst()
		else
			fc=fg:Select(tp,1,1,nil):GetFirst()
		end
		Duel.HintSelection(fc)
		Duel.Hint(HINT_CARD,0,fc:GetCode())
		fc:RegisterFlagEffect(26052012,RESETS_STANDARD_PHASE_END,0,0)
	end
	local tg=Group.FromCards(tc,c)
	Duel.SendtoGrave(tg,REASON_COST+REASON_RELEASE)
end
function c26052001.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION))
	e1:SetValue(c26052001.efilter)
	if Duel.IsPhase(PHASE_MAIN1) then
		e1:SetReset(RESET_PHASE|PHASE_MAIN1)
	else
		e1:SetReset(RESET_PHASE|PHASE_MAIN2)
	end
	if Duel.IsPhase(PHASE_MAIN1) then
		Duel.RegisterFlagEffect(tp,26052001,RESET_PHASE|PHASE_MAIN1,0,1)
	else
		Duel.RegisterFlagEffect(tp,26052001,RESET_PHASE|PHASE_MAIN2,0,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c26052001.efilter(e,re)
	local rc=re:GetHandler()
	p,rp=e:GetOwnerPlayer(),re:GetOwnerPlayer()
	return p~=rp and re:IsActivated() and Duel.IsExistingMatchingCard(c26052001.nmfilter,p,0,LOCATION_GRAVE,1,nil,rc)
end
function c26052001.nmfilter(c,rc)
	return c:IsMonster() and c:IsType(TYPE_NORMAL) and c:IsRace(rc:GetRace())
end