--[[ @cond ___LICENSE___
-- Copyright (c) 2017 Zefiros Software.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- @endcond
--]]

function Test:testConfigExists()
    u.assertNotEquals(Config, nil)
    u.assertIsTable(Config)
end

function Test:testConfig_Call()
    local conf = Config(nil)
    
    conf.values = { foo = "Bar" }

    u.assertEquals(conf("foo"), "Bar")
    u.assertNotEquals(conf("foo"), "bar")
end

function Test:testConfig_Call2()
    local conf = Config(nil)
    
    conf.values = { foo = { bar = "foo" } }

    u.assertEquals(conf("foo.bar"), "foo")
    u.assertNotEquals(conf("foo.bar"), "Far")
end

function Test:testConfig_CallSet()
    local conf = Config(nil)
    
    conf.values = { foo = { bar = "foo" } }
    conf("foo", "foo")
    u.assertEquals(conf("foo"), "foo")
    u.assertNotEquals(conf("foo"), "bar")
end

function Test:testConfig_CallSet2()
    local conf = Config(nil)
    
    conf("foo", "foo")
    u.assertEquals(conf("foo"), "foo")
    u.assertNotEquals(conf("foo"), "bar")
end

function Test:testConfig_CallSet3()
    local conf = Config(nil)
    
    conf.values = { foo = { bar = "foo" } }
    conf("foo.bar", "bar")
    u.assertEquals(conf("foo.bar"), "bar")
    u.assertNotEquals(conf("foo.bar"), "foo")
end

function Test:testConfig_CallSet4()
    local conf = Config(nil)
    
    conf.values = { foo = { bar = "foo" } }
    conf("foo.bar", "bar")
    conf("foo.bar2", "bar2")
    u.assertEquals(conf("foo.bar"), "bar")
    u.assertEquals(conf("foo.bar2"), "bar2")
    u.assertNotEquals(conf("foo.bar"), "foo")
end

function Test:testConfig_CallSet5()
    local conf = Config(nil)
    
    u.assertIsNil(conf("github.token", "bar"))
    u.assertEquals(conf("github.token"), nil)

    u.assertNotNil(conf("github", { token = "bar" }))
    u.assertEquals(conf("github.token"), "bar")
end

function Test:testConfig_SetNotExists()
    local conf = Config(nil)
    conf:set("foo.bar", 2)
    u.assertEquals(conf("foo"), { bar = 2 })
    u.assertEquals(conf("foo.bar"), 2)
end

function Test:testConfig_SetNotExistsParents()
    local conf = Config(nil)
    
    u.assertIsNil(_OPTIONS["parents"])
    _OPTIONS["parents"] = true

    u.assertStrContains(conf:set("foo.bar", 2), "'foo.bar' is set to")
    u.assertEquals(conf("foo.bar"), 2)
    u.assertEquals(conf("foo"), { bar = 2 })

    _OPTIONS["parents"] = nil
    u.assertIsNil(_OPTIONS["parents"])
end

function Test:testConfig_SetNotExistsParents2()
    local conf = Config(nil)
    
    u.assertIsNil(_OPTIONS["parents"])
    _OPTIONS["parents"] = true

    u.assertStrContains(conf:set("foo.bar", { foo = 2 }), "'foo.bar' is set to")
    u.assertEquals(conf("foo.bar"), { foo = 2 })
    u.assertEquals(conf("foo"), { bar = { foo = 2 } })

    _OPTIONS["parents"] = nil
    u.assertIsNil(_OPTIONS["parents"])
end

function Test:testConfig_SetNotExistsParents2JSON()
    local conf = Config(nil)
    
    u.assertIsNil(_OPTIONS["parents"])
    _OPTIONS["parents"] = true

    u.assertStrContains(conf:set("foo.bar", "{\"foo\": 2}"), "'foo.bar' is set to")
    u.assertEquals(conf("foo.bar"), { foo = 2 })
    u.assertEquals(conf("foo"), { bar = { foo = 2 } })

    _OPTIONS["parents"] = nil
    u.assertIsNil(_OPTIONS["parents"])
end

function Test:testConfig_Set()
    local conf = Config(nil)
    
    u.assertStrContains(conf:set("foo", 2), "'foo' is set to")
    u.assertEquals(conf("foo"), 2)
end

function Test:testConfig_Set2()
    local conf = Config(nil)
    
    u.assertStrContains(conf:set("foo", { bar = 2 }), "'foo' is set to")
    u.assertEquals(conf("foo"), { bar = 2 })
    u.assertEquals(conf("foo.bar"), 2)
end

