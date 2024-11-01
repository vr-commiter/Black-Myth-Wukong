local truegear = require "truegear"

local resetHook = true
local hookIds = {}

local canRelife = true 
local canTeleport = true
local enemyEffectID = nil

local VioletHail = 0
local AshenSlumber = 0
local playerYaw = 0
local isAshenSlumberHeavyAttack = false
local isVioletHailHeavyAttack = false
local spellId = nil
local canMeleeHit = true

function SendMessage(context)
	if context then
		print(context .. "\n")
		return
	end
	print("nil\n")
end

function PlayAngle(event,tmpAngle,tmpVertical)

	local rootObject = truegear.find_effect(event);

	local angle = (tmpAngle - 22.5 > 0) and (tmpAngle - 22.5) or (360 - tmpAngle)
	
    local horCount = math.floor(angle / 45) + 1
	local verCount = (tmpVertical > 0.1) and -4 or (tmpVertical < 0 and 8 or 0)


	for kk, track in pairs(rootObject.tracks) do
        if tostring(track.action_type) == "Shake" then
            for i = 1, #track.index do
                if verCount ~= 0 then
                    track.index[i] = track.index[i] + verCount
                end
                if horCount < 8 then
                    if track.index[i] < 50 then
                        local remainder = track.index[i] % 4
                        if horCount <= remainder then
                            track.index[i] = track.index[i] - horCount
                        elseif horCount <= (remainder + 4) then
                            local num1 = horCount - remainder
                            track.index[i] = track.index[i] - remainder + 99 + num1
                        else
                            track.index[i] = track.index[i] + 2
                        end
                    else
                        local remainder = 3 - (track.index[i] % 4)
                        if horCount <= remainder then
                            track.index[i] = track.index[i] + horCount
                        elseif horCount <= (remainder + 4) then
                            local num1 = horCount - remainder
                            track.index[i] = track.index[i] + remainder - 99 - num1
                        else
                            track.index[i] = track.index[i] - 2
                        end
                    end
                end
            end
            if track.index then
                local filteredIndex = {}
                for _, v in pairs(track.index) do
                    if not (v < 0 or (v > 19 and v < 100) or v > 119) then
                        table.insert(filteredIndex, v)
                    end
                end
                track.index = filteredIndex
            end
        elseif tostring(track.action_type) ==  "Electrical" then
            for i = 1, #track.index do
                if horCount <= 4 then
                    track.index[i] = 0
                else
                    track.index[i] = 100
                end
            end
            if horCount == 1 or horCount == 8 or horCount == 4 or horCount == 5 then
                track.index = {0, 100}
            end
        end
    end

	truegear.play_effect_by_content(rootObject)
end

function RegisterHooks()

	for k,v in pairs(hookIds) do
		UnregisterHook(k, v.id1, v.id2)
	end
		
	hookIds = {}

	local funcName = "/Script/Engine.Character:Jump"
	local hook1, hook2 = RegisterHook(funcName, Jump)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
	
	local funcName = "/Script/b1-Managed.BUS_GSEventCollection:Evt_TriggerNormalDamageEffectMultiCast"
	local hook1, hook2 = RegisterHook(funcName, NormalDamage)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
	
	local funcName = "/Script/b1-Managed.BUS_GSEventCollection:Evt_TriggerSkillEffectBySkillMultiCast"
	local hook1, hook2 = RegisterHook(funcName, SpellSkill)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

	local funcName = "/Script/b1-Managed.BUS_GSEventCollection:Evt_SmartCastSkillTryMultiCast"
	local hook1, hook2 = RegisterHook(funcName, SmartCastSkill)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
	
	local funcName = "/Script/b1-Managed.BUS_GSEventCollection:Evt_DropCollectionItemMultiCast"
	local hook1, hook2 = RegisterHook(funcName, CollectItem)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

	local funcName = "/Script/b1-Managed.BUS_GSEventCollection:Evt_SetActorTransform_Multicast_Invoke"
	local hook1, hook2 = RegisterHook(funcName, ActorTransform)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

	local funcName = "/Script/b1-Managed.BUS_GSEventCollection:Evt_TriggerPlayerRestMultiCast"
	local hook1, hook2 = RegisterHook(funcName, PlayerRest)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
	
	local funcName = "/Script/b1-Managed.BUS_GSEventCollection:Evt_BuffInstsDictOnAdd_Multicast_Invoke"
	local hook1, hook2 = RegisterHook(funcName, BuffInstsDictOnAdd)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

	local funcName = "/Script/b1-Managed.BUS_GSEventCollection:Evt_CastSkillWithAnimMontageMultiCast"
	local hook1, hook2 = RegisterHook(funcName, MonkeySummon)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

