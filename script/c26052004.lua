--Ethymos - Prime Nomencreation
function c26052004.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,26052001,{26052002,26052003})
	--Aternative Special Summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26052004,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c26052004.hspcon)
	e1:SetTarget(c26052004.hsptg)
	e1:SetOperation(c26052004.hspop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26052004,1))
	e2:SetCondition(c26052004.hspcon2)
	e2:SetTarget(c26052004.hsptg2)
	e2:SetOperation(c26052004.hspop2)
	c:RegisterEffect(e2)
	--typed fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26052004,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c26052004.cost)
	e3:SetTarget(c26052004.typtg)
	e3:SetOperation(c26052004.typop)
	--c:RegisterEffect(e3)
	--Special Summon 1 "Liddel the Nomencreator"
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(26052004,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetTarget(c26052004.sptg)
	e4:SetOperation(c26052004.spop)
	c:RegisterEffect(e4)
end
c26052004.material={26052001,26052002,26052003}
c26052004.listed_names={26052001,26052002,26052003}
c26052004.material_setcode={0x652}
function c26052004.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(c:GetControler(),c26052004.hspfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,tp,c) and Duel.GetFlagEffect(tp,26052004)==0
end
function c26052004.hspfilter(c,tp,sc)
	return c:IsSetCard(0x652) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsNormalSummoned()
end
function c26052004.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectReleaseGroup(tp,c26052004.hspfilter,1,1,false,true,true,c,nil,nil,false,nil,tp,c)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function c26052004.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
	c:SetMaterial(g)
	g:DeleteGroup()
	Duel.RegisterFlagEffect(tp,26052004,RESET_PHASE|PHASE_END,0,1)
end
function c26052004.hspcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c26052004.hspfilter2,tp,LOCATION_HAND,0,nil)
	return Duel.IsPhase(PHASE_MAIN1 )
	and not Duel.CheckPhaseActivity()
	and g:IsExists(Card.IsReleasable,1,nil)
	and g:GetClassCount(Card.GetCode)>3
	and Duel.GetFlagEffect(tp,26052004)==0
end
function c26052004.hspfilter2(c)
	return c:GetType()&0x11==0x11 and not c:IsPublic()
end
function c26052004.hsptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c26052004.hspfilter2,tp,LOCATION_HAND,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,0,4,aux.dncheck,1,tp,HINTMSG_RELEASE,aux.dncheck,nil,nil,true)
	if #sg==4 then
		local tc=sg:Select(tp,0,1,nil):GetFirst()
		if tc then
			Duel.ConfirmCards(1-tp,sg)
			e:SetLabelObject(tc)
			return true
		else return false end
	else
		return false
	end
end
function c26052004.hspop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
	c:SetMaterial(g)
	Duel.ShuffleHand(tp)
	Duel.RegisterFlagEffect(tp,26052004,RESET_PHASE|PHASE_END,0,1)
end
--function c26052004.contactop(g)  Duel.Release(g,REASON_COST+REASON_MATERIAL) end 
function c26052004.costfilter(c)
	return c:IsMonster() and c:IsReleasable()
end
function c26052004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,26052012)}) do
		fg:AddCard(pe:GetHandler())
	end
	local g1=Duel.GetMatchingGroup(c26052004.costfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,nil)
	if #fg>0 then
		local g2=Duel.GetMatchingGroup(c26052012.costfilter,tp,LOCATION_DECK,0,nil,e,tp)
		g1:Merge(g2)
	end
	if chk==0 then return #g1>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		local fc=nil
		if #fg==1 then
			fc=fg:GetFirst()
		else
			fc=fg:Select(tp,1,1,nil):GetFirst()
		end
		Duel.HintSelection(fc)
		Duel.Hint(HINT_CARD,0,fc:GetCode())
		fc:RegisterFlagEffect(26052012,RESETS_STANDARD_PHASE_END,0,0)
	end
	Duel.SendtoGrave(tc,REASON_COST+REASON_RELEASE)
end
function c26052004.typtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local rc=Duel.AnnounceAnotherRace(Group.FromCards(c),tp)
	e:SetLabel(rc)
end
function c26052004.typop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--treated as all types
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		--treated as Normal
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(26052004,3))
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_NORMAL)
		c:RegisterEffect(e2)
		--treated as Normal
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(26052004,3))
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_EFFECT+TYPE_FUSION)
		c:RegisterEffect(e2)
	end
end
function c26052004.spfilter(c,e,tp)
	return c:IsCode(26052001,26052002,26052003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26052004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26052004.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26052004.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c26052004.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
