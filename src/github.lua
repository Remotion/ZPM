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

Installer = newclass "Github"

function Github:init(loader)
    self.loader = loader
end

function Github:get(url)
    local token = self:_getToken()
    if token then
        token = "Authorization: token " .. token
    end

    return zpm.wget.get(url, token)
end

function Github:getUrl(prefix, organisation, repository, resource)
    local url = self.loader.config("github.apiHost") .. prefix .. "/" .. organisation .. "/" .. repository

    if resource then
        url = url .. "/" .. resource
    end

    return self:get(url)
end

function Github:getAssets(organisation, repository)

    local response = zpm.json:decode(zpm.GitHub.getUrl("repos", organisation, repository, "releases"))

    local releases = { }
    table.foreachi(response, function(value)

        local ok, vers = pcall(_getAssetsVersion, value["tag_name"])
        if ok then

            local assetTab = { }
            table.foreachi(value["assets"], function(asset)
                table.insert(assetTab, {
                    name = asset["name"],
                    url = asset["browser_download_url"]
                } )
            end )

            table.insert(releases, {
                version = vers,
                assets = assetTab
            } )
        end
    end )

    table.sort(releases, function(t1, t2) return t1.version > t2.version end)
    return releases
end

function Github:matchAssets(organisation, repository, pattern)

    local releases = self:getAssets(organisation, repository)

    local values = { }

    for _, assets in pairs(releases) do

        for _, asset in pairs(assets.assets) do
            local assetMatch = asset.name:match(pattern)

            if assetMatch then
                table.insert(values, {
                    name = asset.name,
                    version = assets.version,
                    url = asset.url
                } )
            end

        end

    end

    return values
end

function Github:_getToken()
    local gh = os.getenv("GH_TOKEN")
    if gh then
        return gh
    end

    gh = _OPTIONS["github-token"]
    if gh then
        return gh
    end

    return self.loader.config("github.token")
end

local function _getAssetsVersion(str)

    local verStr = string.match(str, ".*(%d+%.%d+%.%d+.*)")
    return zpm.semver(verStr)
end