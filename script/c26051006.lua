--Therius - Proud Nomencreation
function c26051006.initial_effect(c)
	Fusion.AddProcMixRep(c,true,true,c26051006.ffilter,2,99)
	Fusion.AddContactProc(c,c26051006.contactfil,c26051006.contactop,c26051006.splimit,nil,nil,nil,false)
	--Increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION))
	e1:SetValue(c26051006.atkval)
	c:RegisterEffect(e1)
end
function c26051006.ffilter(c,fc,sumtype,sp,sub,mg,sg)
	local rc=RACE_WARRIOR+RACE_BEAST+RACE_BEASTWARRIOR+RACE_ROCK+RACE_ZOMBIE 
	return c:IsRace(rc,fc,sumtype,sp) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace(),fc,sumtype,sp))
end
function c26051006.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetLocation()~=LOCATION_EXTRA 
end
function c26051006.contactfil(tp)
	return Duel.GetMatchingGroup(c26051006.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
end
function c26051006.mtfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_NORMAL)
end
function c26051006.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c26051006.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsPublic,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil):Filter(Card.IsType,nil,TYPE_MONSTER)
	return g:GetClassCount(Card.GetRace)*100
end