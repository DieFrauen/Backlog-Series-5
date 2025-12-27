--Hall of Feather Swords
function c26055011.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26055011,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26055011.target)
	c:RegisterEffect(e1)
	--attack check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c26055011.attop)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26055011,5))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c26055011.catg)
	e3:SetOperation(c26055011.caop)
	c:RegisterEffect(e3)
end
function c26055011.dfilter(c)
	return c:IsType(TYPE_PENDULUM)
	and (c:IsDiscardable() or c:IsAbleToExtra())
end
function c26055011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(tp,26055011,0))
	local sg=cg:FilterSelect(tp,c26055011.dfilter,1,#cg,nil)
	if #sg>0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#sg)
		e:SetOperation(c26055011.activate)
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	else
		e:SetOperation(nil)
		e:SetCategory(0)
	end
end
function c26055011.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg<1 then return end
	local b1=sg:FilterCount(Card.IsDiscardable,nil)==#sg
	local b2=sg:FilterCount(Card.IsAbleToExtra,nil)==#sg
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26055011,1))
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26055011,2)},
		{b2,aux.Stringid(26055011,3)})
	if op==1 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
	if op==2 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
	sg=Duel.GetOperatedGroup()
	Duel.BreakEffect()
	Duel.Draw(tp,#sg,REASON_EFFECT)
	local c=e:GetHandler()
	--You cannot Special Summon from the Extra Deck for the rest of this turn, except face-up cards
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26055011,4))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(function(e,c) return c:IsLocation(LOCATION_EXTRA) and not c:IsFaceup() end)
	e2:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--"Clock Lizard" check
	aux.addTempLizardCheck(c,tp,aux.TRUE)
end
function c26055011.attop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	if not d and a then return end
	local aloc,dloc=a:GetSummonLocation(),d:GetSummonLocation()
	if a:IsSetCard(0x655) and a:GetFlagEffect(26055011)==0
	and a:IsRelateToBattle() and d:IsRelateToBattle() 
	and aloc&dloc==aloc and aloc&LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK|LOCATION_EXTRA ~=0 then
		Duel.Hint(HINT_CARD,tp,26055011)
		a:RegisterFlagEffect(26055011,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE,0,1)
	end
end
function c26055011.afilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x655)
	and c:GetFlagEffect(26055011)>0 and c:CanChainAttack(0)
end
function c26055011.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c26055011.afilter,1,nil,tp) end
	local a=eg:Filter(c26055011.afilter,nil,tp):GetFirst()
	Duel.SetTargetCard(a)
end
function c26055011.caop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToBattle() then
		Duel.ChainAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE|PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
		--atklimit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e2:SetValue(c26055011.bttg)
		tc:RegisterEffect(e2)
	end
end
function c26055011.bttg(e,c)
	local sc=e:GetHandler():GetSummonLocation()
	return c:IsFacedown() or not c:GetSummonLocation()&sc==sc
end