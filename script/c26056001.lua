--Wutmann the Tetramancer
function c26056001.initial_effect(c)
	--Special Summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26056001,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26056001)
	e1:SetValue(c26056001.hspval)
	e1:SetLabel(2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabel(3)
	c:RegisterEffect(e2)
	--add 1 "Tetramancer" card from Deck to Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26056001,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,{26056001,1})
	e3:SetTarget(c26056001.thtg)
	e3:SetOperation(c26056001.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--Special Summon Tokens
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26056001,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,{26056001,2})
	e6:SetTarget(c26056001.sptg)
	e6:SetOperation(c26056001.spop)
	c:RegisterEffect(e6)
end
c26056001.tetrafilter=aux.FaceupFilter(Card.IsSetCard,0x656)
function c26056001.hspval(e,c)
	local lb=e:GetLabel()
	return 0,Duel.GetZoneWithLinkedCount(lb,c:GetControler())&ZONES_MMZ
end
function c26056001.thfilter(c)
	return (c:IsSetCard(0x1656) or c:IsCode(26056012)) and c:IsAbleToHand()
end
function c26056001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26056001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26056001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26056001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26056001.spfilter(c,tp)
	if not (c:IsMonster() and c:IsSetCard(0x1656) and c:IsDiscardable() and c.TETRATOKEN) then return false end
	local ct,tk=table.unpack(c.TETRATOKEN)
	return ct and tk and Duel.IsPlayerCanSpecialSummonMonster(tp,ct,0x1656,TYPES_TOKEN,0,0,4,c:GetOriginalRace(),c:GetOriginalAttribute())
end
function c26056001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c26056001.spfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c26056001.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(c26056001.spfilter,tp,LOCATION_HAND,0,nil,tp) 
	local c=e:GetHandler()
	if ft>0 and #g>0 then
		local sg=g:Select(tp,1,ft,nil)
		Duel.ConfirmCards(1-tp,sg)
		tc=sg:GetFirst()
		local spg,ctg=Group.CreateGroup(),Group.CreateGroup()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		for tc in aux.Next(sg) do
			local ct,tk=table.unpack(tc.TETRATOKEN)
			local token=Duel.CreateToken(tp,tk)
			spg:AddCard(token)
		end
		while #spg>0 do
			local spc=spg:GetFirst()
			if spg:GetClassCount(Card.GetAttribute)>1 then
				spc=spg:Select(tp,1,1,nil):GetFirst()
			end
			Duel.SpecialSummonStep(spc,0,tp,tp,false,false,POS_FACEUP)
			spg:Sub(spc);ctg:AddCard(spc)
		end
		Duel.SpecialSummonComplete()
		if #ctg>0 then
			local ctc=ctg:GetFirst()
			for ctc in aux.Next(ctg) do
				local attr=ctc:GetAttribute()
				if attr==ATTRIBUTE_WIND then
					ctc:AddCounter(0x1659,1);c26056005.TETRAIR(e,tp)
				end
				if attr==ATTRIBUTE_WATER then
					ctc:AddCounter(0x1658,1);c26056004.TETRAQUA(e,tp) 
				end
				if attr==ATTRIBUTE_EARTH then
					ctc:AddCounter(0x1657,1);c26056003.TETRALAND(e,tp)
				end
				if attr==ATTRIBUTE_FIRE then
					ctc:AddCounter(0x1656,1);c26056002.TETRAFLARE(e,tp)
				end
			end
		end
	end
end