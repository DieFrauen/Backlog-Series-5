--SNI-Pyre Ace - Nagant
function c26054004.initial_effect(c)
	--Special Summon both 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26054004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:SetCountLimit(1,26054004)
	e1:SetCost(c26054004.spcost)
	e1:SetTarget(c26054004.sptg)
	e1:SetOperation(c26054004.spop)
	c:RegisterEffect(e1)
	--reduce ATK/Destroy ST/Banish from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26054004,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c26054004.distg)
	e2:SetOperation(c26054004.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O|EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c26054004.xyzcost)
	e3:SetCondition(c26054004.xyzcon)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP)
	c:RegisterEffect(e3)
end
c26054004.listed_names={26054001}
c26054004.listed_series={0x654,0x1654}
function c26054004.spcostfilter(c,e,tp)
	return (c:IsRace(RACE_PYRO) or c:IsAttribute(ATTRIBUTE_FIRE)) and not c:IsPublic() and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c26054004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26054004.spcostfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rc=Duel.SelectMatchingCard(tp,c26054004.spcostfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,rc)
	e:SetLabelObject(rc)
	Duel.ShuffleHand(tp)
end
function c26054004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	local rc=e:GetLabelObject()
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Group.FromCards(c,rc),2,tp,0)
end
function c26054004.spfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c26054004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.FromCards(c,tc)
	if g:FilterCount(c26054004.spfilter,nil,e,tp)<2 or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c26054004.tgfilter(c,e,tp)
	return c:IsOnField() or 
	c:IsAbleToRemove() and (aux.SpElimFilter(c) or not c:IsMonster())
	and c:IsCanBeEffectTarget(e) or Duel.IsPlayerAffectedByEffect(tp,26054009)
end
function c26054004.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local LOC = LOCATION_ONFIELD|LOCATION_GRAVE
	if chkc then return chkc:IsLocation(LOC) and c26054004.tgfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingMatchingCard(c26054004.tgfilter,tp,LOC,LOC,1,c,e,tp) and c26054004.ovg(e,c,tp,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,c26054004.tgfilter,tp,LOC,LOC,1,1,c,e,tp):GetFirst()
	Duel.SetTargetCard(tc)
	if tc:IsOnField() then
		if tc:IsMonster() and tc:IsFaceup() then
			Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,tp,0)
		else
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,0)
		end
	elseif tc:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tp,0)
	end
end
function c26054004.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c26054004.ovg(e,c,tp,0) then return end
	if tc:IsRelateToEffect(e) and c26054004.ovg(e,c,tp,1) then
		if tc:IsOnField() then
			if tc:IsFacedown() or not tc:IsMonster() then
				Duel.Destroy(tc,REASON_EFFECT)
			else
				--Reduce ATK
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESETS_STANDARD_PHASE_END)
				e1:SetValue(-600)
				tc:RegisterEffect(e1)
			end
		elseif tc:IsLocation(LOCATION_GRAVE) and aux.SpElimFilter(tc) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c26054004.ovg(e,c,tp,chk)
	local ov1=c:GetOverlayGroup()
	local ov2=Duel.GetOverlayGroup(tp,1,0)
	if not Duel.IsPlayerAffectedByEffect(tp,26054011) then
		ov2=ov2:Filter(Card.IsCode,nil,26054001)
	end
	ov1:Merge(ov2)
	if Duel.IsPlayerAffectedByEffect(tp,26054015) then
		local ov3=Duel.GetMatchingGroup(c26054015.ammo,tp,LOCATION_HAND,0,nil)
		ov1:Merge(ov3)
	end
	if chk==0 then
		return #ov1>0
	end
	if chk==1 then
		local dc=ov1:Select(tp,1,1,nil):GetFirst()
		if dc:IsLocation(LOCATION_OVERLAY) then
			return Duel.SendtoGrave(dc,REASON_EFFECT+REASON_XYZ)>0
		end
		if dc:IsLocation(LOCATION_HAND) then
			return Duel.SendtoGrave(dc,REASON_EFFECT+REASON_DISCARD)>0
		end
		return false
	end
end
function c26054004.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c26054004.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x654)
end