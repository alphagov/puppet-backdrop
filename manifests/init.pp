class backdrop($user, $group, $pip_cache_path) {

    file { $pip_cache_path:
        path     => $pip_cache_path,
        ensure   => directory,
        owner    => $user,
        group    => $group,
        recurse  => true,
    }

}