end


-- *******************************************************************

function MonkeySummon(self,p1)
	if spellId == nil then
		return
	end
	SendMessage("--------------------------------")
	if spellId == 24071 then
		SendMessage("AzureDomeSepll1")
		truegear.play_effect_by_uuid("AzureDomeSepll1")
	elseif spellId == 24081 then
		SendMessage("AzureDomeSepll2")
		truegear.play_effect_by_uuid("AzureDomeSepll2")
	elseif spellId == 24091 then
		SendMessage("AzureDomeSepll3")
		truegear.play_effect_by_uuid("AzureDomeSepll3")
	end
	spellId = nil
end

function SpiritsSomersault(name)
	if string.find(name,"gycy_lang") then
		SendMessage("RedTidesSomersault")
		truegear.play_effect_by_uuid("RedTidesSomersault")
	elseif string.find(name,"hfm_hu") then
		SendMessage("EbonFlowSomersault")
		truegear.play_effect_by_uuid("EbonFlowSomersault")
	elseif string.find(name,"lys_shu") then
		SendMessage("AshenSlumberSomersault")
		truegear.play_effect_by_uuid("AshenSlumberSomersault")
	elseif string.find(name,"lys_yao") then
		SendMessage("HoarfrosthanSomersault")
		truegear.play_effect_by_uuid("HoarfrosthanSomersault")
	elseif string.find(name,"lys_hou") then
		SendMessage("UmbralAbyssSomersault")
		truegear.play_effect_by_uuid("UmbralAbyssSomersault")
	elseif string.find(name,"psd_chong") then
		SendMessage("VioletHailSomersault")
		truegear.play_effect_by_uuid("VioletHailSomersault")
	elseif string.find(name,"psd_long") then
		SendMessage("GoldenLiningSomersault")
		truegear.play_effect_by_uuid("GoldenLiningSomersault")
	elseif string.find(name,"hys_ma") then
		SendMessage("DarkThunderSomersault")
		truegear.play_effect_by_uuid("DarkThunderSomersault")
	elseif string.find(name,"mgd_yuan") then
		SendMessage("AzureDomeSomersault")
		truegear.play_effect_by_uuid("AzureDomeSomersault")
	end
end

function BuffInstsDictOnAdd(self,BuffID,Duration,BuffSourceType,Caster)
	if string.find(Caster:get():GetFullName(),"Player") or string.find(Caster:get():GetFullName(),"player") then
		SendMessage("--------------------------------")
		if tostring(BuffID:get()) == "21165" and tostring(BuffSourceType:get()) == "44" then			
			SendMessage("TakeMedicine")
			truegear.play_effect_by_uuid("TakeMedicine")
		elseif tostring(BuffID:get()) == "306" and tostring(BuffSourceType:get()) == "32" then	
			SendMessage("PlayerInteraction")
			truegear.play_effect_by_uuid("PlayerInteraction")
		elseif tostring(BuffSourceType:get()) == "69" then
			if tostring(BuffID:get()) == "20129" then
				SendMessage("SpiritsVerdantGlow")
				truegear.play_effect_by_uuid("SpiritsVerdantGlow")
			elseif tostring(BuffID:get()) == "20136" then
				SendMessage("SpiritsFlintChief")
				truegear.play_effect_by_uuid("SpiritsFlintChief")
			end
		elseif tostring(BuffSourceType:get()) == "19" then
			if tostring(BuffID:get()) == "10131" or tostring(BuffID:get()) == "10141" or tostring(BuffID:get()) == "10145" then
				SendMessage("EquipFabao")
				truegear.play_effect_by_uuid("EquipFabao")
			end
		elseif tostring(BuffID:get()) == "10004" and tostring(BuffSourceType:get()) == "7" then
			SendMessage("--------------------------------")
			SendMessage("Teleport")
			truegear.play_effect_by_uuid("Teleport")
			SendMessage(self:get():GetFullName())
			canRelife = false
		elseif tostring(BuffID:get()) == "107" and tostring(BuffSourceType:get()) == "7" then
			canMeleeHit = true
			SpiritsSomersault(self:get():GetFullName())
		elseif tostring(BuffID:get()) == "10111" and tostring(BuffSourceType:get()) == "7" then
			SendMessage("--------------------------------")
			SendMessage("LifeSavingStrand")
			truegear.play_effect_by_uuid("LifeSavingStrand")
		end
		SendMessage("BuffInstsDictOnAdd")
		SendMessage(self:get():GetFullName())
		SendMessage(tostring(BuffID:get()))
		SendMessage(tostring(Duration:get()))
		SendMessage(tostring(BuffSourceType:get()))
		SendMessage(tostring(Caster:get():GetFullName()))
	end
