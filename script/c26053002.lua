--Elegiac Dodrama
function c26053002.initial_effect(c)
	--Special Summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053002,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26053002)
	e1:SetCondition(c26053002.spcon)
	e1:SetTarget(c26053002.sptg)
	e1:SetOperation(c26053002.spop)
	c:RegisterEffect(e1)
	--Search + Ritual Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053002,1))
	e2:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH|CATEGORY_RELEASE|CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,{26053002,1})
	e2:SetTarget(c26053002.thtg)
	e2:SetOperation(c26053002.thop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2c)
	
end
function c26053002.ritcheck(e,tp,g,sc)
	return g:GetClassCount(Card.GetLevel)==#g
	and (Duel.IsPlayerAffectedByEffect(tp,26053011)
	and g:GetSum(Card.GetLevel)==sc:GetLevel()
	or not sc:IsLocation(LOCATION_DECK))
end
function c26053002.cfilter(c,p)
	return c:IsControler(p) and c:GetPreviousControler()==p and
	c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c26053002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26053002.cfilter,1,e:GetHandler(),rp) and r&REASON_EFFECT ~=0
end
function c26053002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26053002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26053002.thfilter(c)
	return c:IsSetCard(0x1653) and c:IsMonster() and c:IsAbleToHand()
end
function c26053002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function c26053002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26053002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local rparams={lvtype=RITPROC_EQUAL,
			filter=aux.FilterBoolFunction(Card.IsSetCard,0x2653),
			location=LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK,
			matfilter=aux.FilterBoolFunction(Card.IsSetCard,0x653),
			extrafil=c26053002.extramat,
			extraop=c26053002.extraop,
			forcedselection=c26053002.ritcheck}
		local rtg,rop=
		Ritual.Target(rparams),
		Ritual.Operation(rparams)
		if rtg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(26053002,2)) then
			rop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function c26053002.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	if tc:IsLocation(LOCATION_DECK) and Duel.GetFlagEffect(tp,26053011)==0 then
		Duel.RegisterFlagEffect(tp,26053011,RESET_PHASE|PHASE_END,0,1)
		Duel.Hint(HINT_CARD,tp,26053011)
	end
	Duel.ReleaseRitualMaterial(mat)
end