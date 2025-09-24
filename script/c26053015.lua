--Elegiac Pianissimo
function c26053015.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE|TIMING_MAIN_END,TIMING_END_PHASE|TIMING_BATTLE_START)
	c:RegisterEffect(e1)
	--Pianissimo
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(26053015)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	--c:RegisterEffect(e2)
	--reduce level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26053015,0))
	e3:SetCategory(CATEGORY_LVCHANGE+CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,26053015,EFFECT_COUNT_CODE_CHAIN)
	e3:SetTarget(c26053015.lvtg)
	e3:SetOperation(c26053015.lvop)
	c:RegisterEffect(e3)
	--summon tokens
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(26053015,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TOKEN)
	e4:SetHintTiming(0,TIMING_BATTLE_START)
	e4:SetTarget(c26053015.tktg)
	e4:SetOperation(c26053015.tkop)
	c:RegisterEffect(e4)
	--return to deck/Ritual Summon
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(26053015,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TODECK)
	e5:SetHintTiming(0,TIMING_BATTLE_START)
	e5:SetTarget(c26053015.tdtg)
	e5:SetOperation(c26053015.tdop)
	c:RegisterEffect(e5)
end
function c26053015.dwfilter(c,num,lv1,lv2,lv3,lv4,lv5)
	local tp=c:GetControler()
	if lv1 and lv1>0 and c:IsLevelBelow(lv1-num) then return false end
	if lv2 and lv2>0 and c:GetLevel()==(lv2-num) then return false end
	if lv3 and lv3>0 and c:GetLevel()==(lv3-num) then return false end
	if lv4 and lv4>0 and c:GetLevel()==(lv4-num) then return false end
	if lv5 and lv5>0 and c:IsLevelAbove(lv5-num) then return false end
	return true
end
function c26053015.lvfilter(c)
	return c:IsMonster() and (c:IsOnField()
	or c:IsSetCard(0x653) --and not c:IsPublic()
	)
end
function c26053015.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_MZONE 
	local lab=e:GetLabel()
	local c=e:GetHandler()
	if chkc then return c26053015.lvfilter(e,tp,0) and chkc:IsLocation(loc) end
	if chk==0 then return c:GetFlagEffect(26053015)==0 and Duel.IsExistingMatchingCard(c26053015.lvfilter,tp,loc+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,c26053015.lvfilter,tp,loc+LOCATION_HAND,loc,1,1,nil):GetFirst()
	Duel.SetTargetCard(tc)
	if tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc) end
	c:RegisterFlagEffect(26053015,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26053015.piano(c)
	return c:IsFaceup() and c:IsCode(26053015)
end
function c26053015.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local lv={1}
		local piano=Duel.GetMatchingGroupCount(c26053015.piano,tp,LOCATION_ONFIELD,0,nil)
		for vl=1,piano do
			if tc:GetLevel()-piano>0 then
			lv[vl]=vl end
		end
		local ct=Duel.AnnounceNumber(tp,table.unpack(lv))
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			--tc:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT|(RESETS_STANDARD_PHASE_END&~RESET_TOFIELD))
		e2:SetValue(-ct)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(ct*-100)
		tc:RegisterEffect(e3)
	end
end
function c26053015.tkfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeEffectTarget(e) and 
	Duel.IsPlayerCanSpecialSummonMonster(tp,26053101,0x1653,TYPES_TOKEN,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute(),POS_FACEUP,tp)
end
function c26053015.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x1653)
	and sg:GetClassCount(Card.GetLevel)==#sg
