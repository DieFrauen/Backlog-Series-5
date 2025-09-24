--Westcott, the Elegiac Poet
function c26053001.initial_effect(c)
	--level notation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053001,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c26053001.lvcon)
	e1:SetTarget(c26053001.lvtg)
	e1:SetOperation(c26053001.lvop)
	c:RegisterEffect(e1)
	--Special Summon itself from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,26053001)
	e2:SetCost(c26053001.cost)
	e2:SetTarget(c26053001.sptg)
	e2:SetOperation(c26053001.spop)
	c:RegisterEffect(e2)
	--add "Elegiac" Spell/Trap from Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26052001,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,26053001)
	e3:SetTarget(c26053001.thtg)
	e3:SetOperation(c26053001.thop)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3b)
	local e3c=e3:Clone()
	e3c:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3c)
end
function c26053001.thfilter(c)
	return c:IsSpellTrap() and c:IsSetCard(0x1653) and c:IsAbleToHand()
end
function c26053001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053001.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function c26053001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26053001.thfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26053001.lvcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp then return false end
	local trig_p,te,setcodes=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_SETCODES)
	if trig_p==1-tp or e:GetHandler()==te:GetHandler() then return false end
	for _,archetype in ipairs(setcodes) do
		if ((0x1653&0xfff)==(archetype&0xfff) and (archetype&0x1653)==0x1653) then
			return true
		end
	end
	return false
end
function c26053001.lvfilter(c)
	return c:IsSetCard(0x2653) and c:GetType()&0x81==0x81 and c.ELEGIAC
end
function c26053001.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053001.lvfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function c26053001.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c26053001.lvfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local levels,table=g:GetFirst().ELEGIAC,{}
	for i=1,5 do
		if levels[i]~=c:GetLevel()
		then table[i]=levels[i] end
	end
	if table then
		local lv=Duel.AnnounceNumber(tp,table)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c26053001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
end
function c26053001.spfilter(c)
	return c:IsSetCard(0x653) and c:IsFaceup() and c:IsAbleToHand() and c:IsLevelAbove(2)
end
function c26053001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c26053001.spfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26053001.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c26053001.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c26053001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end