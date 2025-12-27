--Feather Swords Under Heaven (Etherweight)
function c26055013.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(1)
	e1:SetCountLimit(1,26055013,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c26055013.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetDescription(aux.Stringid(26055013,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetLabel(2)
	e2:SetTarget(c26055013.actg)
	e2:SetOperation(c26055013.activate)
	c:RegisterEffect(e2)
	--shuffle hand and GY
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c26055013.tdtg)
	e3:SetOperation(c26055013.tdop)
	c:RegisterEffect(e3)
	--pendulum summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetDescription(aux.Stringid(26055013,2))
	e4:SetCode(EFFECT_SPSUMMON_PROC_G)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetLabel(2)
	e4:SetCondition(c26055013.pendcon())
	e4:SetOperation(c26055013.penop())
	e4:SetValue(SUMMON_TYPE_PENDULUM)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetTarget(c26055013.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(26055013,3))
	e6:SetLabel(1)
	local e7=e5:Clone()
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)
end
function c26055013.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end
function c26055013.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26055013.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c26055013.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26055013.filter,tp,LOCATION_EXTRA,0,nil)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 and
	#g>0 and
	(e:GetLabel()==2 or Duel.SelectYesNo(tp,aux.Stringid(26055013,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c26055013.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND|LOCATION_GRAVE,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND|LOCATION_GRAVE,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c26055013.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND|LOCATION_GRAVE,0)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c26055013.pendcon(e,c,inchain,re,rp)
	 return  function(e,c,inchain,re,rp)
				if c==nil then return true end
				local tp=c:GetControler()
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz or (not inchain and Duel.GetFlagEffect(tp,10000000)>0) then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
					loc=loc+LOCATION_HAND|LOCATION_DECK 
				end
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(c26055013.penfilter,1,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
			end
end
function c26055013.eftg(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_PZONE)
end
function c26055013.penop(e,tp,eg,ep,ev,re,r,rp,c,sg,inchain)
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
				local loc2=LOCATION_DECK 
				loc=loc|loc2
				if ft2>0 then loc=loc+LOCATION_EXTRA end
				local tg=nil
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Match(c26055013.penfilter,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
				else
					tg=Duel.GetMatchingGroup(c26055013.penfilter,tp,loc,0,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
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
							if not c26055013.penfilter(tc,e,tp,lscale,rscale) then
								local pg=sg:Filter(aux.TRUE,tc)
								local ct0,ct3,ct4=#pg,pg:FilterCount(Card.IsLocation,nil,loc3),pg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
								sg:Sub(pg)
								ft1=ft1+ct3
								ft2=ft2+ct4
								ft=ft+ct0
							else
								local pg=sg:Filter(aux.NOT(c26055013.penfilter),nil,e,tp,lscale,rscale)
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
					Duel.Hint(HINT_CARD,tp,26055013)
				end
			end
end
function c26055013.penfilter(c,e,tp,lscale,rscale,lvchk)
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local p1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)==0 and 1 or 0
	local p2=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,26055014),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
	and 1 or 0
	local p3=p1+p2+e:GetLabel()
	return (p3>3 or p3>2 and c:IsSetCard(0x655)) and c:IsLocation(LOCATION_HAND|LOCATION_DECK)
		and (lvchk or (lv>lscale and lv<rscale) or c:IsHasEffect(511004423)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden()
end