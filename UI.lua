local UI = {}
local player = game.Players.LocalPlayer

function UI.Create(ThemeConfig, Cheats)
	local THEME = ThemeConfig.THEME
	local UIS = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local mouse = player:GetMouse()

	local isBinding = false
	local canCapture = false

	-- UI Racine
	local gui = Instance.new("ScreenGui")
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	-------------------------------------------------
	-- 🚀 STRUCTURE DU LOADER PREMIUM V2
	-------------------------------------------------
	local loaderFrame = Instance.new("Frame")
	loaderFrame.Parent = gui
	loaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	loaderFrame.Size = UDim2.new(0, 300, 0, 230)
	loaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	loaderFrame.BackgroundColor3 = THEME.Background
	loaderFrame.BorderSizePixel = 0

	local loaderCorner = Instance.new("UICorner")
	loaderCorner.CornerRadius = UDim.new(0, 12)
	loaderCorner.Parent = loaderFrame

	local loaderStroke = Instance.new("UIStroke")
	loaderStroke.Thickness = 1
	loaderStroke.Color = Color3.fromRGB(50, 50, 50)
	loaderStroke.Parent = loaderFrame

	local loaderTitle = Instance.new("TextLabel")
	loaderTitle.Parent = loaderFrame
	loaderTitle.Size = UDim2.new(1, 0, 0, 35)
	loaderTitle.Position = UDim2.new(0, 0, 0, 15)
	loaderTitle.Text = "HellbreakerX"
	loaderTitle.Font = Enum.Font.SourceSansBold
	loaderTitle.TextSize = 24
	loaderTitle.TextColor3 = THEME.TextMain
	loaderTitle.BackgroundTransparency = 1

	local centerArea = Instance.new("Frame")
	centerArea.Parent = loaderFrame
	centerArea.AnchorPoint = Vector2.new(0.5, 0.5)
	centerArea.Position = UDim2.new(0.5, 0, 0.5, -15)
	centerArea.Size = UDim2.new(0, 70, 0, 70)
	centerArea.BackgroundTransparency = 1

	local pulseCircle = Instance.new("Frame")
	pulseCircle.Parent = centerArea
	pulseCircle.AnchorPoint = Vector2.new(0.5, 0.5)
	pulseCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
	pulseCircle.Size = UDim2.new(0, 36, 0, 36)
	pulseCircle.BackgroundColor3 = THEME.AccentBlue
	pulseCircle.BackgroundTransparency = 0.8

	local pulseCorner = Instance.new("UICorner")
	pulseCorner.CornerRadius = UDim.new(1, 0)
	pulseCorner.Parent = pulseCircle

	local spinner = Instance.new("ImageLabel")
	spinner.Parent = centerArea
	spinner.AnchorPoint = Vector2.new(0.5, 0.5)
	spinner.Size = UDim2.new(0, 40, 0, 40)
	spinner.Position = UDim2.new(0.5, 0, 0.5, 0)
	spinner.BackgroundTransparency = 1
	spinner.Image = "rbxassetid://12437648312"
	spinner.ImageColor3 = THEME.AccentBlue

	local loaderStatus = Instance.new("TextLabel")
	loaderStatus.Parent = loaderFrame
	loaderStatus.Size = UDim2.new(1, 0, 0, 20)
	loaderStatus.Position = UDim2.new(0, 0, 1, -85)
	loaderStatus.Text = "Connecting..."
	loaderStatus.Font = Enum.Font.SourceSansSemibold
	loaderStatus.TextSize = 14
	loaderStatus.TextColor3 = THEME.TextDark
	loaderStatus.BackgroundTransparency = 1

	local percentageLabel = Instance.new("TextLabel")
	percentageLabel.Parent = loaderFrame
	percentageLabel.Size = UDim2.new(1, 0, 0, 20)
	percentageLabel.Position = UDim2.new(0, 0, 1, -68)
	percentageLabel.Text = "0%"
	percentageLabel.Font = Enum.Font.Code
	percentageLabel.TextSize = 12
	percentageLabel.TextColor3 = THEME.AccentBlue
	percentageLabel.BackgroundTransparency = 1

	local barTrack = Instance.new("Frame")
	barTrack.Parent = loaderFrame
	barTrack.AnchorPoint = Vector2.new(0.5, 0)
	barTrack.Size = UDim2.new(0, 230, 0, 4)
	barTrack.Position = UDim2.new(0.5, 0, 1, -45)
	barTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	barTrack.BorderSizePixel = 0

	local barTrackCorner = Instance.new("UICorner")
	barTrackCorner.CornerRadius = UDim.new(1, 0)
	barTrackCorner.Parent = barTrack

	local barFill = Instance.new("Frame")
	barFill.Parent = barTrack
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = THEME.AccentBlue
	barFill.BorderSizePixel = 0

	local barFillCorner = Instance.new("UICorner")
	barFillCorner.CornerRadius = UDim.new(1, 0)
	barFillCorner.Parent = barFill

	local loaderCredit = Instance.new("TextLabel")
	loaderCredit.Parent = loaderFrame
	loaderCredit.Size = UDim2.new(1, 0, 0, 20)
	loaderCredit.Position = UDim2.new(0, 0, 1, -22)
	loaderCredit.Text = "Exploit developed by Lenox"
	loaderCredit.Font = Enum.Font.SourceSansBold
	loaderCredit.TextSize = 13
	loaderCredit.TextColor3 = THEME.TextCredit
	loaderCredit.BackgroundTransparency = 1

	-------------------------------------------------
	-- ✨ ÉCRAN D'ACCUEIL JOUEUR (WELCOME SCREEN)
	-------------------------------------------------
	local welcomeFrame = Instance.new("CanvasGroup")
	welcomeFrame.Parent = gui
	welcomeFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	welcomeFrame.Size = UDim2.new(0, 300, 0, 200)
	welcomeFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	welcomeFrame.BackgroundColor3 = THEME.Background
	welcomeFrame.BorderSizePixel = 0
	welcomeFrame.GroupTransparency = 1
	welcomeFrame.Visible = false

	local welcomeCorner = Instance.new("UICorner")
	welcomeCorner.CornerRadius = UDim.new(0, 12)
	welcomeCorner.Parent = welcomeFrame

	local welcomeStroke = Instance.new("UIStroke")
	welcomeStroke.Thickness = 1
	welcomeStroke.Color = Color3.fromRGB(55, 55, 55)
	welcomeStroke.Parent = welcomeFrame

	local avatarFrame = Instance.new("Frame")
	avatarFrame.Parent = welcomeFrame
	avatarFrame.AnchorPoint = Vector2.new(0.5, 0)
	avatarFrame.Position = UDim2.new(0.5, 0, 0, 25)
	avatarFrame.Size = UDim2.new(0, 65, 0, 65)
	avatarFrame.BackgroundColor3 = THEME.Sidebar
	avatarFrame.BorderSizePixel = 0

	local avatarCorner = Instance.new("UICorner")
	avatarCorner.CornerRadius = UDim.new(1, 0)
	avatarCorner.Parent = avatarFrame

	local avatarImage = Instance.new("ImageLabel")
	avatarImage.Parent = avatarFrame
	avatarImage.Size = UDim2.new(1, -4, 1, -4)
	avatarImage.Position = UDim2.new(0, 2, 0, 2)
	avatarImage.BackgroundTransparency = 1
	avatarImage.Image = "rbxassetid://0"

	local avatarImageCorner = Instance.new("UICorner")
	avatarImageCorner.CornerRadius = UDim.new(1, 0)
	avatarImageCorner.Parent = avatarImage

	local welcomeText = Instance.new("TextLabel")
	welcomeText.Parent = welcomeFrame
	welcomeText.Size = UDim2.new(1, 0, 0, 25)
	welcomeText.Position = UDim2.new(0, 0, 0, 105)
	welcomeText.Text = "Welcome back,"
	welcomeText.Font = Enum.Font.SourceSans
	welcomeText.TextSize = 16
	welcomeText.TextColor3 = THEME.TextDark
	welcomeText.BackgroundTransparency = 1

	local userText = Instance.new("TextLabel")
	userText.Parent = welcomeFrame
	userText.Size = UDim2.new(1, 0, 0, 30)
	userText.Position = UDim2.new(0, 0, 0, 125)
	userText.Text = player.DisplayName or player.Name
	userText.Font = Enum.Font.SourceSansBold
	userText.TextSize = 22
	userText.TextColor3 = THEME.AccentBlue
	userText.BackgroundTransparency = 1

	task.spawn(function()
		pcall(function()
			local content, isReady = game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			if isReady then
				avatarImage.Image = content
			end
		end)
	end)

	-------------------------------------------------
	-- UI PRINCIPALE (INITIALISÉE MASQUÉE)
	-------------------------------------------------
	local mainFrame = Instance.new("CanvasGroup") 
	mainFrame.Parent = gui
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.Size = UDim2.new(0, 550, 0, 380)
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.BackgroundColor3 = THEME.Background
	mainFrame.BorderSizePixel = 0
	mainFrame.GroupTransparency = 1 
	mainFrame.Visible = false

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 8)
	mainCorner.Parent = mainFrame

	local sidebar = Instance.new("Frame")
	sidebar.Parent = mainFrame
	sidebar.Size = UDim2.new(0, 150, 1, 0)
	sidebar.BackgroundColor3 = THEME.Sidebar
	sidebar.BorderSizePixel = 0

	local sideCorner = Instance.new("UICorner")
	sideCorner.CornerRadius = UDim.new(0, 8)
	sideCorner.Parent = sidebar

	local line = Instance.new("Frame")
	line.Parent = mainFrame
	line.Size = UDim2.new(0, 1, 1, 0)
	line.Position = UDim2.new(0, 150, 0, 0)
	line.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	line.BorderSizePixel = 0

	-------------------------------------------------
	-- SYSTEME DE DRAG (GLISSER / DEPLACER)
	-------------------------------------------------
	local dragging, dragInput, dragStart, startPos

	local function updateDrag(input)
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	mainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	mainFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then updateDrag(input) end
	end)

	-------------------------------------------------
	-- BOUTON FERMER
	-------------------------------------------------
	local closeBtn = Instance.new("TextButton")
	closeBtn.Parent = mainFrame
	closeBtn.Size = UDim2.new(0, 28, 0, 28)
	closeBtn.Position = UDim2.new(1, -1, 0, 1)
	closeBtn.AnchorPoint = Vector2.new(1, 0) 
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
	closeBtn.BackgroundTransparency = 1 
	closeBtn.Text = "" 
	closeBtn.AutoButtonColor = false

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 7)
	closeCorner.Parent = closeBtn

	local line1 = Instance.new("Frame")
	line1.Parent = closeBtn
	line1.Size = UDim2.new(0, 11, 0, 2)
	line1.Position = UDim2.new(0.5, 0, 0.5, 0)
	line1.AnchorPoint = Vector2.new(0.5, 0.5)
	line1.BackgroundColor3 = THEME.TextDark
	line1.Rotation = 45
	line1.BorderSizePixel = 0

	local line2 = Instance.new("Frame")
	line2.Parent = closeBtn
	line2.Size = UDim2.new(0, 11, 0, 2)
	line2.Position = UDim2.new(0.5, 0, 0.5, 0)
	line2.AnchorPoint = Vector2.new(0.5, 0.5)
	line2.BackgroundColor3 = THEME.TextDark
	line2.Rotation = -45
	line2.BorderSizePixel = 0

	local tweenInfoClose = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	closeBtn.MouseEnter:Connect(function()
		TweenService:Create(closeBtn, tweenInfoClose, {BackgroundTransparency = 0.15}):Play()
		TweenService:Create(line1, tweenInfoClose, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		TweenService:Create(line2, tweenInfoClose, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)

	closeBtn.MouseLeave:Connect(function()
		TweenService:Create(closeBtn, tweenInfoClose, {BackgroundTransparency = 1}):Play()
		TweenService:Create(line1, tweenInfoClose, {BackgroundColor3 = THEME.TextDark}):Play()
		TweenService:Create(line2, tweenInfoClose, {BackgroundColor3 = THEME.TextDark}):Play()
	end)

	-------------------------------------------------
	-- BOUTON DE RÉOUVERTURE
	-------------------------------------------------
	local openBtn = Instance.new("TextButton")
	openBtn.Parent = gui
	openBtn.Size = UDim2.new(0, 45, 0, 45)
	openBtn.Position = UDim2.new(0, 20, 1, -65)
	openBtn.BackgroundColor3 = THEME.Sidebar
	openBtn.Text = "⚙️"
	openBtn.TextSize = 20
	openBtn.Visible = false

	local openCorner = Instance.new("UICorner")
	openCorner.CornerRadius = UDim.new(0, 8)
	openCorner.Parent = openBtn

	local openStroke = Instance.new("UIStroke")
	openStroke.Thickness = 1
	openStroke.Color = Color3.fromRGB(60, 60, 60)
	openStroke.Parent = openBtn

	closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false openBtn.Visible = true end)
	openBtn.MouseButton1Click:Connect(function() mainFrame.Visible = true openBtn.Visible = false end)

	-------------------------------------------------
	-- ZONE DE CONTENU (SCROLLING OPTIMISÉ)
	-------------------------------------------------
	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Parent = mainFrame
	contentFrame.Position = UDim2.new(0, 165, 0, 20)
	contentFrame.Size = UDim2.new(0, 370, 1, -40)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.ScrollBarThickness = 4
	contentFrame.ScrollBarImageColor3 = THEME.AccentBlue
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 400)

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Parent = contentFrame
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 10)

	local contentTitle = Instance.new("TextLabel")
	contentTitle.Parent = contentFrame
	contentTitle.Size = UDim2.new(1, 0, 0, 25)
	contentTitle.Text = "Player" 
	contentTitle.Font = Enum.Font.SourceSansBold
	contentTitle.TextSize = 22
	contentTitle.TextColor3 = THEME.TextMain
	contentTitle.TextXAlignment = Enum.TextXAlignment.Left
	contentTitle.BackgroundTransparency = 1
	contentTitle.LayoutOrder = 0

	-------------------------------------------------
	-- TITRE & NAVIGATION (SIDEBAR SUR MESURE)
	-------------------------------------------------
	local title = Instance.new("TextLabel")
	title.Parent = sidebar
	title.Size = UDim2.new(1, 0, 0, 40)
	title.Position = UDim2.new(0, 15, 0, 15)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Text = "HellbreakerX"
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 20
	title.TextColor3 = THEME.TextMain
	title.BackgroundTransparency = 1

	local navList = Instance.new("Frame")
	navList.Parent = sidebar
	navList.Position = UDim2.new(0, 10, 0, 65)
	navList.Size = UDim2.new(1, -20, 1, -75)
	navList.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout")
	layout.Parent = navList
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 5)

	local tabs = {}
	local activeTab = "Player" 

	local function updateTabsVisuals()
		for name, btn in pairs(tabs) do
			if name == activeTab then
				TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.9, BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextColor3 = THEME.TextMain}):Play()
			else
				TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = THEME.TextDark}):Play()
			end
		end
	end

	local function createTabButton(name, layoutOrder)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 32)
		btn.BackgroundTransparency = 1
		btn.Text = "  " .. name
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 15
		btn.TextColor3 = THEME.TextDark
		btn.LayoutOrder = layoutOrder
		btn.Parent = navList
		btn.AutoButtonColor = false
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btn
		tabs[name] = btn

		btn.MouseButton1Click:Connect(function()
			activeTab = name
			contentTitle.Text = name
			updateTabsVisuals()

			local isPlayer = (name == "Player")
			if contentFrame:FindFirstChild("FlyCard") then contentFrame.FlyCard.Visible = isPlayer end
			if contentFrame:FindFirstChild("AutoCard") then contentFrame.AutoCard.Visible = isPlayer end
			if contentFrame:FindFirstChild("GodCard") then contentFrame.GodCard.Visible = isPlayer end
		end)

		btn.MouseEnter:Connect(function() if activeTab ~= name then TweenService:Create(btn, TweenInfo.new(0.1), {TextColor3 = THEME.TextMain, BackgroundTransparency = 0.95, BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play() end end)
		btn.MouseLeave:Connect(function() if activeTab ~= name then TweenService:Create(btn, TweenInfo.new(0.1), {TextColor3 = THEME.TextDark, BackgroundTransparency = 1}):Play() end end)
		return btn
	end

	createTabButton("Player", 1)
	createTabButton("Visuals", 2)
	createTabButton("Settings", 3)
	updateTabsVisuals()

	-------------------------------------------------
	-- PRO CARD: FLY SETTINGS
	-------------------------------------------------
	local flyCard = Instance.new("Frame")
	flyCard.Name = "FlyCard"
	flyCard.Parent = contentFrame
	flyCard.Size = UDim2.new(1, -10, 0, 100) 
	flyCard.BackgroundColor3 = THEME.Card
	flyCard.BorderSizePixel = 0
	flyCard.Visible = true 
	flyCard.LayoutOrder = 1

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 6)
	cardCorner.Parent = flyCard

	local flyLabel = Instance.new("TextLabel")
	flyLabel.Parent = flyCard
	flyLabel.Size = UDim2.new(0, 70, 0, 30)
	flyLabel.Position = UDim2.new(0, 15, 0, 15)
	flyLabel.BackgroundTransparency = 1
	flyLabel.Text = "Fly Hack"
	flyLabel.TextColor3 = THEME.TextMain
	flyLabel.Font = Enum.Font.SourceSansSemibold
	flyLabel.TextSize = 16
	flyLabel.TextXAlignment = Enum.TextXAlignment.Left

	local bindBtn = Instance.new("TextButton")
	bindBtn.Parent = flyCard
	bindBtn.Size = UDim2.new(1, -185, 0, 22) 
	bindBtn.Position = UDim2.new(0, 105, 0, 19)
	bindBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	bindBtn.Text = "F"
	bindBtn.TextColor3 = THEME.TextMain
	bindBtn.Font = Enum.Font.SourceSansBold
	bindBtn.TextSize = 12
	bindBtn.AutoButtonColor = false

	local bindBtnCorner = Instance.new("UICorner")
	bindBtnCorner.CornerRadius = UDim.new(0, 4)
	bindBtnCorner.Parent = bindBtn

	local bindStroke = Instance.new("UIStroke")
	bindStroke.Thickness = 1
	bindStroke.Color = Color3.fromRGB(80, 80, 80)
	bindStroke.Parent = bindBtn

	bindBtn.MouseButton1Click:Connect(function()
		if isBinding then return end
		isBinding = true
		canCapture = false
		bindBtn.Text = "..."
		bindBtn.TextColor3 = THEME.TextDark
		bindStroke.Color = THEME.AccentBlue
		task.wait(0.08)
		canCapture = true
	end)

	UIS.InputBegan:Connect(function(input, gp)
		if not isBinding or not canCapture then return end
		if input.KeyCode ~= Enum.KeyCode.Unknown then
			Cheats.flyKeybind = input.KeyCode
			bindBtn.Text = input.KeyCode.Name
			bindBtn.TextColor3 = THEME.TextMain
			isBinding = false
			bindStroke.Color = Color3.fromRGB(80, 80, 80)
		end
	end)

	local switch = Instance.new("TextButton")
	switch.Parent = flyCard
	switch.Size = UDim2.new(0, 45, 0, 22)
	switch.Position = UDim2.new(1, -60, 0, 19)
	switch.BackgroundColor3 = THEME.AccentGray
	switch.Text = ""
	switch.AutoButtonColor = false

	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switch

	local circle = Instance.new("Frame")
	circle.Parent = switch
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = UDim2.new(0, 3, 0.5, 0)
	circle.AnchorPoint = Vector2.new(0, 0.5)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = circle

switch.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    
    -- On appelle la logique
    if Cheats.flying then 
        Cheats.disableFly(char.Humanoid) 
        -- Visuel : Éteint
        switch.BackgroundColor3 = THEME.AccentGray
        circle:TweenPosition(UDim2.new(0, 3, 0.5, 0), "Out", "Quad", 0.2, true)
    else 
        Cheats.enableFly(char.HumanoidRootPart, char.Humanoid) 
        -- Visuel : Allumé
        switch.BackgroundColor3 = THEME.AccentBlue -- Ou ta couleur active
        circle:TweenPosition(UDim2.new(1, -19, 0.5, 0), "Out", "Quad", 0.2, true)
    end
end)

	-------------------------------------------------
	-- SLIDER DE VITESSE
	-------------------------------------------------
	local speedLabel = Instance.new("TextLabel")
	speedLabel.Parent = flyCard
	speedLabel.Size = UDim2.new(0, 100, 0, 20)
	speedLabel.Position = UDim2.new(0, 15, 0, 55)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "Fly Speed: " .. Cheats.speed
	speedLabel.TextColor3 = THEME.TextDark
	speedLabel.Font = Enum.Font.SourceSans
	speedLabel.TextSize = 14
	speedLabel.TextXAlignment = Enum.TextXAlignment.Left

	local sliderTrack = Instance.new("Frame")
	sliderTrack.Parent = flyCard
	sliderTrack.Size = UDim2.new(1, -30, 0, 4) 
	sliderTrack.Position = UDim2.new(0, 15, 0, 80)
	sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	sliderTrack.BorderSizePixel = 0

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = sliderTrack

	local sliderFill = Instance.new("Frame")
	sliderFill.Parent = sliderTrack
	sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
	sliderFill.BackgroundColor3 = THEME.AccentBlue
	sliderFill.BorderSizePixel = 0

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = sliderFill

	local sliderBtn = Instance.new("TextButton")
	sliderBtn.Parent = sliderTrack
	sliderBtn.Size = UDim2.new(0, 12, 0, 12)
	sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	sliderBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
	sliderBtn.BackgroundColor3 = THEME.TextMain
	sliderBtn.Text = ""
	sliderBtn.AutoButtonColor = false 

	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(1, 0)
	sliderCorner.Parent = sliderBtn

	local draggingSlider = false
	local sliderTweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	sliderBtn.MouseButton1Down:Connect(function()
		draggingSlider = true
		TweenService:Create(sliderBtn, sliderTweenInfo, {Size = UDim2.new(0, 16, 0, 16)}):Play()
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingSlider then
			draggingSlider = false
			TweenService:Create(sliderBtn, sliderTweenInfo, {Size = UDim2.new(0, 12, 0, 12)}):Play()
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = mouse.X
			local trackPos = sliderTrack.AbsolutePosition.X
			local trackWidth = sliderTrack.AbsoluteSize.X
			local percentage = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
			sliderBtn.Position = UDim2.new(percentage, 0, 0.5, 0)
			sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
			Cheats.speed = math.round(percentage * 100)
			speedLabel.Text = "Fly Speed: " .. Cheats.speed
		end
	end)

	-------------------------------------------------
	-- PRO CARD: AUTO TOWER (PATHFINDING)
	-------------------------------------------------
	local autoCard = Instance.new("Frame")
	autoCard.Name = "AutoCard"
	autoCard.Parent = contentFrame
	autoCard.Size = UDim2.new(1, -10, 0, 55) 
	autoCard.BackgroundColor3 = THEME.Card
	autoCard.BorderSizePixel = 0
	autoCard.LayoutOrder = 2

	local autoCardCorner = Instance.new("UICorner")
	autoCardCorner.CornerRadius = UDim.new(0, 6)
	autoCardCorner.Parent = autoCard

	local autoLabel = Instance.new("TextLabel")
	autoLabel.Parent = autoCard
	autoLabel.Size = UDim2.new(0, 150, 0, 30)
	autoLabel.Position = UDim2.new(0, 15, 0, 12)
	autoLabel.BackgroundTransparency = 1
	autoLabel.Text = "Auto Tower (unstable)"
	autoLabel.TextColor3 = THEME.TextMain
	autoLabel.Font = Enum.Font.SourceSansSemibold
	autoLabel.TextSize = 16
	autoLabel.TextXAlignment = Enum.TextXAlignment.Left

	local autoBtn = Instance.new("TextButton")
	autoBtn.Parent = autoCard
	autoBtn.Size = UDim2.new(0, 80, 0, 25)
	autoBtn.Position = UDim2.new(1, -95, 0, 15)
	autoBtn.BackgroundColor3 = THEME.AccentBlue
	autoBtn.Text = "START"
	autoBtn.TextColor3 = Color3.new(1, 1, 1)
	autoBtn.Font = Enum.Font.SourceSansBold
	autoBtn.AutoButtonColor = true

	local autoBtnCorner = Instance.new("UICorner")
	autoBtnCorner.CornerRadius = UDim.new(0, 4)
	autoBtnCorner.Parent = autoBtn

	-------------------------------------------------
	-- 🛡️ PRO CARD: GOD MODE
	-------------------------------------------------
	local godCard = Instance.new("Frame")
	godCard.Name = "GodCard"
	godCard.Parent = contentFrame
	godCard.Size = UDim2.new(1, -10, 0, 55) 
	godCard.BackgroundColor3 = THEME.Card
	godCard.BorderSizePixel = 0
	godCard.Visible = true 
	godCard.LayoutOrder = 3

	local godCardCorner = Instance.new("UICorner")
	godCardCorner.CornerRadius = UDim.new(0, 6)
	godCardCorner.Parent = godCard

	local godLabel = Instance.new("TextLabel")
	godLabel.Parent = godCard
	godLabel.Size = UDim2.new(0, 150, 0, 30)
	godLabel.Position = UDim2.new(0, 15, 0, 12)
	godLabel.BackgroundTransparency = 1
	godLabel.Text = "God Mode (Patched)"
	godLabel.TextColor3 = THEME.TextMain
	godLabel.Font = Enum.Font.SourceSansSemibold
	godLabel.TextSize = 16
	godLabel.TextXAlignment = Enum.TextXAlignment.Left

	local godSwitch = Instance.new("TextButton")
	godSwitch.Parent = godCard
	godSwitch.Size = UDim2.new(0, 45, 0, 22)
	godSwitch.Position = UDim2.new(1, -60, 0, 16)
	godSwitch.BackgroundColor3 = THEME.AccentGray
	godSwitch.Text = ""
	godSwitch.AutoButtonColor = false

	local godSwitchCorner = Instance.new("UICorner")
	godSwitchCorner.CornerRadius = UDim.new(1, 0)
	godSwitchCorner.Parent = godSwitch

	local godCircle = Instance.new("Frame")
	godCircle.Parent = godSwitch
	godCircle.Size = UDim2.new(0, 16, 0, 16)
	godCircle.Position = UDim2.new(0, 3, 0.5, 0)
	godCircle.AnchorPoint = Vector2.new(0, 0.5)
	godCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

	local godCircleCorner = Instance.new("UICorner")
	godCircleCorner.CornerRadius = UDim.new(1, 0)
	godCircleCorner.Parent = godCircle

