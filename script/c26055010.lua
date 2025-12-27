--Etherweight Cruaidín
function c26055010.initial_effect(c)
	--pendulum effect
		Pendulum.AddProcedure(c)
		--add to Hand
		local pe1=Effect.CreateEffect(c)
		pe1:SetDescription(aux.Stringid(26055010,0))
		pe1:SetCategory(CATEGORY_DESTROY|CATEGORY_TOHAND|CATEGORY_SEARCH)
		pe1:SetType(EFFECT_TYPE_IGNITION)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetCountLimit(1,26055010)
		pe1:SetTarget(c26055010.thtg)
		pe1:SetOperation(c26055010.thop)
		c:RegisterEffect(pe1)
	--equip effect (equipped by an "Etherweight" card effect)
		--atk up
		local eq1=Effect.CreateEffect(c)
		eq1:SetType(EFFECT_TYPE_EQUIP)
		eq1:SetCode(EFFECT_UPDATE_ATTACK)
		eq1:SetCondition(c26055010.eqcon)
		eq1:SetValue(100)
		c:RegisterEffect(eq1)
		--add to Hand
		local eq2=pe1:Clone()
		eq2:SetRange(LOCATION_SZONE)
		eq2:SetCondition(c26055010.eqcon)
		c:RegisterEffect(eq2)
	--monster effect
	
end
function c26055010.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(26055001) and c:GetEquipTarget()
end
function c26055010.thfilter(c)
	return c:IsSetCard(0x655) and c:IsSpellTrap() and c:IsAbleToHand()
end
function c26055010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26055010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26055010.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c26055010.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
