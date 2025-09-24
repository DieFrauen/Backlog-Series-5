--Orchestra of the Elegiants
function c26053011.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Orchestra
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(26053011)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c26053011.orcon)
	c:RegisterEffect(e2)
	--Increase ATK
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26053011,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c26053011.atkcon)
	e3:SetTarget(c26053011.atktg)
	e3:SetOperation(c26053011.atkop)
	c:RegisterEffect(e3)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1653))
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISABLE_FLIP_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e6)
end
function c26053011.orcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),26053011)==0
end

function c26053011.elfilter(c,a)
	local lv={}
	if c:IsPublic() then return false end
	if a:IsSetCard(0x2653) and a:IsType(TYPE_RITUAL) then
		lv=a.ELEGIAC
		for i=1,5 do
			if lv[i] and c:GetLevel()==lv[i] then return true end
		end
	else
		lv=c.ELEGIAC
		for i=1,5 do
			if c:IsSetCard(0x2653) and c:IsType(TYPE_RITUAL)
			and lv[i] and a:GetLevel()==lv[i] then return true end
		end
	end
	return false
end
function c26053011.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a,b=Duel.GetBattleMonster(tp)
	return a and b  and b:IsFaceup() and a:IsFaceup()
	and Duel.IsExistingMatchingCard(c26053011.elfilter,tp,LOCATION_HAND,0,1,nil,a)
end
function c26053011.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26053111)==0 end
	local _,b=Duel.GetBattleMonster(tp)
	Duel.SetTargetCard(b)
	c:RegisterFlagEffect(26053111,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE_CAL,0,1)
end
function c26053011.atkop(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.GetFirstTarget()
	local a=b:GetBattleTarget()
	if a:IsRelateToBattle() and a:IsFaceup()
	and b:IsRelateToBattle() and b:IsFaceup() then
		local sc=Duel.SelectMatchingCard(tp,c26053011.elfilter,tp,LOCATION_HAND,0,1,1,nil,a)
		if #sc>0 then
			Duel.ConfirmCards(1-tp,sc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(sc:GetFirst():GetLevel()*-100)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE_CAL)
			b:RegisterEffect(e1)
		end
	end
end