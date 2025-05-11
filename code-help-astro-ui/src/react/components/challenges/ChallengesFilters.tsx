import React, { useState } from 'react';

interface FilterProps {
    onFilterChange: (filters: FilterState) => void;
}

interface FilterState {
    difficulty: string;
    category: string;
    searchTerm: string;
}

const ChallengesFilters: React.FC<FilterProps> = ({ onFilterChange }) => {
    const [filters, setFilters] = useState<FilterState>({
        difficulty: 'all',
        category: 'all',
        searchTerm: '',
    });

    const handleFilterChange = (field: keyof FilterState, value: string) => {
        const newFilters = { ...filters, [field]: value };
        setFilters(newFilters);
        onFilterChange(newFilters);
    };

    return (
        <div className="flex flex-col gap-4 p-4 bg-gray-100 rounded-lg">
            <div className="flex flex-wrap gap-4">
                {/* Search Input */}
                <input
                    type="text"
                    placeholder="Search challenges..."
                    className="px-4 py-2 border rounded-md"
                    value={filters.searchTerm}
                    onChange={(e) => handleFilterChange('searchTerm', e.target.value)}
                />

                {/* Difficulty Filter */}
                <select
                    className="px-4 py-2 border rounded-md"
                    value={filters.difficulty}
                    onChange={(e) => handleFilterChange('difficulty', e.target.value)}
                >
                    <option value="all">All Difficulties</option>
                    <option value="easy">Easy</option>
                    <option value="medium">Medium</option>
                    <option value="hard">Hard</option>
                </select>

                {/* Category Filter */}
                <select
                    className="px-4 py-2 border rounded-md"
                    value={filters.category}
                    onChange={(e) => handleFilterChange('category', e.target.value)}
                >
                    <option value="all">All Categories</option>
                    <option value="algorithms">Algorithms</option>
                    <option value="data-structures">Data Structures</option>
                    <option value="system-design">System Design</option>
                </select>
            </div>
        </div>
    );
};

export default ChallengesFilters;