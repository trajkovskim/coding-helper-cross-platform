import { Configuration, ProblemApi, CategoryApi, ContestsApi, SubmissionApi, UserApi } from 'generated/core-api/index';
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

const problemApi = new ProblemApi(baseConfiguration);
const categoryApi = new CategoryApi(baseConfiguration);
const contestsApi = new ContestsApi(baseConfiguration);
const submissionApi = new SubmissionApi(baseConfiguration);
const userApi = new UserApi(baseConfiguration);

export default {
  problemApi,
  categoryApi,
  contestsApi,
  submissionApi,
  userApi,
};