function Test:testConfig_Set3()
    local conf = Config(nil)
    
    conf:set({"foo", "bar", "foo2"}, { bar2 = 2 })
    u.assertEquals(conf("foo"), { bar = { foo2 = { bar2 = 2 } } })
    u.assertEquals(conf("foo.bar.foo2.bar2"), 2)
end

function Test:testConfig_Set4()
    local conf = Config(nil)
    
    conf:set({"foo", "bar", "foo2"}, { bar2 = 2 }, true)
    conf:set({"foo", "bar", "foo3"}, { bar3 = 3 }, true)

    u.assertEquals(conf("foo"), { bar = { foo2 = { bar2 = 2 }, foo3= {bar3= 3} } })
    u.assertEquals(conf("foo.bar.foo2.bar2"), 2)
    u.assertEquals(conf("foo.bar.foo3.bar3"), 3)
end

function Test:testConfig_Set2JSON()
    local conf = Config(nil)
    
    u.assertStrContains(conf:set("foo", "{ \"bar\": 2 }"), "'foo' is set to")
    u.assertEquals(conf("foo"), { bar = 2 })
    u.assertEquals(conf("foo.bar"), 2)
end

function Test:testConfig_AddNotExists()
    local conf = Config(nil)
    conf:add("foo.bar", 2)
    u.assertEquals(conf("foo"), { bar = {2} })
    u.assertEquals(conf("foo.bar"), {2})
end

function Test:testConfig_AddNotExistsParents()
    local conf = Config(nil)
    
    u.assertIsNil(_OPTIONS["parents"])
    _OPTIONS["parents"] = true

    u.assertStrContains(conf:add("foo.bar", 2), "'foo.bar' is set to")
    u.assertEquals(conf("foo.bar"), { 2 })
    u.assertEquals(conf("foo"), { bar = { 2 } })

    _OPTIONS["parents"] = nil
    u.assertIsNil(_OPTIONS["parents"])
end

function Test:testConfig_AddNotExistsParents2()
    local conf = Config(nil)
    
    u.assertIsNil(_OPTIONS["parents"])
    _OPTIONS["parents"] = true

    u.assertStrContains(conf:add("foo.bar", { foo = 2 }), "'foo.bar' is set to")
    u.assertEquals(conf("foo.bar"), { { foo = 2 } })

    _OPTIONS["parents"] = nil
    u.assertIsNil(_OPTIONS["parents"])
end


function Test:testConfig_AddNotExistsParents2JSON()
    local conf = Config(nil)
    
    u.assertIsNil(_OPTIONS["parents"])
    _OPTIONS["parents"] = true

    u.assertStrContains(conf:add("foo.bar", "{\"foo\": 2}"), "'foo.bar' is set to")
    u.assertEquals(conf("foo.bar"), { { foo = 2 } })

    _OPTIONS["parents"] = nil
    u.assertIsNil(_OPTIONS["parents"])
end

function Test:testConfig_Add()
    local conf = Config(nil)
    
    u.assertStrContains(conf:add("foo", 2), "'foo' is set to")
    u.assertEquals(conf("foo"), { 2 })
end

function Test:testConfig_Add2()
    local conf = Config(nil)
    
    u.assertStrContains(conf:add("foo", { bar = 2 }), "'foo' is set to")
    u.assertEquals(conf("foo"), { { bar = 2 } })
end

function Test:testConfig_Add2JSON()
    local conf = Config(nil)
    
    u.assertStrContains(conf:add("foo", "{ \"bar\": 2 }"), "'foo' is set to")
    u.assertEquals(conf("foo"), { { bar = 2 } })
end

function Test:testConfig_Add3()
    local conf = Config(nil)
    
    u.assertStrContains(conf:add("foo", 2), "'foo' is set to")
    u.assertStrContains(conf:add("foo", 3), "'foo' is set to")
    u.assertEquals(conf("foo"), { 2, 3 })
end

function Test:testConfig_Add4()
    local conf = Config(nil)
    
    u.assertStrContains(conf:add("foo", 2), "'foo' is set to")
    u.assertStrContains(conf:add("foo", 3), "'foo' is set to")
    u.assertStrContains(conf:add("bar", 3), "'bar' is set to")
    u.assertEquals(conf("foo"), { 2, 3 })
    u.assertEquals(conf("bar"), { 3 })
end

function Test:testConfig_Add5()
    local conf = Config(nil)
    
    u.assertStrContains(conf:add("foo", 2), "'foo' is set to")
    u.assertStrContains(conf:add("foo", { bar = 3 }), "'foo' is set to")
    u.assertStrContains(conf:add("bar", 3), "'bar' is set to")
    u.assertEquals(conf("foo"), { 2, { bar = 3 } })
    u.assertEquals(conf("bar"), { 3 })
