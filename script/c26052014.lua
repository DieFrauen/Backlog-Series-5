--Nomencreation
function c26052014.initial_effect(c)
	--Fusion
	local e1=Fusion.CreateSummonEff({handler=c,
						fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0x2652),
						desc=aux.Stringid(26052014,0),
						extrafil=c26052014.fextra,
						extratg=c26052014.extratg,
						matcheck=c26052014.matcheck})
	e1:SetCountLimit(1,26052014)
	c:RegisterEffect(e1)
	--return Nomencreations to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26052014,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26052014)
	e2:SetTarget(c26052014.tdtg)
	e2:SetOperation(c26052014.tdop)
	c:RegisterEffect(e2)
end
c26052014.listed_series={0x2652}
function c26052014.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_MZONE)
end
function c26052014.fextra(e,tp,mg)
	local g1=Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup),tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToGrave),tp,LOCATION_DECK,0,nil)
	g1:Merge(g2)
	return g1,c26052014.fcheck
end
function c26052014.fcheck(tp,sg,fc)
	local dg=sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	local ng=sg:FilterCount(Card.IsType,nil,TYPE_NORMAL)
	return sg:FilterCount(Card.IsType,nil,TYPE_EFFECT)<2
	and sg:GetClassCount(Card.GetRace,nil,fc,SUMMON_TYPE_FUSION,tp)==#sg
	and sg:FilterCount(Card.IsControler,nil,1-tp)<2
	and (dg<2 and ng>1 or dg==0)
end
function c26052014.thfilter(c)
	return c:IsFaceup() and c:IsCode(86120751) and c:IsAbleToHand()
end
function c26052014.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26052014.thfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c26052014.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26052014.thfilter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c26052014.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 and c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end