--Elegiac Rescita
function c26053003.initial_effect(c)
	--Special Summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26053003,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26053003)
	e1:SetCondition(c26053003.spcon)
	e1:SetTarget(c26053003.sptg)
	e1:SetOperation(c26053003.spop)
	c:RegisterEffect(e1)
	--Search + Ritual Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053003,1))
	e2:SetCategory(CATEGORY_RELEASE|CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	--e2:SetCountLimit(1,{26053003,1})
	e2:SetTarget(c26053003.extg)
	e2:SetOperation(c26053003.exop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2b:SetCondition(c26053003.spcon2)
	c:RegisterEffect(e2b)
end
function c26053003.extramat(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	--return g
	return e:GetLabelObject():Filter(Card.IsLevelAbove,nil,1)
end
function c26053003.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
	mat:Sub(mat2)
	Duel.ReleaseRitualMaterial(mat)
	Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function c26053003.ritcheck(e,tp,g,sc)
	local exg=e:GetLabelObject()
	return g:GetClassCount(Card.GetLevel)==#g and 
	g:FilterCount(Card.IsSetCard,nil,0x1653)==#g and 
	exg:IsContains(sc) and
	g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)==0 
end
function c26053003.exclude(c,g)
	return g:IsContains(c)
end
function c26053003.cfilter(c,p)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsControler(p) 
end
function c26053003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26053003.cfilter,1,nil,rp)
end
function c26053003.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(EFFECT_TYPE_ACTIONS) and re:GetHandler():IsSetCard(0x653)
end
function c26053003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c26053003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
function c26053003.exfilter(c,e,tp)
	return c:IsSetCard(0x1653) and not c:IsCode(26053003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26053003.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=4 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c26053003.exop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local exg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	exg:Merge(g)
	e:SetLabelObject(exg)
	Duel.BreakEffect()
	local rparams={
		lvtype=RITPROC_GREATER,
		--filter=aux.FilterBoolFunction(Card.IsSetCard,0x2653),
		location=LOCATION_HAND|LOCATION_DECK,
		matfilter=aux.FilterBoolFunction(Card.IsSetCard,0x653),
		extrafil=c26053003.extramat,
		extraop=c26053003.extraop,
		forcedselection=c26053003.ritcheck}
	local rtg,rop=
	Ritual.Target(rparams),
	Ritual.Operation(rparams)
	local b1= Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		g:IsExists(c26053003.exfilter,1,nil,e,tp)
	local b2=rtg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(26053003,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26053003,3))
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(26053003,4)},
			{b2,aux.Stringid(26053003,5)})
		if op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g:FilterSelect(tp,c26053003.exfilter,1,1,nil,e,tp):GetFirst()
			if sc then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		if op==2 then
			rop(e,tp,eg,ep,ev,re,r,rp,0)
		end
	end
	--Duel.ShuffleDeck(tp)
end