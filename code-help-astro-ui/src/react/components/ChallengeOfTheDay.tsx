import { useEffect, useState } from 'react';
import { publicCoreService } from '../../services';
import { type ProblemEntry } from '../../generated/core-api';
import Difficulty from './Difficulty';
import useRequest from '../hooks/useRequest';
import css from './ChallengeOfTheDay.module.css';
import Spinner from './Spinner';

const ChallengeOfTheDay: React.FC = () => {
  const [challenge, setChallenge] = useState<ProblemEntry>();
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicCoreService.getProblems({ page: 0, size: 1, sortBy: ['likes=desc'] }).then((response) => {
        if (response.totalElements) {
          setChallenge(response.problems[0]);
        }
      })
    );
  }, []);

  if (!challenge || loading) {
    return <Spinner />;
  }

  return (
    <div className={css.container}>
      <div className={css.head}>
        <div className={css.dots}></div>
        <div className="text-xl">{challenge.name}</div>
        <div className={css.box}>
          <Difficulty difficulty={challenge.difficulty} />
          <span className="text-xs">Liked by {challenge.likes} users</span>
        </div>
        <div>{challenge.description}</div>
      </div>
      {challenge.testCases.length > 0 && (
        <div className={css.input}>
          <code>
            <div>Input: nums = {challenge.testCases[0]._in}</div>
            <div>Output: {challenge.testCases[0].out}</div>
          </code>
        </div>
      )}
      <button className={css.btn}>Check it out</button>
    </div>
  );
};

export default ChallengeOfTheDay;
