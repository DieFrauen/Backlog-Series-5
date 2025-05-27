--Liddel the Nomencreator
function c26051001.initial_effect(c)
	--Add 1 "Nomencreation" to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26051001,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c26051001.thtg)
	e2:SetOperation(c26051001.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	
end
function c26051001.thfilter(c)
	return (c:IsCode(26051012) or c:GetType()&0x11==0x11) and c:IsAbleToHand()
end
function c26051001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26051001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26051001.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c26051001.thfilter,tp,LOCATION_DECK,0,1,2,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if #tc<2 then 
			Duel.ConfirmCards(1-tp,tc)
			return
		end
		if Duel.IsExistingMatchingCard(c26051001.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
			Duel.BreakEffect()
			local cg=Duel.SelectMatchingCard(tp,c26051001.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
			local tg
			
		else
			Duel.BreakEffect()
			local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

function c26051001.exfilter(c,e,tp)
	return c.material and c:IsType(TYPE_FUSION) and 
	Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND,0,nil,table.unpack(c.material)):GetClassCount(Card.GetCode)>1
end

function c26051001.spfilter(c,e,tp,fc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(table.unpack(fc.material))
end