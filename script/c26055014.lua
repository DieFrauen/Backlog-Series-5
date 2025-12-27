--Feather Swords Above Earth
function c26055014.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26055014,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c26055014.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetDescription(aux.Stringid(26055014,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetTarget(c26055014.actg)
	e2:SetOperation(c26055014.activate)
	c:RegisterEffect(e2)
	--shuffle hand and extra
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26055014.tdtg)
	e3:SetOperation(c26055014.tdop)
	c:RegisterEffect(e3)
	--Can be activated from the hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26052014,2))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c26055014.actcon)
	c:RegisterEffect(e4)
	--pendulum summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetDescription(aux.Stringid(26055014,3))
	e5:SetCode(EFFECT_SPSUMMON_PROC_G)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetLabel(2)
	e5:SetCondition(c26055014.pendcon())
	e5:SetOperation(c26055014.penop())
	e5:SetValue(SUMMON_TYPE_PENDULUM)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_SZONE,0)
	e6:SetTarget(c26055014.eftg)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetDescription(aux.Stringid(26055014,4))
	e7:SetLabel(1)
	local e8=e6:Clone()
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
end
function c26055014.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,26055013),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c26055014.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c26055014.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26055014.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c26055014.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26055014.filter,tp,LOCATION_GRAVE,0,nil)
	if #g>0 and
	(e:GetType()&EFFECT_TYPE_TRIGGER_O ==EFFECT_TYPE_TRIGGER_O
	or Duel.SelectYesNo(tp,aux.Stringid(26055014,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c26055014.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return #g1+#g2>0 end
	local g=g1+g2
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c26055014.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_EXTRA,0,nil)
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c26055014.pendcon(e,c,inchain,re,rp)
	 return  function(e,c,inchain,re,rp)
				if c==nil then return true end
				local tp=c:GetControler()
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz or (not inchain and Duel.GetFlagEffect(tp,10000000)>0) then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
					loc=loc+LOCATION_HAND|LOCATION_GRAVE 
				end
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(c26055014.penfilter,1,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
			end
end
function c26055014.eftg(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_PZONE)
end
function c26055014.penop(e,tp,eg,ep,ev,re,r,rp,c,sg,inchain)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg,inchain)
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
				local ft=Duel.GetUsableMZoneCount(tp)
				if e:GetLabel()==2 then 
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				local loc=0
				if ft1>0 then loc=loc+LOCATION_HAND end
				local loc2=LOCATION_GRAVE 
				loc=loc|loc2
				if ft2>0 then loc=loc+LOCATION_EXTRA end
				local tg=nil
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Match(c26055014.penfilter,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
				else
					tg=Duel.GetMatchingGroup(c26055014.penfilter,tp,loc,0,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
				end
				local loc3=LOCATION_HAND+loc2
				ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,loc3))
				ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
				ft2=math.min(ft2,aux.CheckSummonGate(tp) or ft2)
				while true do
					local ct1=tg:FilterCount(Card.IsLocation,nil,loc3)
					local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
					local ct=ft
					if ct1>ft1 then ct=math.min(ct,ft1) end
					if ct2>ft2 then ct=math.min(ct,ft2) end
					local loc=0
					if ft1>0 then loc=loc+loc3 end
					if ft2>0 then loc=loc+LOCATION_EXTRA end
					local g=tg:Filter(Card.IsLocation,sg,loc)
					if #g==0 or ft==0 then break end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tc=Group.SelectUnselect(g,sg,tp,#sg>0,Duel.IsSummonCancelable())
					if not tc then break end
					if sg:IsContains(tc) then
						sg:RemoveCard(tc)
						if tc:IsLocation(loc3) then
							ft1=ft1+1
						else
							ft2=ft2+1
						end
						ft=ft+1
					else
						sg:AddCard(tc)
						if c:IsHasEffect(511007000)~=nil or rpz:IsHasEffect(511007000)~=nil then
							if not c26055014.penfilter(tc,e,tp,lscale,rscale) then
								local pg=sg:Filter(aux.TRUE,tc)
								local ct0,ct3,ct4=#pg,pg:FilterCount(Card.IsLocation,nil,loc3),pg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
								sg:Sub(pg)
								ft1=ft1+ct3
								ft2=ft2+ct4
								ft=ft+ct0
							else
								local pg=sg:Filter(aux.NOT(c26055014.penfilter),nil,e,tp,lscale,rscale)
								sg:Sub(pg)
								if #pg>0 then
									if pg:GetFirst():IsLocation(loc3) then
										ft1=ft1+1
									else
										ft2=ft2+1
									end
									ft=ft+1
								end
							end
						end
						if tc:IsLocation(loc3) then
							ft1=ft1-1
						else
							ft2=ft2-1
						end
						ft=ft-1
					end
				end
				if #sg>0 then
					if not inchain then
						Duel.RegisterFlagEffect(tp,10000000,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
					end
					Duel.HintSelection(Group.FromCards(c),true)
					Duel.HintSelection(Group.FromCards(rpz),true)
					Duel.Hint(HINT_CARD,tp,26055014)
				end
			end
end
function c26055014.penfilter(c,e,tp,lscale,rscale,lvchk)
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local p1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_EXTRA+LOCATION_HAND,0,nil)==0 and 1 or 0
	local p2=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,26055013),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
	and 1 or 0
	local p3=p1+p2+e:GetLabel()
	return (p3>3 or p3>2 and c:IsSetCard(0x655)) and c:IsLocation(LOCATION_HAND|LOCATION_GRAVE)
		and (lvchk or (lv>lscale and lv<rscale) or c:IsHasEffect(511004423)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden()
end