import React from 'react';
import Input from '../common/Input';
import { Select } from '../common/Select';
import styles from './ChallengesTableFilters.module.css';
import { difficultyOptions, statusOptions } from '../../../util';

interface Filters {
  difficulty?: string;
  status?: string;
  search?: string;
}

interface ChallengesTableFiltersProps {
  filters: Filters;
  setFilters: (filters: Filters) => void;
}

const ChallengesTableFilters: React.FC<ChallengesTableFiltersProps> = ({ filters, setFilters }) => {
  return (
    <div>
      <div className={styles.filterContainer}>
        <Input
          placeholder="Search"
          className={styles.searchInput}
          value={filters.search}
          onChange={(e) => setFilters({ ...filters, search: e.target.value })}
        />
        <Select
          placeholder="Select Difficulty"
          className={styles.difficultySelect}
          options={difficultyOptions}
          value={filters.difficulty}
          onChange={(value) => setFilters({ ...filters, difficulty: value })}
        />
        <Select
          placeholder="Select Status"
          className={styles.statusSelect}
          options={statusOptions}
          value={filters.status}
          onChange={(value) => setFilters({ ...filters, status: value })}
        />
      </div>
      <div className={styles.selectedFilters}>
        {Object.entries(filters)
          .filter((x) => x[1])
          .map(([key, value]) => (
            <span key={key} className={styles.filterValue}>
              <span>
                {key}: {value}
              </span>
              <button className={styles.clearButton} onClick={() => setFilters({ ...filters, [key]: '' })} />
            </span>
          ))}
      </div>
    </div>
  );
};

export default ChallengesTableFilters;