end
function c26053015.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26053015.tkfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chkc then return --chkc:IsControler(tp) and 
	chkc:IsLocation(LOCATION_GRAVE) and c26053015.tkfilter(chkc,e,tp) end
	if chk==0 then return c:GetFlagEffect(26053015)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and aux.SelectUnselectGroup(g,e,tp,2,2,c26053015.rescon,0) end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,2,c26053015.rescon,1,tp,HINTMSG_TARGET)
	Duel.SetTargetCard(tg)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	c:RegisterFlagEffect(26053015,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26053015.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	if #sg==0 then return end
	local tkg=Group.CreateGroup()
	local ec=sg:GetFirst()
	local RESETS =RESET_EVENT|RESETS_STANDARD&~RESET_TOFIELD
	while ec do
		local code=26053101
		local c=e:GetHandler()
		atk,def,lv,rce,att=
		ec:GetAttack(),ec:GetDefense(),
		ec:GetLevel(),ec:GetRace(),
		ec:GetAttribute()
		if lv<12 then code=26053100+lv end
		local token=Duel.CreateToken(tp,code)
		c:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atk)
		e1:SetReset(RESETS)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(def)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CHANGE_RACE)
		e3:SetValue(rce)
		e3:SetReset(RESETS)
		token:RegisterEffect(e3,true)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e4:SetValue(att)
		token:RegisterEffect(e4,true)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e5:SetValue(lv)
		token:RegisterEffect(e5,true)
		--Cannot be used as Fusion material
		local e6=e3:Clone()
		e6:SetDescription(3309)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e6:SetValue(1)
		token:RegisterEffect(e6,true)
		--Cannot be used as Synchro material
		local e7=e2:Clone()
		e7:SetDescription(3310)
		e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e7,true)
		--Cannot be used as Link material
		local e8=e2:Clone()
		e8:SetDescription(3312)
		e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e8,true)
		tkg:AddCard(token)
		ec=sg:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tkg=tkg:Select(tp,1,ft,nil)
	Duel.SpecialSummon(tkg,0,tp,tp,false,false,POS_FACEUP)
end
function c26053015.tdfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeEffectTarget(e)
	and c:IsAbleToDeck()
end
function c26053015.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26053015.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chkc then return false end
	if chk==0 then return c:GetFlagEffect(26053015)==0 and
	aux.SelectUnselectGroup(g,e,tp,3,3,c26053015.rescon,0) end
	local tg=aux.SelectUnselectGroup(g,e,tp,3,3,c26053015.rescon,1,tp,HINTMSG_TODECK)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	c:RegisterFlagEffect(26053015,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26053015.tdop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetTargetCards(e):Filter(Card.IsRelateToEffect,nil,e)
	if #g>2 then
		e:SetLabelObject(g)
		local rparams={lvtype=RITPROC_EQUAL,
				filter=aux.FilterBoolFunction(Card.IsSetCard,0x2653),
				location=LOCATION_HAND|LOCATION_DECK,
				extrafil=c26053015.extramat,
				extraop=c26053015.extraop,
				forcedselection=c26053015.ritcheck}
		local rtg,rop=Ritual.Target(rparams),Ritual.Operation(rparams)
		if rtg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(26053015,3)) then
			rop(e,tp,eg,ep,ev,re,r,rp)
		else Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
	end
end
function c26053015.extramat(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetLabelObject()
end
function c26053015.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	if tc:IsLocation(LOCATION_DECK) and Duel.GetFlagEffect(tp,26053011)==0 then
		Duel.RegisterFlagEffect(tp,26053011,RESET_PHASE|PHASE_END,0,1)
	end
	local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	mat:Sub(mat2)
	Duel.ReleaseRitualMaterial(mat);Duel.SendtoDeck(mat2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function c26053015.three(c,g)
	return g:IsContains(c)
end
function c26053015.ritcheck(e,tp,g,sc)
	local eg=e:GetLabelObject()
	return eg and #eg==3 and #g==3
	and g:IsExists(c26053015.three,3,nil,eg) 
	and (Duel.IsPlayerAffectedByEffect(tp,26053011)
	and g:GetSum(Card.GetLevel)==sc:GetLevel()
	and sc:IsSetCard(0x2653)
	or not sc:IsLocation(LOCATION_DECK))
end