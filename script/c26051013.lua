--Guldengeist - The Sublime
function c26051013.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SYNCHRO),1,1,Synchro.NonTunerEx(Card.IsType,TYPE_SYNCHRO),1,1,c26051013.exmatfilter)
	--atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c26051013.atkcon)
	e0:SetOperation(c26051013.atkop)
	c:RegisterEffect(e0)
	--go even further beyond
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26051013,1))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c26051013.target)
	e1:SetOperation(c26051013.operation)
	c:RegisterEffect(e1)
end
c26051013.listed_names={26051021}
function c26051013.exmatfilter(c,scard,sumtype,tp)
	local lv=c:GetLevel()
	return c and (lv==5 or lv==8)
end
function c26051013.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSynchroSummoned()
end
function c26051013.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local atk=0
	for tc in aux.Next(g) do
		local catk=tc:GetBaseAttack()
		if catk<0 then catk=0 end
		atk=atk+catk
	end
	if atk~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		if atk==5500 then
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(26051013,0))
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCondition(c26051013.econ)
			e2:SetValue(c26051013.efilter)
			c:RegisterEffect(e2)
		end
	end
end
function c26051013.econ(e)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
	and c:GetBaseAttack()==5500
end
function c26051013.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c26051013.resfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
	and c:IsReleasableByEffect() and c:IsCanBeEffectTarget(e)
end
function c26051013.rescon(sg,e,tp,mg)
	return Duel.GetMZoneCount(tp,sg,tp)>0 and
	Duel.IsPlayerCanSpecialSummonMonster(tp,26051021,0,TYPES_TOKEN,sg:GetSum(Card.GetBaseAttack),sg:GetSum(Card.GetBaseDefense),sg:GetSum(Card.GetLevel),RACE_DIVINE,ATTRIBUTE_DIVINE,POS_FACEUP,tp)
end
function c26051013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local TYPES=TYPES_TOKEN+TYPE_SYNCHRO -TYPE_NORMAL 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26051013.resfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then
		return aux.SelectUnselectGroup(g,e,tp,2,2,c26051013.rescon,0)
	end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,2,c26051013.rescon,1,tp,HINTMSG_TODECK)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c26051013.opval(c,op)
	return (val==0 and math.max(c:GetBaseAttack(),0))
	or (val==0 and math.max(c:GetBaseDefense(),0))
	or (val==0 and math.max(c:GetLevel(),0))
end
function c26051013.operationvaluedef(c)
	return math.max(c:GetBaseDefense(),0)
end
function c26051013.operation(e,tp,eg,ep,ev,re,r,rp)
	local TYPES=TYPES_TOKEN+TYPE_SYNCHRO -TYPE_NORMAL 
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<2 then return end
	local atk=tg:GetSum(Card.GetAttack)
	local def=tg:GetSum(Card.GetDefense)
	local lv=tg:GetSum(Card.GetLevel)
	local ct=tg:GetSum(Card.GetCounter,0x1100)
	if Duel.Release(tg,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,26051021,0,TYPES,atk,def,lv,RACE_DIVINE,ATTRIBUTE_DIVINE,POS_FACEUP,tp) then
		local code,END=26051056,false
		if   lv==21 and atk==8900  and def==6760  then
			code=26051021
		elseif lv==34 and atk==14400 and def==10940 then
			code=26051034
		elseif lv==55 and atk==23300 and def==17700 then
			code=26051055
		elseif lv==89 then
			code=26051089
			END=-2
		end
		if ct==lv and lv==(21 or 34 or 55) then
			END=true
		end
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,code)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(def)
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e3:SetValue(lv)
		token:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
		if END==-2 then
			Duel.HintSelection(token)
			c26051089.STOP(c,e,tp,token)
		elseif END==true then   
			Duel.Hint(HINT_CARD,1-tp,26051013)
			local loc=LOCATION_ONFIELD+
					LOCATION_HAND+
					LOCATION_GRAVE+
					LOCATION_EXTRA+
					LOCATION_DECK+
					LOCATION_OVERLAY 
			local ENDg=Duel.GetMatchingGroup(c26051013.ENDfilter,tp,0,loc,nil,1-tp)
			Duel.Remove(ENDg,POS_FACEDOWN,REASON_RULE,PLAYER_NONE,1-tp)
		end
	end
end
function c26051013.ENDfilter(c,p)
	return Duel.IsPlayerCanRemove(p,c) and not c:IsType(TYPE_TOKEN)
end