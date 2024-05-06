-- require "Common"
-- cclog
log = {}
log.d = function( ... )
    -- do return end
    if appDebugMode then
        log.i(...)
    end
end
log.i = function( ... )
    -- do return end
    local tv = "\n"
    local xn = 0
    local function tvlinet(xn)
        
        for i=1,xn do
            tv = tv.."\t"
        end
    end
    local function printTab(i,v)
        --print("print table",i, v)
        
        if type(v) == "table" then
            --if type(i)=="string" and string.sub(i,1,2) ~="__" then
            if i ~="__index" then
                tvlinet(xn)
                xn = xn + 1
                tv = tv..""..i..":Table="..tostring(v).."{\n"
                table.foreach(v,printTab)
                tvlinet(xn)
                tv = tv.."}\n"
                xn = xn - 1
            else
                tvlinet(xn)
                tv = tv..""..i..":Table{"..tostring(v).."}\n"
            end
        elseif type(v) == nil then
            tvlinet(xn)
            tv = tv..i..":nil\n"
        else
            tvlinet(xn)
            tv = tv..tostring(i)..":"..tostring(v).."\n" 
        end
    end
    local function dumpParam(tab)
        for i=1, #tab do  
            if tab[i] == nil then 
                tv = tv.."nil\t"
            elseif type(tab[i]) == "table" then 
                xn = xn + 1
                tv = tv.."table{\n"
                table.foreach(tab[i],printTab)
                tv = tv.."\t}\n"
            else
                tv = tv..tostring(tab[i]).."\n"
            end
        end
    end
    --print("cclog len",#{...})
    dumpParam({...})
    -- print(tv)
    release_print(tv)
    if writeLogToFile then
        writeLogToFile(tv)
    end
end

