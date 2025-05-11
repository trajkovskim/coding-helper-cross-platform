import { useState } from 'react';
import { type ProblemEntryBase } from '../../../generated/core-api';
import Difficulty from '../Difficulty';
import styles from './ChallengesTable.module.css';
import ChallengesTableFilters from './ChallengesTableFilters';

interface Props {
  challenges: ProblemEntryBase[];
}

const getStatus = (challenge: ProblemEntryBase) => {
  if (challenge.lastAcceptedSubmission) {
    return challenge.lastAcceptedSubmission.status;
  }

  if (challenge.lastSubmission) {
    return challenge.lastSubmission.status;
  }

  return 'N/A';
};

const ChallengesTable: React.FC<Props> = (props) => {
  const [filters, setFilters] = useState<{
    search?: string;
    difficulty?: string;
    status?: string;
  }>({ search: '', status: '', difficulty: '' });

  return (
    <div className={styles.container}>
      <ChallengesTableFilters filters={filters} setFilters={setFilters} />

      <table className={styles.table}>
        <tbody>
          {props.challenges.map((challenge, index) => (
            <tr key={challenge.id} onClick={() => window.open(`/challenges/${challenge.id}`, '_blank')}>
              <td className={styles.indexColumn}>{index + 1}</td>
              <td className={styles.nameColumn}>{challenge.name}</td>
              <td>
                <Difficulty difficulty={challenge.difficulty} />
              </td>
              <td className={styles.statusColumn}>{getStatus(challenge)}</td>
              <td className={styles.dateColumn}>{challenge.lastSubmission?.createdDate.toString() || 'N/A'}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ChallengesTable;
