// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

import StoryDisplayController from "./story_display_controller"
application.register("story-display", StoryDisplayController)

import ExperimentsController from "./experiments_controller"
application.register("experiments", ExperimentsController)

import CopyController from "./copy_controller"
application.register("copy", CopyController)

import CodeEditorController from "./code_editor_controller"
application.register("code-editor", CodeEditorController)
