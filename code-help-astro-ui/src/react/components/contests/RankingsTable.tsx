import React from 'react';
import type { UserRanking } from '../../../generated/core-api';
import styles from './RankingsTable.module.css';

interface Props {
    rankings: UserRanking[];
}

export const RankingsTable: React.FC<Props> = (props) => {
    return (
        <div className={styles.tableContainer}>
            <table>
                <thead>
                    <tr>
                        <td>Rank</td>
                        <td>User</td>
                        <td>Score</td>
                    </tr>
                </thead>
                <tbody>
                    {props.rankings.map((ranking) => (
                        <tr key={ranking.ranking}>
                            <td>{ranking.ranking}</td>
                            <td>{ranking.user}</td>
                            <td>{ranking.score}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};
