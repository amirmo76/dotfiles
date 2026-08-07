local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Repeats the value of an insert node
local function rep(idx)
  return f(function(args) return args[1] end, { idx })
end

return {

  -- Quick block comment: /**
  s("/**", {
    t({ "/**", " * " }), i(1, "Description"),
    t({ "", " */" }),
  }),

  -- Full function/method JSDoc
  s("jsdoc", {
    t({ "/**", " * " }), i(1, "Description"), t({ "", " *" }),
    t({ "", " * @param " }), i(2, "{Type}"), t(" "), i(3, "name"), t(" - "), i(4, "param description"),
    t({ "", " * @returns " }), i(5, "{Type}"), t(" "), i(6, "return description"),
    t({ "", " */" }),
  }),

  -- Standalone @param line
  s("@param", {
    t("* @param "), i(1, "{Type}"), t(" "), i(2, "name"), t(" - "), i(3, "description"),
  }),

  -- Standalone @returns line
  s("@returns", {
    t("* @returns "), i(1, "{Type}"), t(" "), i(2, "description"),
  }),

  -- Standalone @throws line
  s("@throws", {
    t("* @throws "), i(1, "{Error}"), t(" "), i(2, "description"),
  }),

  -- Inline @type annotation
  s("@type", {
    t("/** @type {"), i(1, "Type"), t("} */"),
  }),

  -- @typedef for object shapes
  s("@typedef", {
    t({ "/**", " * @typedef {Object} " }), i(1, "TypeName"), t({ "", " *" }),
    t({ "", " * @property {" }), i(2, "Type"), t("} "), i(3, "prop"), t(" - "), i(4, "description"),
    t({ "", " */" }),
  }),

  -- @example block
  s("@example", {
    t({ "* @example", " * " }), i(1, "example code"),
  }),

  -- React component JSDoc
  s("jsdoccomp", {
    t({ "/**", " * " }), i(1, "Component description"), t({ "", " *" }),
    t({ "", " * @param {" }), i(2, "Props"), t("} props"),
    t({ "", " * @returns {JSX.Element}" }),
    t({ "", " */" }),
  }),

}
