-- 100% прозрачный фон: сносим bg у всех фоновых highlight-групп,
-- чтобы просвечивал терминал. Селекшены (Visual, Search, PmenuSel) не трогаем,
-- иначе будет не видно выделение.
local BG_GROUPS = {
  -- База
  "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
  "EndOfBuffer", "NonText", "MsgArea", "MsgSeparator",
  -- Колонки и разделители
  "SignColumn", "FoldColumn", "LineNr", "LineNrAbove", "LineNrBelow",
  "CursorLineNr", "WinSeparator", "VertSplit", "WinBar", "WinBarNC",
  -- Статуслайн / таблайн
  "StatusLine", "StatusLineNC", "TabLine", "TabLineFill", "TabLineSel",
  -- "Полоски" поверх кода
  "CursorColumn", "ColorColumn", "Folded",
  -- Поп-ап меню (фон; выделение PmenuSel оставляем)
  "Pmenu", "PmenuSbar", "PmenuThumb",
  -- Telescope
  "TelescopeNormal", "TelescopeBorder",
  "TelescopePromptNormal", "TelescopePromptBorder", "TelescopePromptTitle",
  "TelescopeResultsNormal", "TelescopeResultsBorder", "TelescopeResultsTitle",
  "TelescopePreviewNormal", "TelescopePreviewBorder", "TelescopePreviewTitle",
  -- NvimTree
  "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer", "NvimTreeWinSeparator",
  -- Прочее
  "WhichKeyFloat", "WhichKeyBorder",
}

local function luminance(hex)
  if type(hex) ~= "string" then return 255 end
  local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
  if not r then return 255 end
  r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
  return 0.299 * r + 0.587 * g + 0.114 * b
end

-- Всё, что темнее этого порога, на тёмном терминале не читается.
-- Порог 55: ловит чёрный/#15161e/#1a1b26/#24283b, но не трогает
-- приглушённый серый комментариев (#565f89 ~ 97).
local DARK_FG_LIMIT = 55
local WHITE = "#ffffff"

-- Чёрный/тёмный текст -> белый. Связанные (link) группы скипаем:
-- они подтянутся сами, когда починится группа-цель.
local function fix_dark_fg()
  for _, name in ipairs(vim.fn.getcompletion("", "highlight")) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    if ok and hl and not hl.link and hl.fg then
      if luminance(string.format("#%06x", hl.fg)) < DARK_FG_LIMIT then
        hl.fg = WHITE
        hl.ctermfg = "white"
        vim.api.nvim_set_hl(0, name, hl)
      end
    end
  end
end

local function apply()
  for _, g in ipairs(BG_GROUPS) do
    vim.api.nvim_set_hl(0, g, { bg = "NONE", ctermbg = "NONE" })
  end
  -- Текущая строка: без фоновой "полосы", только подчёркивание
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE", ctermbg = "NONE", underline = true })
  fix_dark_fg()
end

-- При каждой смене colorscheme (плагины любят вернуть свой фон)
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("FullyTransparent", { clear = true }),
  callback = apply,
})

apply()
