--The One Nomencreator
function c26051011.initial_effect(c)
	Fusion.AddProcMixN(c,true,true,c26051011.ffilter,10,99)
	
end
function c26051011.ffilter(c,fc,sumtype,sp,sub,mg,sg)
	return (not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace(),fc,sumtype,sp))
end
