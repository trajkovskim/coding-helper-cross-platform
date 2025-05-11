import React from 'react';
import ReactMarkdown from 'react-markdown';
import type { ProblemEntry } from '../../../../generated/core-api';
import Difficulty from '../../Difficulty';
import CodeEditor from './CodeEditor';

interface ChallengeProps {
  challenge: ProblemEntry;
}

export const ChallengeDetail: React.FC<ChallengeProps> = ({ challenge }: ChallengeProps) => {
  return (
    <div>
      <h1>{challenge.name}</h1>
      <Difficulty difficulty={challenge.difficulty} /> <span>{challenge.likes}</span>
      <p>
        <ReactMarkdown>{challenge.markdown}</ReactMarkdown>
      </p>
      <CodeEditor />
    </div>
  );
};