end


function PlayerRest(self)
	SendMessage("--------------------------------")
	SendMessage("PlayerRest")
	truegear.play_effect_by_uuid("PlayerRest")
	SendMessage(self:get():GetFullName())
end


function Teleport(self)
	if string.find(self:get():GetFullName(),"Player") or string.find(self:get():GetFullName(),"player") then
		if canTeleport then
			SendMessage("--------------------------------")
			SendMessage("Teleport")
			truegear.play_effect_by_uuid("Teleport")
			SendMessage(self:get():GetFullName())
			canRelife = false
		end
		canTeleport = true
	end
end

function ActorTransform(self)
	if string.find(self:get():GetFullName(),"Player") or string.find(self:get():GetFullName(),"player") then
		SendMessage("--------------------------------")
		SendMessage("PlayerTransform")
		truegear.play_effect_by_uuid("PlayerTransform")
		SendMessage(self:get():GetFullName())
	end
end

function SmartCastSkill(self,ID)
	local id = ID:get()
	SendMessage("--------------------------------")
	if id == 11320 or id == 11220 or id == 10120 then----------------------------------------不空
		canMeleeHit = false
		SendMessage("SpiritsNonVoid")
		truegear.play_effect_by_uuid("SpiritsNonVoid")
	elseif id == 11315 or id == 11215 or id == 10115 then----------------------------------------百目真人
		canMeleeHit = false
		SendMessage("SpiritsGoreEyeDaoist")
		truegear.play_effect_by_uuid("SpiritsGoreEyeDaoist")
	elseif id == 11313 or id == 11213 or id == 10113 then----------------------------------------幽魂
		canMeleeHit = false
		SendMessage("SpiritsWanderingWight")
		truegear.play_effect_by_uuid("SpiritsWanderingWight")
	elseif id == 11398 or id == 11298 or id == 10198 then----------------------------------------电蛙
		canMeleeHit = false
		SendMessage("SpiritsBawBawLangLang")
		truegear.play_effect_by_uuid("SpiritsBawBawLangLang")
	elseif id == 11399 or id == 11299 or id == 10199 then ----------------------------------------石蛙
		canMeleeHit = false
		SendMessage("SpiritsBawBawLangLang")
		truegear.play_effect_by_uuid("SpiritsBawBawLangLang")
	elseif id == 11396 or id == 11296 or id == 10196 then ----------------------------------------火蛙
		canMeleeHit = false
		SendMessage("SpiritsBawBawLangLang")
		truegear.play_effect_by_uuid("SpiritsBawBawLangLang")
	elseif id == 11397 or id == 11297 or id == 10197 then ----------------------------------------毒蛙
		canMeleeHit = false
		SendMessage("SpiritsBawBawLangLang")
		truegear.play_effect_by_uuid("SpiritsBawBawLangLang")
	elseif id == 11395 or id == 11295 or id == 10195 then ----------------------------------------寒蛙
		canMeleeHit = false
		SendMessage("SpiritsBawBawLangLang")
		truegear.play_effect_by_uuid("SpiritsBawBawLangLang")
	elseif id == 11311 or id == 11211 or id == 10111 then ----------------------------------------广谋
		canMeleeHit = false
		SendMessage("SpiritsGuangmou")
		truegear.play_effect_by_uuid("SpiritsGuangmou")
	elseif id == 11365 or id == 11265 or id == 10165 then ----------------------------------------骨悚然
		canMeleeHit = false
		SendMessage("SpiritsSpearbone")
		truegear.play_effect_by_uuid("SpiritsSpearbone")
	elseif id == 11367 or id == 11267 or id == 10167 then ----------------------------------------疾蝠
		canMeleeHit = false
		SendMessage("SpiritsSwiftBat")
		truegear.play_effect_by_uuid("SpiritsSwiftBat")
	elseif id == 11392 or id == 11292 or id == 10192 then ----------------------------------------九叶灵芝精
		canMeleeHit = false
		SendMessage("SpiritsNineCappedLingzhiGuai")
		truegear.play_effect_by_uuid("SpiritsNineCappedLingzhiGuai")
	elseif id == 11339 or id == 11239 or id == 10139 then ----------------------------------------火灵元母
		canMeleeHit = false
		SendMessage("SpiritsMotherofFlamlings")
		truegear.play_effect_by_uuid("SpiritsMotherofFlamlings")
	elseif id == 11388 or id == 11288 or id == 10188 then ----------------------------------------雾里云。云里雾
		canMeleeHit = false
		SendMessage("SpiritsMistyCloudCloudyMist")
		truegear.play_effect_by_uuid("SpiritsMistyCloudCloudyMist")
	elseif id == 11333 or id == 11233 or id == 10133 then ----------------------------------------石父
		canMeleeHit = false
		SendMessage("SpiritsFatherofStones")
		truegear.play_effect_by_uuid("SpiritsFatherofStones")
	elseif id == 11327 or id == 11227 or id == 10127 then ----------------------------------------虫总兵
		canMeleeHit = false
		SendMessage("SpiritsBeetleCommander")
		truegear.play_effect_by_uuid("SpiritsBeetleCommander")
	elseif id == 11331 or id == 11231 or id == 10131 then ----------------------------------------百足虫
		canMeleeHit = false
		SendMessage("SpiritsCentipedeGuai")
		truegear.play_effect_by_uuid("SpiritsCentipedeGuai")
	elseif id == 11322 or id == 11222 or id == 10122 then ----------------------------------------无量蝠
		canMeleeHit = false
		SendMessage("SpiritsApramanaBat")
		truegear.play_effect_by_uuid("SpiritsApramanaBat")
	elseif id == 11324 or id == 11224 or id == 10124 then ----------------------------------------不净
		canMeleeHit = false
		SendMessage("SpiritsNonPure")
		truegear.play_effect_by_uuid("SpiritsNonPure")
	elseif id == 11325 or id == 11225 or id == 10125 then ----------------------------------------不白
		canMeleeHit = false
		SendMessage("SpiritsNonWhite")
		truegear.play_effect_by_uuid("SpiritsNonWhite")
	elseif id == 11326 or id == 11226 or id == 10126 then ----------------------------------------不能
		canMeleeHit = false
		SendMessage("SpiritsNonAble")
		truegear.play_effect_by_uuid("SpiritsNonAble")
	elseif id == 11340 or id == 11240 or id == 10140 then ----------------------------------------老人参精
		canMeleeHit = false
		SendMessage("SpiritsOldGinsengGuai")
		truegear.play_effect_by_uuid("SpiritsOldGinsengGuai")
	elseif id == 11362 or id == 11262 or id == 10162 then ----------------------------------------疯虎
		canMeleeHit = false
		SendMessage("SpiritsMadTiger")
		truegear.play_effect_by_uuid("SpiritsMadTiger")
	elseif id == 11317 or id == 11217 or id == 10117 then ----------------------------------------虎伥
		canMeleeHit = false
		SendMessage("SpiritsTigersAcolyte")
		truegear.play_effect_by_uuid("SpiritsTigersAcolyte")
	elseif id == 11363 or id == 11263 or id == 10163 then ----------------------------------------沙二郎
		canMeleeHit = false
		SendMessage("SpiritsSecondRatPrince")
		truegear.play_effect_by_uuid("SpiritsSecondRatPrince")
	elseif id == 11370 or id == 11270 or id == 10170 then ----------------------------------------地狼
		canMeleeHit = false
		SendMessage("SpiritsEarthWolf")
		truegear.play_effect_by_uuid("SpiritsEarthWolf")
	elseif id == 11387 or id == 11287 or id == 10187 then ----------------------------------------牯都督
		canMeleeHit = false
		SendMessage("SpiritsBullGovernor")
		truegear.play_effect_by_uuid("SpiritsBullGovernor")
	elseif id == 11334 or id == 11234 or id == 10134 then ----------------------------------------地罗刹
		canMeleeHit = false
		SendMessage("SpiritsEarthRakshasa")
		truegear.play_effect_by_uuid("SpiritsEarthRakshasa")
	elseif id == 11386 or id == 11286 or id == 10186 then ----------------------------------------黑脸鬼
		canMeleeHit = false
		SendMessage("SpiritsCharface")
		truegear.play_effect_by_uuid("SpiritsCharface")
	elseif id == 11383 or id == 11283 or id == 10183 then ----------------------------------------蛇捕头
		canMeleeHit = false
		SendMessage("SpiritsSnakeSheriff")
		truegear.play_effect_by_uuid("SpiritsSnakeSheriff")
	elseif id == 11379 or id == 11279 or id == 10179 then ----------------------------------------蜻蜓精
		canMeleeHit = false
		SendMessage("SpiritsDragonflyGuai")
		truegear.play_effect_by_uuid("SpiritsDragonflyGuai")
	elseif id == 11328 or id == 11228 or id == 10128 then ----------------------------------------儡婢士
		canMeleeHit = false
		SendMessage("SpiritsPuppetTick")
		truegear.play_effect_by_uuid("SpiritsPuppetTick")
	elseif id == 11381 or id == 11281 or id == 10181 then ----------------------------------------傀蛛士
		canMeleeHit = false
		SendMessage("SpiritsPuppetSpider")
		truegear.play_effect_by_uuid("SpiritsPuppetSpider")
	elseif id == 11372 or id == 11272 or id == 10172 then ----------------------------------------赤发鬼
		canMeleeHit = false
		SendMessage("SpiritsRedHairedYaksha")
		truegear.play_effect_by_uuid("SpiritsRedHairedYaksha")
	elseif id == 11377 or id == 11277 or id == 10177 then ----------------------------------------鸦香客
		canMeleeHit = false
		SendMessage("SpiritsCrowDiviner")
		truegear.play_effect_by_uuid("SpiritsCrowDiviner")
	elseif id == 11371 or id == 11271 or id == 10171 then ----------------------------------------隼居士
		canMeleeHit = false
		SendMessage("SpiritsFalconHermit")
		truegear.play_effect_by_uuid("SpiritsFalconHermit")
	elseif id == 11342 or id == 11242 or id == 10142 then ----------------------------------------菇男
		canMeleeHit = false
		SendMessage("SpiritsFungiman")
		truegear.play_effect_by_uuid("SpiritsFungiman")
	elseif id == 11376 or id == 11276 or id == 10176 then ----------------------------------------巡山鬼
		canMeleeHit = false
		SendMessage("SpiritsMountainPatroller")
		truegear.play_effect_by_uuid("SpiritsMountainPatroller")
	elseif id == 11314 or id == 11214 or id == 10114 then ----------------------------------------鼠司空
		canMeleeHit = false
		SendMessage("SpiritsRatGovernor")
		truegear.play_effect_by_uuid("SpiritsRatGovernor")
	elseif id == 11368 or id == 11268 or id == 10168 then ----------------------------------------石双
		canMeleeHit = false
		SendMessage("SpiritsPoisestone")
		truegear.play_effect_by_uuid("SpiritsPoisestone")
	elseif id == 11364 or id == 11264 or id == 10164 then ----------------------------------------鼠禁卫
		canMeleeHit = false
		SendMessage("SpiritsRatImperialGuard")
		truegear.play_effect_by_uuid("SpiritsRatImperialGuard")
	elseif id == 11366 or id == 11266 or id == 10166 then ----------------------------------------狸侍长
		canMeleeHit = false
		SendMessage("SpiritsCivetSergeant")
		truegear.play_effect_by_uuid("SpiritsCivetSergeant")
	elseif id == 11369 or id == 11269 or id == 10169 then ----------------------------------------鼠弩手
		canMeleeHit = false
		SendMessage("SpiritsRatArcher")
		truegear.play_effect_by_uuid("SpiritsRatArcher")
	elseif id == 11341 or id == 11241 or id == 10141 then ----------------------------------------蘑女
		canMeleeHit = false
		SendMessage("SpiritsFungiwoman")
		truegear.play_effect_by_uuid("SpiritsFungiwoman")
	elseif id == 11338 or id == 11238 or id == 10138 then ----------------------------------------琴螂仙
		canMeleeHit = false
		SendMessage("SpiritsElderAmourworm")
		truegear.play_effect_by_uuid("SpiritsElderAmourworm")
	elseif id == 11337 or id == 11237 or id == 10137 then ----------------------------------------燧先锋
		canMeleeHit = false
		SendMessage("SpiritsFlintVanguard")
		truegear.play_effect_by_uuid("SpiritsFlintVanguard")
	elseif id == 11332 or id == 11232 or id == 10132 then ----------------------------------------兴烘掀·掀烘兴
		canMeleeHit = false
		SendMessage("SpiritsTopTakesBottomBottomTakesTop")
		truegear.play_effect_by_uuid("SpiritsTopTakesBottomBottomTakesTop")
	elseif id == 11335 or id == 11235 or id == 10135 then ----------------------------------------鳖宝
		canMeleeHit = false
		SendMessage("SpiritsTurtleTreasure")
		truegear.play_effect_by_uuid("SpiritsTurtleTreasure")
	elseif id == 11384 or id == 11284 or id == 10184 then ----------------------------------------蛇司药
		canMeleeHit = false
		SendMessage("SpiritsSnakeHerbalist")
		truegear.play_effect_by_uuid("SpiritsSnakeHerbalist")
	elseif id == 11385 or id == 11285 or id == 10185 then ----------------------------------------幽灯鬼
		canMeleeHit = false
		SendMessage("SpiritsLanternHolder")
		truegear.play_effect_by_uuid("SpiritsLanternHolder")
	elseif id == 11374 or id == 11274 or id == 10174 then ----------------------------------------泥塑金刚
		canMeleeHit = false
		SendMessage("SpiritsClayVajra")
		truegear.play_effect_by_uuid("SpiritsClayVajra")
	elseif id == 11373 or id == 11273 or id == 10173 then ----------------------------------------戒刀僧
		canMeleeHit = false
		SendMessage("SpiritsBladeMonk")
		truegear.play_effect_by_uuid("SpiritsBladeMonk")
	elseif id == 11375 or id == 11275 or id == 10175 then ----------------------------------------夜叉奴
		canMeleeHit = false
		SendMessage("SpiritsEnslavedYaksha")
		truegear.play_effect_by_uuid("SpiritsEnslavedYaksha")
	elseif id == 11361 or id == 11261 or id == 10161 then ----------------------------------------狼刺客
		canMeleeHit = false
		SendMessage("SpiritsWolfAssassin")
		truegear.play_effect_by_uuid("SpiritsWolfAssassin")
	elseif id == 11378 or id == 11278 or id == 10178 then ----------------------------------------虫校尉
		canMeleeHit = false
		SendMessage("SpiritsBeetleCaptain")
		truegear.play_effect_by_uuid("SpiritsBeetleCaptain")
	elseif id == 11330 or id == 11230 or id == 10130 then ----------------------------------------蝎太子
		canMeleeHit = false
		SendMessage("SpiritsScorpionPrince")
		truegear.play_effect_by_uuid("SpiritsScorpionPrince")
	elseif id == 18030 then----------------------------------------藕雹
		isVioletHailHeavyAttack = true
	elseif id == 18031 then
		isVioletHailHeavyAttack = false
	elseif id == 15030 or id == 15032 or id == 15033 or id == 15040 then--------------------------灰蛰
		isAshenSlumberHeavyAttack = true
	elseif id == 15031 or id == 15041 then
		isAshenSlumberHeavyAttack = false
	elseif id == 24071 or id == 24072 or id == 24073 then--------------------------青穹
		spellId = 24071
	elseif id == 24081 or id == 24082 then
		spellId = 24081
	elseif id == 24091 then
		spellId = 24091
	end
	SendMessage("SmartCastSkill")
	SendMessage(self:get():GetFullName())	
	SendMessage(tostring(ID:get()))