godSwitch.MouseButton1Click:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return end
    
    if Cheats.godModeActive then 
        Cheats.disableGodMode() 
        -- Mise à jour visuelle : Éteint
        godSwitch.BackgroundColor3 = THEME.AccentGray
        godCircle:TweenPosition(UDim2.new(0, 3, 0.5, 0), "Out", "Quad", 0.2, true)
    else 
        Cheats.enableGodMode(hum) 
        -- Mise à jour visuelle : Allumé
        godSwitch.BackgroundColor3 = THEME.AccentBlue -- Assure-toi que THEME.AccentBlue existe
        godCircle:TweenPosition(UDim2.new(1, -19, 0.5, 0), "Out", "Quad", 0.2, true)
    end
end)

	-------------------------------------------------
	-- LIEN ENTEMPS RÉEL AVEC LA LOGIQUE (updateUI)
	-------------------------------------------------
	Cheats.updateUI = function()
		if Cheats.flying then
			TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = THEME.AccentBlue}):Play()
			TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, 0)}):Play()
		else
			TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = THEME.AccentGray}):Play()
			TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
		end

		if Cheats.godModeActive then
			TweenService:Create(godSwitch, TweenInfo.new(0.2), {BackgroundColor3 = THEME.AccentBlue}):Play()
			TweenService:Create(godCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, 0)}):Play()
		else
			TweenService:Create(godSwitch, TweenInfo.new(0.2), {BackgroundColor3 = THEME.AccentGray}):Play()
			TweenService:Create(godCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
		end
	end

	-------------------------------------------------
	-- 🎬 LOGIQUE DU LOADER ET FIL D'ATTENTE DES Tweens
	-------------------------------------------------
	task.spawn(function()
		local rotationConnection
		rotationConnection = RunService.RenderStepped:Connect(function(deltaTime)
			if spinner and spinner.Parent then
				spinner.Rotation = (spinner.Rotation + (140 * deltaTime)) % 360
			else
				rotationConnection:Disconnect()
			end
		end)

		local pulseConnection
		local pulseTime = 0
		pulseConnection = RunService.RenderStepped:Connect(function(deltaTime)
			if pulseCircle and pulseCircle.Parent then
				pulseTime = pulseTime + deltaTime
				local scale = 1 + math.sin(pulseTime * 4) * 0.4
				pulseCircle.Size = UDim2.new(0, 40 * scale, 0, 40 * scale)
				pulseCircle.BackgroundTransparency = 0.5 + (scale - 0.6) * 0.5
			else
				pulseConnection:Disconnect()
			end
		end)

		local steps = {
			{text = "Checking Whitelist...", progress = 0.25, delay = 1.5},
			{text = "Bypassing Anticheat...", progress = 0.55, delay = 1.8},
			{text = "Injecting UI Modules...", progress = 0.85, delay = 1.5},
			{text = "Ready!", progress = 1.0, delay = 1.0}
		}

		for _, step in ipairs(steps) do
			loaderStatus.Text = step.text
			local tween = TweenService:Create(barFill, TweenInfo.new(step.delay, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(step.progress, 0, 1, 0)})
			tween:Play()

			local startPercent = tonumber(string.match(percentageLabel.Text, "%d+")) or 0
			local targetPercent = math.round(step.progress * 100)

			for i = startPercent, targetPercent do
				percentageLabel.Text = tostring(i) .. "%"
				local stepsCount = math.max(targetPercent - startPercent, 1)
				task.wait(step.delay / stepsCount)
			end
		end

		task.wait(0.5)
		TweenService:Create(loaderFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
		loaderTitle.Visible = false
		centerArea.Visible = false
		loaderStatus.Visible = false
		percentageLabel.Visible = false
		barTrack.Visible = false
		loaderCredit.Visible = false
		task.wait(0.5)
		loaderFrame.Visible = false

		welcomeFrame.Visible = true
		TweenService:Create(welcomeFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
		task.wait(2.5)
		TweenService:Create(welcomeFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1}):Play()
		task.wait(0.5)
		welcomeFrame.Visible = false

		mainFrame.Visible = true
		TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
	end)

	-- On retourne les éléments nécessaires au MainScript (init)
	return {
		gui = gui,
		autoBtn = autoBtn,
		flySwitch = switch,
		flyCircle = circle
	}
end

return UI