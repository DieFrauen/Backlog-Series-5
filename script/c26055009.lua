--Etherweight Carnwennan
function c26055009.initial_effect(c)
	--pendulum effect
		Pendulum.AddProcedure(c)
		--spell immune
		local pe1=Effect.CreateEffect(c)
		pe1:SetType(EFFECT_TYPE_FIELD)
		pe1:SetCode(EFFECT_IMMUNE_EFFECT)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetTargetRange(LOCATION_MZONE,0)
		pe1:SetCondition(c26055009.spellcon)
		pe1:SetTarget(c26055009.etarget)
		pe1:SetValue(c26055009.efilter)
		c:RegisterEffect(pe1)
	--equip effect (equipped by an "Etherweight" card effect)
		--atk up
		local eq1=Effect.CreateEffect(c)
		eq1:SetType(EFFECT_TYPE_EQUIP)
		eq1:SetCode(EFFECT_UPDATE_ATTACK)
		eq1:SetCondition(c26055009.eqcon)
		eq1:SetValue(200)
		c:RegisterEffect(eq1)
		--spell immune
		local eq2=pe1:Clone()
		eq2:SetRange(LOCATION_SZONE)
		eq2:SetCondition(aux.AND(c26055009.eqcon,c26055009.spellcon))
		c:RegisterEffect(eq2)
	--monster effect
		--send to Extra
		local e1a=Effect.CreateEffect(c)
		e1a:SetDescription(aux.Stringid(26055009,0))
		e1a:SetCategory(CATEGORY_TODECK)
		e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1a:SetProperty(EFFECT_FLAG_DELAY)
		e1a:SetCode(EVENT_SUMMON_SUCCESS)
		e1a:SetCountLimit(1,26055009)
		e1a:SetTarget(c26055009.thtg)
		e1a:SetOperation(c26055009.thop)
		c:RegisterEffect(e1a)
		local e1b=e1a:Clone()
		e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(e1b)
		local e1c=e1a:Clone()
		e1c:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e1c)
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26055009,1))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_TO_DECK)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_HAND)
		e2:SetCountLimit(1,{26055009,1})
		e2:SetCondition(c26055009.spcon)
		e2:SetTarget(c26055009.sptg)
		e2:SetOperation(c26055009.spop)
		c:RegisterEffect(e2)
end
c26055009.listed_series={0x655}
c26055009.listed_names={26055009}
function c26055009.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(26055001) and c:GetEquipTarget()
end
function c26055009.spellcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
	or Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
end
function c26055009.etarget(e,c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup(0)
end
function c26055009.efilter(e,te)
	return te:IsSpellEffect() and not te:GetHandler():IsOriginalType(TYPE_PENDULUM)
end
function c26055009.thfilter(c)
	return c:IsSetCard(0x655) and c:IsMonster() and not c:IsCode(26055009) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c26055009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26055009.thfilter,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
end
function c26055009.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg
	and #sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_DECK)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
end
function c26055009.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26055009.thfilter,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,nil)
	local xg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	local ct=1; if #xg==0 then ct=3 end
	local sg=aux.SelectUnselectGroup(g,e,tp,1,ct,c26055009.rescon,1,tp,HINTMSG_TODECK)
	if #sg>0 then
		Duel.SendtoExtraP(sg,tp,REASON_EFFECT)
	end
end
function c26055009.spfilter(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function c26055009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26055009.spfilter,1,nil)
end
function c26055009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c26055009.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		--Banish it if it leaves the field
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		--c:RegisterEffect(e1,true)
	end
end