end

function CollectItem(self)
	SendMessage("--------------------------------")
	SendMessage("CollectItem")
	truegear.play_effect_by_uuid("CollectItem")
	SendMessage(self:get():GetFullName())	
end

function SpellSkill(self,EffectID,Caster,Target,EffectInstReq)
	if string.find(self:get():GetFullName(),"Player") then		
	SendMessage("--------------------------------")
		if EffectID:get() == 1090351 then						-- 出生	
			if(canRelife) then 
				SendMessage("ReLife")
				truegear.play_effect_by_uuid("ReLife")
			end
			canRelife = true
		elseif EffectID:get() == 1030101 then					-- 翻滚
			SendMessage("Somersault1")
			truegear.play_effect_by_uuid("Somersault1")
		elseif EffectID:get() == 1030201 then
			SendMessage("Somersault2")
			truegear.play_effect_by_uuid("Somersault2")
		elseif EffectID:get() == 1030301 then
			SendMessage("Somersault3")
			truegear.play_effect_by_uuid("Somersault3")
		elseif EffectID:get() == 1081751 then					-- 棍花
			SendMessage("Spin")
			truegear.play_effect_by_uuid("Spin")
		elseif EffectID:get() == 1082351 then
			SendMessage("MobileSpin")
			truegear.play_effect_by_uuid("MobileSpin")
		elseif EffectID:get() == 1090251 then					-- 喝酒
			SendMessage("Healing")
			truegear.play_effect_by_uuid("Healing")			
		elseif EffectID:get() == 1021012 then					-- 劈棍式
			SendMessage("SmashStanceStart")
			truegear.play_effect_by_uuid("SmashStanceStart")
		elseif EffectID:get() == 1021011 then
			SendMessage("SmashStanceCharged")
			truegear.play_effect_by_uuid("SmashStanceCharged")
		elseif EffectID:get() == 1080651 then					-- 立棍式
			SendMessage("PillarStanceStart")
			truegear.play_effect_by_uuid("PillarStanceStart")
		elseif EffectID:get() == 1080751 then
			SendMessage("PillarStanceCharged")
			truegear.play_effect_by_uuid("PillarStanceCharged")
		elseif EffectID:get() == 1087051 then					-- 戳棍式
			SendMessage("ThrustStanceStart")
			truegear.play_effect_by_uuid("ThrustStanceStart")
		elseif EffectID:get() == 1087151 then
			SendMessage("ThrustStanceCharged")
			truegear.play_effect_by_uuid("ThrustStanceCharged")
		elseif EffectID:get() == 1071351 then
			SendMessage("TacticalRetreat")
			truegear.play_effect_by_uuid("TacticalRetreat")
		elseif EffectID:get() == 1051851 then					-- 定身术
			SendMessage("Immobilize")
			truegear.play_effect_by_uuid("Immobilize")
		elseif EffectID:get() == 1051651 then					-- 分身术
			SendMessage("APluckodMany")
			truegear.play_effect_by_uuid("APluckodMany")
		elseif EffectID:get() == 1009501 then					-- 隐身术
			SendMessage("CloudStep")
			truegear.play_effect_by_uuid("CloudStep")
		elseif EffectID:get() == 1009602 then					-- 云步后强普
			SendMessage("CloudStepAddLightAttack")
			truegear.play_effect_by_uuid("CloudStepAddLightAttack")	
		elseif EffectID:get() == 1052101 then					-- 禁字法
			SendMessage("SpellBinder")
			truegear.play_effect_by_uuid("SpellBinder")
		elseif EffectID:get() == 1052051 then					-- 安身法
			SendMessage("RingOfFire")
			truegear.play_effect_by_uuid("RingOfFire")
		elseif EffectID:get() == 1050551 then					-- 铜头铁臂
			SendMessage("RockSolid")
			truegear.play_effect_by_uuid("RockSolid")
		elseif EffectID:get() == 1096101 then					-- 汲取
			SendMessage("Absorb")
			truegear.play_effect_by_uuid("Absorb")
		elseif EffectID:get() == 1096001 then					-- 长汲取
			SendMessage("LongerAbsorb")
			truegear.play_effect_by_uuid("LongerAbsorb")
		elseif EffectID:get() == 1099501 then					-- 芭蕉扇
			SendMessage("UsePlantainFan")
			truegear.play_effect_by_uuid("UsePlantainFan")
		end
		SendMessage("SpellSkill")
		SendMessage(self:get():GetFullName())	
		SendMessage(tostring(EffectID:get()))	
		SendMessage(Caster:get():GetFullName())	
		SendMessage(Target:get():GetFullName())	
	else
		if string.find(Target:get():GetFullName(),"Player") then
			playerYaw = Target:get():GetPropertyValue("Controller"):GetPropertyValue("PlayerCameraManager"):GetPropertyValue("ViewTarget").POV.Rotation.Yaw;
			SendMessage("--------------------------------")
			SendMessage(tostring(EffectID:get()))	
			enemyEffectID = EffectID:get()
		end
	end
