--The Sublime One
function c26051089.initial_effect(c)
	
end
function c26051089.CRASH(c,e,tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051089,14))
	Duel.SelectOption(tp,aux.Stringid(26051089,15))
	Duel.Destroy(tc,REASON_EFFECT)
	local token=Duel.CreateToken(tp,26051999)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
end
function c26051089.STOP(c,e,tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051089,0))
	Duel.SelectOption(tp,aux.Stringid(26051089,15)) 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051089,1))
	Duel.SelectOption(tp,aux.Stringid(26051089,15)) 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051089,2))
	Duel.SelectOption(tp,aux.Stringid(26051089,15)) 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051089,3))
	if Duel.SelectOption(tp,aux.Stringid(26051089,4),aux.Stringid(26051089,5))==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051089,6))
		Duel.SelectOption(tp,aux.Stringid(26051089,7)) 
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051089,8))
		if Duel.SelectOption(tp,aux.Stringid(26051089,9),aux.Stringid(26051089,10))==1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051089,11))
			Duel.SelectOption(tp,aux.Stringid(26051089,15)) 
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051089,8))
			Duel.SelectOption(tp,aux.Stringid(26051089,12))
			if Duel.SelectOption(tp,aux.Stringid(26051089,9),aux.Stringid(26051089,13))==0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26051089,14))
				Duel.SelectOption(tp,aux.Stringid(26051089,15)) 
				Duel.Win(1-tp,1)
			else
				c26051089.CRASH(c,e,tp,tc)
			end
		else 
			c26051089.CRASH(c,e,tp,tc)
		end
	else
		c26051089.CRASH(c,e,tp,tc)
	end
end