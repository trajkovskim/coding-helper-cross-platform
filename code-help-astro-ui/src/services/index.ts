import CoreService from "./CoreService.ts";
import ForumService from "./ForumService.ts";

export const publicCoreService = new CoreService({
  basePath: import.meta.env.PUBLIC_CORE_API,
})

export const publicForumService = new ForumService({
  basePath: import.meta.env.PUBLIC_FORUM_API,
})