end

function Jump(self)
	SendMessage("--------------------------------")
	SendMessage("Jump")
	truegear.play_effect_by_uuid("Jump")
	SendMessage(self:get():GetFullName())	
end


function NormalDamage(self,Attacker,SkillDamageConfig,EffectInstReq,Attacker_AttrMemData)
	if string.find(self:get():GetFullName(),"_summon_") then
		return
	end
	if string.find(self:get():GetFullName(),"player") or string.find(self:get():GetFullName(),"Player") then
		SendMessage("--------------------------------")
		SendMessage("PlayerDamage")
	else
		if string.find(Attacker:get():GetFullName(),"Player") and canMeleeHit then
			SendMessage("--------------------------------")
			SendMessage("PlayerMeleeHit")
			truegear.play_effect_by_uuid("PlayerMeleeHit")
		elseif string.find(Attacker:get():GetFullName(),"player") and canMeleeHit then
			SendMessage("--------------------------------")
			SendMessage("PlayerMeleeHit")
			truegear.play_effect_by_uuid("PlayerMeleeHit")
		end
		SendMessage(Attacker:get():GetFullName())	
		return
	end
	if enemyEffectID == 30220299 then
		return
	end
	local angleYaw = playerYaw - Attacker:get():GetPropertyValue("Controller"):GetPropertyValue("ControlRotation").Yaw
	angleYaw = angleYaw + 180
	if angleYaw > 360 then 
		angleYaw = angleYaw - 360
	elseif angleYaw < 0 then
		angleYaw = 360 + angleYaw
	end
	SendMessage("PlayerDamage," .. angleYaw)
	PlayAngle("PlayerDamage",angleYaw,0)
	SendMessage(self:get():GetFullName())	
	SendMessage(Attacker:get():GetFullName())	
	SendMessage(SkillDamageConfig:get():GetFullName())	
	SendMessage(EffectInstReq:get():GetFullName())	
	SendMessage(Attacker_AttrMemData:get():GetFullName())	
	SendMessage(tostring(Attacker:get():GetPropertyValue("Controller"):GetPropertyValue("ControlRotation").Yaw))	
	SendMessage(tostring(playerYaw))	
	SendMessage(tostring(SkillDamageConfig:get():GetPropertyValue("DmgReason")))	
