import React from 'react';
import type { ContestEntry } from '../../../generated/core-api';
import styles from './ContestsTable.module.css';

interface Props {
  contests: ContestEntry[];
}

const ContestsTable: React.FC<Props> = (props) => {
  return (
    <div className={styles['contests-table']}>
      <table>
        <thead>
          <tr>
            <th>Contest Name</th>
            <th>Start Date</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {props.contests.map((contest) => (
            <tr key={contest.id}>
              <td>{contest.name}</td>
              <td>{contest.startDate.toLocaleTimeString() + ' ' + contest.startDate.toLocaleDateString()}</td>
              <td>{contest.status}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ContestsTable;
