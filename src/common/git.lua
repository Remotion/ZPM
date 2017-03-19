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

zpm.git = { }

function zpm.git.pull(destination, url)

    local current = os.getcwd()

    os.chdir(destination)

    if url then
        os.executef("git remote set-url origin %s", url)
    end

    os.execute("git fetch origin --tags -q -j 8")

    local updated = false

    if os.outputof("git log HEAD..origin/HEAD --oneline"):len() > 0 then

        os.execute("git checkout -q .")
        os.execute("git reset --hard origin/HEAD")
        os.execute("git submodule update --init --recursive -j 8")

        updated = true
    end

    os.chdir(current)

    return updated
end

function zpm.git.clone(destination, url)

    os.executef( "git clone -v --recurse -j8 --progress \"%s\" \"%s\"", url, destination )
end

function zpm.git.cloneOrPull(destination, url)


    if os.isdir(destination) then

        return zpm.git.pull(destination, url)
    else

        zpm.git.clone(destination, url)
    end
end

function zpm.git.getTags(destination)

    local current = os.getcwd()

    os.chdir(destination)

    local tagStr, errorCode = os.outputof("git show-ref --tags")
    local tags = { }

    for _, s in ipairs(tagStr:explode("\n")) do

        if s:len() > 0 then

            local split = zpm.util.split(s, " ")
            local ref, version = split[1], split[2]
            version = version:match("[._-]*([%d+%.]+.*)")
            if version and pcall(zpm.semver, version) then
                table.insert(tags, {
                    version = version,
                    hash = ref,
                    tag = s:match("refs/tags/(.*)")
                } )
            elseif version then

                version = version:gsub("_", "%."):match("[._-]*([%d+%.]+.*)")

                if pcall(zpm.semver, version) then
                    table.insert(tags, {
                        version = version,
                        hash = ref,
                        tag = s:match("refs/tags/(.*)")
                    } )
                else

                    local version, pattern = version:match("(%d+%.%d+%.%d+)%.?(.*)")
                    if version and pattern then
                        version = ("%s+b%s"):format(version, pattern)
                        if pcall(zpm.semver, version) then
                            table.insert(tags, {
                                version = version,
                                hash = ref,
                                tag = s:match("refs/tags/(.*)")
                            } )
                        end
                    end
                end
            end
        end
    end

    table.sort(tags, function(t1, t2)
        return bootstrap.semver(t1.version) > bootstrap.semver(t2.version)
    end )

    os.chdir(current)

    return tags
end

function zpm.git.export(from, output, tag)

    local temp = path.join(zpm.loader.temp, ("%s.zip"):format(string.sha1(from)))
    local current = os.getcwd()

    os.chdir(from)

    os.executef("git archive --format=zip --output=\"%s\" %s", temp, tag.tag)

    os.chdir(current)
    
    zip.extract(temp, output)    

    os.remove(temp)
end