--Aetherweight Claidheamh Soluis
function c26055001.initial_effect(c)
	--pendulum effect
		Pendulum.AddProcedure(c)
		--force Summon from Hand/ED/GY
		local pe1=Effect.CreateEffect(c)
		pe1:SetDescription(aux.Stringid(26055001,2))
		pe1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		pe1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		pe1:SetCode(EVENT_BATTLE_DESTROYED)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetCondition(c26055001.fspcon)
		pe1:SetCost(c26055001.fspcost)
		pe1:SetTarget(c26055001.fsptg)
		pe1:SetOperation(c26055001.fspop)
		c:RegisterEffect(pe1)
	--equip effect (equipped by an "Etherweight" card effect)
		--atk up
		local eq1=Effect.CreateEffect(c)
		eq1:SetType(EFFECT_TYPE_EQUIP)
		eq1:SetCode(EFFECT_UPDATE_ATTACK)
		eq1:SetCondition(c26055001.eqcon)
		eq1:SetValue(1000)
		c:RegisterEffect(eq1)
		--force Summon from Hand/ED/GY
		local eq2=pe1:Clone()
		eq2:SetDescription(aux.Stringid(26055001,2))
		eq2:SetRange(LOCATION_SZONE)
		eq2:SetCondition(aux.AND(c26055001.fspcon,c26055001.eqcon))
		c:RegisterEffect(eq2)
	--Monster effects
		--Special Summon Procedure
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26055001,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND|LOCATION_GRAVE|LOCATION_EXTRA)
		e1:SetValue(1)
		e1:SetCondition(c26055001.spcon)
		e1:SetTarget(c26055001.sptg)
		e1:SetOperation(c26055001.spop)
		c:RegisterEffect(e1)
		--Equip 1 "Etherweight" monster to itself
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26055001,1))
		e2:SetCategory(CATEGORY_EQUIP)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetLabel(1)
		e2:SetCondition(c26055001.eqcond)
		e2:SetTarget(c26055001.eqtg)
		e2:SetOperation(c26055001.eqop)
		c:RegisterEffect(e2)
		aux.AddEREquipLimit(c,nil,c26055001.eqval,c26055001.equipop,e2)
		--Monsters cannot activate their effects, except Spirit monsters
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,1)
		e3:SetCondition(c26055001.condition)
		e3:SetValue(aux.TRUE)
		c:RegisterEffect(e3)
end
function c26055001.rsfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsReleasable()
end
function c26055001.s2filter(c,tp,sc)
	return Duel.GetMZoneCount(tp,sg)>=0 or (sc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0)
end
function c26055001.rescon(sg,e,tp,mg)
	local c=e:GetHandler()
	return sg:IsExists(Card.IsSetCard,1,nil,0x655)
	and sg:IsExists(c26055001.s2filter,1,nil,tp,c)
end
function c26055001.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GetMatchingGroup(c26055001.rsfilter,tp,LOCATION_MZONE,0,nil)
	return aux.SelectUnselectGroup(rg,e,tp,3,3,c26055001.rescon,0)
end
function c26055001.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c26055001.rsfilter,tp,LOCATION_MZONE,0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,c26055001.rescon,1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function c26055001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.HintSelection(g,true)
	e:GetHandler():SetMaterial(g)
	Duel.Release(g,REASON_COST|REASON_SPSUMMON)
	g:DeleteGroup()
end
function c26055001.pcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end
function c26055001.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(26055001) and c:GetEquipTarget()
end
function c26055001.eqcond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lb,flag=1,c:GetFlagEffect(26055001)
	if ((c:IsTributeSummoned() and c:IsStatus(STATUS_SUMMON_TURN)) or
	(c:GetSummonType()==SUMMON_TYPE_SPECIAL+1 and c:IsStatus(STATUS_SPSUMMON_TURN))) then lb=e:GetLabel() end
	return c26055001.pcond(e,tp,eg,ep,ev,re,r,rp) and lb>flag
end
function c26055001.eqfilter(c)
	return c:IsSetCard(0x655) and c:IsMonster()
	and (c:IsFaceup() or c:IsLocation(LOCATION_HAND|LOCATION_GRAVE))
	and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c26055001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c26055001.eqfilter,tp,LOCATION_EXTRA|LOCATION_HAND|LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(26055001,RESETS_STANDARD_PHASE_END,0,1)
end
function c26055001.eqval(ec,c,tp)
	return ec:IsControler(tp) and ec:IsType(TYPE_PENDULUM)
end
function c26055001.equipop(c,e,tp,tc)
	c:EquipByEffectAndLimitRegister(e,tp,tc,nil,true)
end
function c26055001.rescon(sg,e,tp,mg)
	return #sg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
end
function c26055001.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26055001.eqfilter),tp,LOCATION_EXTRA|LOCATION_HAND|LOCATION_GRAVE,0,nil)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,3,c26055001.rescon,1,tp,HINTMSG_TODECK,c26055001.rescon)
	local tc=sg:GetFirst()
	for tc in aux.Next(sg) do
		Duel.HintSelection(tc)
		c26055001.equipop(e:GetHandler(),e,tp,tc)
		tc:RegisterFlagEffect(26055001,RESET_EVENT|RESETS_STANDARD,0,1)
	end
end
function c26055001.fspcon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	local rc=des:GetReasonCard()
	return des:IsMonster() and rc:IsRelateToBattle() and rc:IsSetCard(0x655)
end
function c26055001.fspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc and tc:IsAbleToRemoveAsCost() end
	Duel.HintSelection(tc)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabel(tc:GetAttack())
end
function c26055001.fsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,0,LOCATION_HAND|LOCATION_GRAVE|LOCATION_EXTRA,ec)>0 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND|LOCATION_GRAVE|LOCATION_EXTRA)
end
function c26055001.fspfilter(c,e,p,atk)
	return c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEUP,p)
	and c:IsAttackBelow(atk)
end
function c26055001.fspop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local gg=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local xg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,hg)
	Duel.ConfirmCards(tp,gg)
	Duel.ConfirmCards(tp,xg)
	local atk=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
	then hg:Clear() end
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>0
	then gg:Clear() end
	if Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0
	then xg:Clear() end
	local g=hg:Clone(); g:Merge(gg); g:Merge(xg)
	g=g:Filter(c26055001.fspfilter,nil,e,1-tp,atk)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and #g>0 and
	Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(26055001,2))
	then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local tc=g:Select(1-tp,1,1,nil):GetFirst()
		if tc then Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP) end
	end
end
function c26055001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
	and Duel.GetMatchingGroupCount(nil,tp,LOCATION_EXTRA|LOCATION_HAND|LOCATION_GRAVE,0,nil)==0
	and e:GetHandler():GetAttackAnnouncedCount()<1
end