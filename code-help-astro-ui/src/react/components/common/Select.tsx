import React from 'react';
import styles from './Select.module.css';

interface SelectProps {
    value?: string | number;
    onChange: (value: string) => void;
    options: Array<{ value: string | number; label: string }>;
    placeholder?: string;
    className?: string;
    disabled?: boolean;
}

export const Select: React.FC<SelectProps> = ({
    value,
    onChange,
    options,
    placeholder,
    className = '',
    disabled = false,
}) => {
    return (
        <select
            value={value}
            onChange={(e) => onChange(e.target.value)}
            className={`${styles.select} ${className}`}
            disabled={disabled}
        >
            {placeholder && (
                <option value="" disabled>
                    {placeholder}
                </option>
            )}
            {options.map((option) => (
                <option key={option.value} value={option.value}>
                    {option.label}
                </option>
            ))}
        </select>
    );
};