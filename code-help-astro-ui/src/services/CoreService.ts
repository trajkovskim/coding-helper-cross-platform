import { CategoryApi, Configuration, ContestsApi, Difficulty, ProblemApi, SubmissionApi } from "../generated/core-api";

const configuration = new Configuration({
  basePath: "http://localhost/core",
});

type ProblemFilters = {
  title: string;
  categories: string[];
  likedBy: string;
  difficulty: Difficulty;
};

type Pagination = {
  page: number;
  size: number;
  sortBy: string[];
};

class CoreService {
  private categoryApi;
  private problemApi;
  private contestApi;
  private submissionApi;

  constructor() {
    this.categoryApi = new CategoryApi(configuration);
    this.problemApi = new ProblemApi(configuration);
    this.contestApi = new ContestsApi(configuration);
    this.submissionApi = new SubmissionApi(configuration);
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
    return this.contestApi.getContestEntry({ id });
  }

  getSubmissions(problemId: number) {
    return this.submissionApi.getSubmissions({ problemId });
  }
}
