--Etherweight Fragarach
function c26055007.initial_effect(c)
	--pendulum effect
		Pendulum.AddProcedure(c)
		--atk up
		local pe1=Effect.CreateEffect(c)
		pe1:SetType(EFFECT_TYPE_FIELD)
		pe1:SetCode(EFFECT_UPDATE_ATTACK)
		pe1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		pe1:SetTargetRange(LOCATION_MZONE,0)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetCondition(c26055007.pendcon)
		pe1:SetValue(c26055007.atkval)
		pe1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
		c:RegisterEffect(pe1)
		--hand limit up
		local pe2=Effect.CreateEffect(c)
		pe2:SetType(EFFECT_TYPE_FIELD)
		pe2:SetCode(EFFECT_HAND_LIMIT)
		pe2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		pe2:SetRange(LOCATION_PZONE)
		pe2:SetTargetRange(1,0)
		pe2:SetCondition(aux.AND(c26055007.hdcon,c26055007.pendcon))
		pe2:SetValue(c26055007.hdval)
		c:RegisterEffect(pe2)
	--equip effect (equipped by an "Etherweight" card effect)
		--atk up
		local eq1=Effect.CreateEffect(c)
		eq1:SetType(EFFECT_TYPE_EQUIP)
		eq1:SetCode(EFFECT_UPDATE_ATTACK)
		eq1:SetCondition(c26055007.eqcon)
		eq1:SetValue(400)
		c:RegisterEffect(eq1)
		--atk up (again lol)
		local eq2=pe1:Clone()
		eq2:SetRange(LOCATION_SZONE)
		eq2:SetCondition(aux.AND(c26055007.eqcon,c26055007.pendcon))
		c:RegisterEffect(eq2)
		--hand limit up
		local eq3=pe2:Clone()
		eq3:SetRange(LOCATION_SZONE)
		eq3:SetCondition(aux.AND(c26055007.eqcon,
								 c26055007.hdcon,
								 c26055007.pendcon))
		c:RegisterEffect(eq3)
	--Monster effect
		--add "Etherweight" card(s) to Hand
		local e1a=Effect.CreateEffect(c)
		e1a:SetDescription(aux.Stringid(26055007,0))
		e1a:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1a:SetProperty(EFFECT_FLAG_DELAY)
		e1a:SetCode(EVENT_SUMMON_SUCCESS)
		e1a:SetCountLimit(1,26055007)
		e1a:SetTarget(c26055007.thtg)
		e1a:SetOperation(c26055007.thop)
		c:RegisterEffect(e1a)
		local e1b=e1a:Clone()
		e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(e1b)
		local e1c=e1a:Clone()
		e1c:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e1c)
		--Special Summon itself
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26055007,1))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetRange(LOCATION_HAND)
		e2:SetCountLimit(1,{26055007,1})
		e2:SetCondition(c26055007.spcon)
		e2:SetTarget(c26055007.sptg)
		e2:SetOperation(c26055007.spop)
		c:RegisterEffect(e2)
end
c26055007.listed_series={0x655}
c26055007.listed_names={26055007}
function c26055007.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(26055001) and c:GetEquipTarget()
end
function c26055007.pendcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 or Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
end
function c26055007.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*100
end
function c26055007.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,e:GetHandlerPlayer(),0,LOCATION_EXTRA,nil)>6
end
function c26055007.hdval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,e:GetHandlerPlayer(),0,LOCATION_EXTRA,nil)
end
function c26055007.thfilter(c)
	return c:IsSetCard(0x655) and c:IsMonster() and not c:IsCode(26055007) and c:IsAbleToHand()
end
function c26055007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local LOC=LOCATION_DECK|LOCATION_EXTRA|LOCATION_GRAVE 
	if chk==0 then return Duel.IsExistingMatchingCard(c26055007.thfilter,tp,LOC,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOC)
end
function c26055007.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg
	and #sg:Filter(Card.IsLocation,nil,LOCATION_DECK)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
end
function c26055007.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26055007.thfilter,tp,LOCATION_DECK|LOCATION_EXTRA|LOCATION_GRAVE,0,nil)
	local xg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	local ct=1; if #xg==0 then ct=3 end
	local sg=aux.SelectUnselectGroup(g,e,tp,1,ct,c26055007.rescon,1,tp,HINTMSG_ATOHAND)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c26055007.cfilter(c,p)
	return c:IsControler(p) and c:IsType(TYPE_PENDULUM) and not c:IsReason(REASON_DRAW)
end
function c26055007.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c26055007.cfilter,1,c,tp) and not eg:IsContains(c)
end
function c26055007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26055007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end