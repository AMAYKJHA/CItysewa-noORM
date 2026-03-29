import { createContext, useContext, useState, useEffect } from 'react';

const ThemeContext = createContext();

export const ThemeProvider = ({ children }) => {
    const [isLight, setIsLight] = useState(() => {
        const saved = localStorage.getItem('theme');
        if (saved) return saved === 'light';
        return window.matchMedia('(prefers-color-scheme: light)').matches;
    });

    useEffect(() => {
        localStorage.setItem('theme', isLight ? 'light' : 'dark');
        document.documentElement.setAttribute('data-theme', isLight ? 'light' : 'dark');
    }, [isLight]);

    const toggleTheme = () => setIsLight(prev => !prev);

    return (
        <ThemeContext.Provider value={{ isLight, toggleTheme }}>
            {children}
        </ThemeContext.Provider>
    );
};

export const useTheme = () => {
    const context = useContext(ThemeContext);
    if (!context) throw new Error('useTheme must be used within ThemeProvider');
    return context;
};
