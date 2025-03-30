import { Configuration, PostApi, CategoryApi, CommunityApi, CommentApi } from 'generated/forum-api/index';
import { AUTHORIZATION_HEADER, createAuthorizationHeader } from 'service/api';

const baseConfiguration = new Configuration({
  middleware: [
    {
      pre: (context) => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (context.init.headers as any)[AUTHORIZATION_HEADER] = createAuthorizationHeader();
        return Promise.resolve();
      },
    },
  ],
});

const postApi = new PostApi(baseConfiguration);
const categoryApi = new CategoryApi(baseConfiguration);
const communityApi = new CommunityApi(baseConfiguration);
const commentApi = new CommentApi(baseConfiguration);

export default {
  postApi,
  categoryApi,
  communityApi,
  commentApi,
};
