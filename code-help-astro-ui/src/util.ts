import { Difficulty, SubmissionStatus } from './generated/core-api';

export const difficultyOptions = Object.values(Difficulty).map((difficulty) => ({
  label: difficulty,
  value: difficulty,
}));

export const statusOptions = Object.values(SubmissionStatus).map((status) => ({
  label: status,
  value: status,
}));
