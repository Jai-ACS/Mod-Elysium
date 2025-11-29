MultiLanguage = MultiLanguage or {}

function MultiLanguage:Load(mod)
	xlua.private_accessible(CS.TFMgr)
	self.language = CS.TFMgr.Instance.Language

	local folderPath = CS.ModsMgr.Instance:GetFilePath("Language/Mods/" .. mod .. "/" .. self.language .. ".txt", mod)
	CS.TFMgr.Instance:LoadLangKvFile(folderPath)
end
