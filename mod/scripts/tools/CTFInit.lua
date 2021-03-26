---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by darionco.
--- DateTime: 2021-03-25 7:55 p.m.
---

local CTFInit = {
    _prefabQueue = {};
}

-- this could be optimized, bleh
function CTFInit:RetrieveUpvalues(fn)
    local info = debug.getinfo(fn, 'uS');
    local variables = {}

    -- Upvalues can't be retrieved from C functions
    if info ~= nil and info.what == 'Lua' then
        local upvalues = info.nups;
        for i = 1, upvalues do
            local key, value = debug.getupvalue(fn, i);
            variables[key] = { i = i, v = value };
        end
    end

    return variables
end

function CTFInit:AddEntryToQueue(fn, file_or_name, name_or_common_fn, common_or_master_fn, master_fn)
    local entry = {
        fn = fn,
        file = file_or_name,
    }

    if type(name_or_common_fn) == 'string' then
        entry.name = name_or_common_fn;
        entry.common_postinit = common_or_master_fn;
        entry.master_postinit = master_fn;
    else
        entry.name = file_or_name;
        entry.common_postinit = name_or_common_fn;
        entry.master_postinit = common_or_master_fn;
    end

    table.insert(self._prefabQueue, entry);
end

function CTFInit:Character(file_or_name, name_or_common_fn, common_or_master_fn, master_fn)
    self:AddEntryToQueue(CTFInit._doCharacterInit, file_or_name, name_or_common_fn, common_or_master_fn, master_fn);
end

function CTFInit:_doCharacterInit(prefab, entry)
    local upvalues = self:RetrieveUpvalues(prefab.fn);
    local common_postinit = entry.common_postinit;
    local master_postinit = entry.master_postinit;

    if common_postinit and upvalues['common_postinit'] then
        local up = upvalues['common_postinit'];
        debug.setupvalue(prefab.fn, up.i, function(inst)
            if up.v ~= nil then
                up.v(inst);
            end
            common_postinit(inst);
        end);
    end

    if master_postinit and upvalues['master_postinit'] then
        local up = upvalues['master_postinit'];
        debug.setupvalue(prefab.fn, up.i, function(inst)
            if up.v ~= nil then
                up.v(inst);
            end
            master_postinit(inst);
        end);
    end
end

function CTFInit:Prefab(file_or_name, name_or_common_fn, common_or_master_fn, master_fn)
    self:AddEntryToQueue(CTFInit._doPrefabInit, file_or_name, name_or_common_fn, common_or_master_fn, master_fn);
end

function CTFInit:_doPrefabInit(prefab, entry)
    local common_postinit = entry.common_postinit;
    local master_postinit = entry.master_postinit;

    if common_postinit then
        local OldCreateEntity = _G.CreateEntity;
        local fenv = {
            CreateEntity = function(name)
                local inst = OldCreateEntity(name);
                -- temporarily replace the entity, it will be restored once SetPristine is called
                local entity = inst.entity;
                local fauxEntity = {
                    SetPristine = function(self)
                        common_postinit(inst);
                        entity:SetPristine(self);
                        inst.entity = entity;
                    end
                }

                setmetatable(fauxEntity, {
                    __index = function(_, key)
                        if type(entity[key]) == 'function' then
                            return function(_, ...)
                                return entity[key](entity, ...);
                            end
                        end
                        return entity[key];
                    end
                })

                inst.entity = fauxEntity;

                return inst;
            end
        }
        setmetatable(fenv, { __index = _G });
        setfenv(prefab.fn, fenv);
    end

    if master_postinit then
        local prefabFn = prefab.fn;
        prefab.fn = function()
            local inst = prefabFn();
            if TheWorld.ismastersim then
                master_postinit(inst);
            end
            return inst;
        end
    end
end

local OldRegisterPrefabs = ModManager.RegisterPrefabs;
ModManager.RegisterPrefabs = function(self)
    OldRegisterPrefabs(self);
    for _, v in ipairs(CTFInit._prefabQueue) do
        local prefabs = LoadPrefabFile('prefabs/' .. v.file);
        if prefabs then
            for _, prefab in ipairs(prefabs) do
                if prefab and prefab.name == v.name then
                    v.fn(CTFInit, prefab, v);
                    break;
                end
            end
        end
    end
end

return CTFInit;