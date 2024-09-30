// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// load controllers manually...
//
// This only works when not using importmaps because it tries to import without the fingerprints...
//
// If mounting this engine in a non-importmaps app you can set `config.assets.digest = true` in development.rb to
// work around this problem. Or migrate to importmaps!
//
// This is left here for reference only.
//
// import StoryDisplayController from "./story_display_controller"
// application.register("story-display", StoryDisplayController)
//
// import ExperimentsController from "./experiments_controller"
// application.register("experiments", ExperimentsController)
//
// import CopyController from "./copy_controller"
// application.register("copy", CopyController)
//
// import CodeEditorController from "./code_editor_controller"
// application.register("code-editor", CodeEditorController)

//
// automatically load controllers
//
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
