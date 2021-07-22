local env, args = ...

--===== test start =====--
print(env.setPermission(1, "test_perm2", 8))

print(env.getPermissionLevel(1, "test_perm2"))