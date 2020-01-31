
local({

  # construct path to renv in library
  libpath <- local({

    root <- Sys.getenv("RENV_PATHS_LIBRARY", unset = "renv/library")
    prefix <- paste("R", getRversion()[1, 1:2], sep = "-")

    # include SVN revision for development versions of R
    # (to avoid sharing platform-specific artefacts with released versions of R)
    devel <-
      identical(R.version[["status"]],   "Under development (unstable)") ||
      identical(R.version[["nickname"]], "Unsuffered Consequences")

    if (devel)
      prefix <- paste(prefix, R.version[["svn rev"]], sep = "-r")

    file.path(root, prefix, R.version$platform)

  })

  if (length(find.package("renv", quiet = TRUE)) == 0) {
    install.packages("renv")
  }
  lockfile <- renv:::renv_lockfile_read("renv.lock")
  for (p in rev(names(lockfile$Packages))) {
    if (length(find.package(p, quiet = TRUE)) == 0) {
      install.packages(p)
    }
  }
})
