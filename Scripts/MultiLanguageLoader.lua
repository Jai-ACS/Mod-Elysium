MultiLanguage = MultiLanguage or {}

function MultiLanguage:Load(mod)
	xlua.private_accessible(CS.TFMgr)
	local language = CS.TFMgr.Instance.Language

	if language == "cn" then
		return -- Default untranslated text should already be in chinese
	end

	local folderPath = CS.ModsMgr.Instance:GetFilePath("Language/Mods/" .. mod .. "/" .. language .. ".txt", mod)
	CS.TFMgr.Instance:LoadLangKvFile(folderPath)
end
