--Dracon - Fantastic Nomencreation
function c26051008.initial_effect(c)
	Fusion.AddProcMixRep(c,true,true,c26051008.ffilter,2,99)
	Fusion.AddContactProc(c,c26051008.contactfil,c26051008.contactop,c26051008.splimit,nil,nil,nil,false)
	
end
function c26051008.ffilter(c,fc,sumtype,sp,sub,mg,sg)
	local rc=RACE_DRAGON+RACE_DINOSAUR+RACE_PYRO+RACE_WYRM+RACE_FIEND 
	return c:IsRace(rc,fc,sumtype,sp) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace(),fc,sumtype,sp))
end
function c26051008.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetLocation()~=LOCATION_EXTRA 
end
function c26051008.contactfil(tp)
	return Duel.GetMatchingGroup(c26051008.mtfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
end
function c26051008.mtfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_NORMAL)
end
function c26051008.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
