import {
  CategoryApi,
  Configuration,
  type ConfigurationParameters,
  ContestsApi,
  Difficulty,
  ProblemApi,
  SubmissionApi,
  UserApi
} from "../generated/core-api";

type ProblemFilters = {
  title: string;
  categories: string[];
  likedBy: string;
  difficulty: Difficulty;
};

type Pagination = {
  page?: number;
  size?: number;
  sortBy?: string[];
};

export default class CoreService {
  private categoryApi;
  private problemApi;
  private contestApi;
  private submissionApi;
  private userApi;

  constructor(configurationParameters: ConfigurationParameters) {
    const configuration = new Configuration(configurationParameters);

    this.categoryApi = new CategoryApi(configuration);
    this.problemApi = new ProblemApi(configuration);
    this.contestApi = new ContestsApi(configuration);
    this.submissionApi = new SubmissionApi(configuration);
    this.userApi = new UserApi(configuration);
  }

  getCategories() {
    return this.categoryApi.getCategories();
  }

  getProblems(pagination?: Pagination, filters?: ProblemFilters) {
    return this.problemApi.getProblemEntries({ ...pagination, ...filters });
  }

  getProblem(id: number, language: string) {
    return this.problemApi.getProblemEntry({ id, language });
  }

  getContests(pagination?: Pagination) {
    return this.contestApi.getContestEntries({ ...pagination });
  }

  getContest(id: number) {
    return this.contestApi.getContestEntry({ id, language: "javascript" });
  }

  getSubmissions(problemId: number) {
    return this.submissionApi.getSubmissions({ problemId });
  }

  getRankings() {
    return this.userApi.getRankings();
  }
}