-- App locals
local appName, app = ...;

-- Global locals
local ipairs, tinsert =
	  ipairs, tinsert;

-- Implementation
app:CreateWindow("Pet Battles", {
	AllowCompleteSound = true,
	IsDynamicCategory = true,
	Commands = {
		"attpetbattles",
	},
	OnInit = function(self, handlers)
		self.data = app.CreateNPC(app.HeaderConstants.PET_BATTLES, {
			description = "This list shows you all of the pet battle content as well as where to acquire battle pets in the ATT database.",
			visible = true,
			expanded = true,
			back = 1,
			g = app.Categories.PetBattles or {},
			OnUpdate = function(data)
				local results = app:BuildSearchResponseForField(app:GetDataCache().g, "pb");
				if results and #results > 0 then
					for i,result in ipairs(results) do
						tinsert(data.g, result);
					end
					self:AssignChildren();
					self:ExpandData(true);
				end
				data.OnUpdate = nil;
			end
		});
		self:AssignChildren();
		app.CacheFields(self.data);
	end,
	OnLoad = function(self, settings)
		if settings.Progress then
			self.data.progress = settings.Progress;
			self.data.total = settings.Total;
		end
	end,
	OnSave = function(self, settings)
		settings.Progress = self.data.progress;
		settings.Total = self.data.total;
	end,
});