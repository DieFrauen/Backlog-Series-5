--Ethymos - Prime Nomencreation
function c26051005.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,26051002,26051003)
	--Aternative Special Summon procedure
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26051005,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c26051005.hspcon)
	e2:SetTarget(c26051005.hsptg)
	e2:SetOperation(c26051005.hspop)
	c:RegisterEffect(e2)
	--Add 1 "Liddel the Nomencreator" to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26051005,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c26051005.thtg)
	e2:SetOperation(c26051005.thop)
	c:RegisterEffect(e2)
	
end
function c26051005.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(c:GetControler(),c26051005.hspfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,tp,c)
end
function c26051005.hspfilter(c,tp,sc)
	return c:IsCode(26051002,26051003) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c26051005.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectReleaseGroup(tp,c26051005.hspfilter,1,1,false,true,true,c,nil,nil,false,nil,tp,c)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function c26051005.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
	c:SetMaterial(g)
	g:DeleteGroup()
end
function c26051005.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c26051005.thfilter(c)
	return c:IsCode(26051001) and c:IsAbleToHand()
end
function c26051005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26051005.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26051005.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c26051005.thfilter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
