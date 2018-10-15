TOOL.Category = 'Construction'
TOOL.Name = '#tool.ldspamremover.name'
TOOL.Command = nil
TOOL.ConfigName = ''

if ( CLIENT ) then
    language.Add( 'tool.ldspamremover.name', 'LD Spam Remover' )
    language.Add( 'tool.ldspamremover.desc', 'Removes excessive amounts of a single entity by one player' )
    language.Add( 'tool.ldspamremover.0', 'Primary: Remove entities of the type you\'re aiming at' )
end

function TOOL:LeftClick(trace)
	local entity = trace.Entity

	if !IsValid(entity) or entity:IsPlayer() then return false end

	local toolOwner = self:GetOwner()
	local owner = entity:GetNWString('Owner')

	if !toolOwner:IsAdmin() and owner != toolOwner:Name() then return false end

	if !CLIENT then
		for k, v in pairs(ents.FindByModel(entity:GetModel())) do
			if v:GetNWString('Owner') == owner then
				v:Remove()
			end
		end
	end

	return true
end