end

function Test:testConfig_Add6()
    local conf = Config(nil)
    
    u.assertStrContains(conf:set("foo", 2), "'foo' is set to")
    u.assertStrContains(conf:add("foo", 3), "'foo' is set to")
    u.assertEquals(conf("foo"), { 2, 3 })
end

function Test:testConfig_NonExists()
    local conf = Config(nil)
    u.assertEquals(conf("bar"), nil)
end

function Test:testConfig_Get()
    local conf = Config(nil)
    u.assertStrContains(conf:set("foo", 2), "'foo' is set to")
    u.assertStrContains(conf:print("foo"), "'foo' is set to")
    u.assertEquals(conf:get("foo"), 2)
end

function Test:testConfig_Load()
     
    local conf = Config()
    conf:load()
    u.assertStrContains(conf("github.host"), "https://github.com/")
end

function Test:testConfig_Store()
    local conf = Config(nil)
    conf.mayStore = true
    conf.storeFile = "test.json"

    u.assertFalse(os.isfile(conf.storeFile))

    conf:set("foo", 2)
    conf:set("bar", { })
    conf:set("bar.foo", { foo = 5 })

    u.assertEquals(json.decode(zpm.util.readAll(conf.storeFile)), { bar = { foo = { foo = 5 } }, foo = 2 })

    os.remove(conf.storeFile)
end

function Test:testConfig_StoreAdd()
    local conf = Config(nil)
    conf.mayStore = true
    conf.storeFile = "test.json"

    u.assertFalse(os.isfile(conf.storeFile))

    conf:add("foo", 2)
    conf:add("foo", 4)

    u.assertEquals(json.decode(zpm.util.readAll(conf.storeFile)), { foo = { 2, 4 } })

    os.remove(conf.storeFile)
end

function Test:testConfig_StoreOverrideExisting()
    local conf = Config(nil)
    conf.mayStore = true
    conf.storeFile = "test.json"

    u.assertFalse(os.isfile(conf.storeFile))

    conf:load()
    u.assertStrContains(conf:set("github", { host = "localhost" }), "'github' is set to")
    u.assertEquals(json.decode(zpm.util.readAll(conf.storeFile)), { github = { host = "localhost" } })

    os.remove(conf.storeFile)
end

function Test:testConfig_StoreOverrideTwiceExisting()
    local conf = Config(nil)
    conf.mayStore = true
    conf.storeFile = "test.json"

    zpm.util.writeAll(conf.storeFile, [[{"github": {"token": false, "host": "1234"}}]])

    u.assertTrue(os.isfile(conf.storeFile))

    conf:load()
    u.assertStrContains(conf:set("github", { host = "localhost" }), "'github' is set to")
    u.assertEquals(json.decode(zpm.util.readAll(conf.storeFile)), { github = { token = false, host = "localhost" } })

    os.remove(conf.storeFile)
end

function Test:testConfig_StoreMultiple()
    local conf = Config(nil)
    conf.mayStore = true
    conf.storeFile = "test.json"

    u.assertFalse(os.isfile(conf.storeFile))

    conf:load()
    u.assertStrContains(conf:set("github.host", "localhost"), "'github.host' is set to")
    u.assertEquals(json.decode(zpm.util.readAll(conf.storeFile)), { github = { host = "localhost" } })

    os.remove(conf.storeFile)
end

function Test:testConfig_loadFile1()
    local conf = Config(nil)
    conf:_loadFile("test/files/conf.yml")
    u.assertEquals(conf:get("registries"), {"https://localhost/"})
end

function Test:testConfig_loadFile2()
    local conf = Config(nil)
    conf:_loadFile("test/files/conf.yml")
    conf:_loadFile("test/files/conf2.yml")
    u.assertEquals(conf:get("registries"), {"https://localhost/", "https://127.0.0.1/"})
end

function Test:testConfig_loadFile3()
    local conf = Config(nil)
    conf:_loadFile("test/files/conf.yml")
    conf:_loadFile("test/files/conf3.yml")
    u.assertEquals(conf:get("registries"), {"https://localhost/", test= "hello"})
end

function Test:testConfig_loadFile4()
    local conf = Config(nil)
    
    conf:_loadFile("test/files/conf4.yml")
    conf:_loadFile("test/files/conf5.yml")
    u.assertEquals(conf:get("cache"), {
        premake= {
            cacheTime= 86400,
            checkTime= 1490467948,
            version= "5.0.0-alpha11"
        }
    })
end