end

function AshenSlumberHeavyAttack()
	if isAshenSlumberHeavyAttack then
		AshenSlumber = AshenSlumber + 1
		if AshenSlumber > 2 then
			SendMessage("--------------------------------")
			SendMessage("AshenSlumberHeavyAttack")
			truegear.play_effect_by_uuid("AshenSlumberHeavyAttack")
		end
		return
	end
	AshenSlumber = 0
end

function VioletHailHeavyAttack()
	if isVioletHailHeavyAttack then
		VioletHail = VioletHail + 1
		if VioletHail > 3 then
			SendMessage("--------------------------------")
			SendMessage("VioletHailHeavyAttack")
			truegear.play_effect_by_uuid("VioletHailHeavyAttack")
		end
		return
	end
	VioletHail = 0
end

truegear.seek_by_uuid("PlayerDamage")
truegear.init("2358720", "Black Myth WuKong")


function CheckPlayerSpawned()
	RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
		if resetHook then
			local ran, errorMsg = pcall(RegisterHooks)
			if ran then
				SendMessage("--------------------------------")
				SendMessage("HeartBeat")
				truegear.play_effect_by_uuid("HeartBeat")
				resetHook = false
			else
				print(errorMsg)
			end
		end		
	end)
end

SendMessage("TrueGear Mod is Loaded");
CheckPlayerSpawned()

LoopAsync(200, AshenSlumberHeavyAttack)
LoopAsync(100, VioletHailHeavyAttack)