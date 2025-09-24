--Elegiac Milismata
function c26053004.initial_effect(c)
	--Special Summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26053004)
	e1:SetCondition(c26053004.spcon)
	e1:SetTarget(c26053004.sptg)
	e1:SetOperation(c26053004.spop)
	c:RegisterEffect(e1)
	--send to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053004,1))
	e2:SetCategory(CATEGORY_TOGRAVE|CATEGORY_RELEASE|CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c26053004.tgtg)
	e2:SetOperation(c26053004.tgop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2a:SetCondition(c26053004.spcon2)
	c:RegisterEffect(e2a)
end
function c26053004.cfilter(c,p)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsControler(p)
end
function c26053004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26053004.cfilter,1,nil,rp)
end
function c26053004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c26053004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26053004.tgfilter(c)
	return c:IsSetCard(0x1653) and c:IsMonster() and c:IsAbleToGrave()
end
function c26053004.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26053004.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function c26053004.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26053004.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		e:SetLabelObject(g:GetFirst())
		local rparams={lvtype=RITPROC_EQUAL,
				filter=aux.FilterBoolFunction(Card.IsSetCard,0x2653),
				location=LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK,
				matfilter=aux.FilterBoolFunction(Card.IsSetCard,0x653),
				extrafil=c26053004.extramat,
				extratg=c26053003.extratg,
				extraop=c26053003.extraop,
				forcedselection=c26053004.ritcheck}
		local rtg,rop=Ritual.Target(rparams),Ritual.Operation(rparams)
		if rtg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(26053004,2)) then
			rop(e,tp,eg,ep,ev,re,r,rp)
		else Duel.SendtoGrave(g,REASON_EFFECT) end
	end
end
function c26053004.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(EFFECT_TYPE_ACTIONS) and re:GetHandler():IsSetCard(0x653)
end
function c26053004.extramat(e,tp,eg,ep,ev,re,r,rp,chk)
	return Group.FromCards(e:GetLabelObject())
end
function c26053004.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	if tc:IsLocation(LOCATION_DECK) and Duel.GetFlagEffect(tp,26053011)==0 then
		Duel.RegisterFlagEffect(tp,26053011,RESET_PHASE|PHASE_END,0,1)
		Duel.Hint(HINT_CARD,tp,26053011)
	end
	local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
	mat:Sub(mat2)
	Duel.ReleaseRitualMaterial(mat)
	Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function c26053004.ritcheck(e,tp,g,sc)
	local eg=e:GetLabelObject()
	local sg=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return #sg==1 and sg:IsContains(eg) 
	and (Duel.IsPlayerAffectedByEffect(tp,26053011)
	and g:GetSum(Card.GetLevel)==sc:GetLevel()
	and sc:IsSetCard(0x2653)
	or not sc:IsLocation(LOCATION_DECK))
end