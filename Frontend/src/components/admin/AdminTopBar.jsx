import { useTheme } from "../../context/ThemeContext";
import sunIcon from "../../assets/light.png";
import moonIcon from "../../assets/dark.png";

const AdminTopBar = ({ pageTitle, onMenuClick }) => {
    const { isDark, toggleTheme } = useTheme();

    return (
        <header className="admin-topbar">
            <button
                type="button"
                className="admin-topbar-menu-btn"
                onClick={onMenuClick}
                aria-label="Toggle menu"
            >
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <line x1="3" y1="12" x2="21" y2="12" />
                    <line x1="3" y1="6" x2="21" y2="6" />
                    <line x1="3" y1="18" x2="21" y2="18" />
                </svg>
            </button>
            <div className="admin-topbar-content">
                <nav className="admin-breadcrumb" aria-label="Breadcrumb">
                    <span className="admin-breadcrumb-item">Dashboard</span>
                    {pageTitle && (
                        <>
                            <span className="admin-breadcrumb-sep">/</span>
                            <span className="admin-breadcrumb-current">{pageTitle}</span>
                        </>
                    )}
                </nav>
                <div className="admin-topbar-actions">
                    <button
                        type="button"
                        className="admin-topbar-theme-btn"
                        onClick={toggleTheme}
                        aria-label={isDark ? "Switch to light mode" : "Switch to dark mode"}
                        title={isDark ? "Light mode" : "Dark mode"}
                    >
                        {isDark ? <img src={sunIcon} alt="sunicon" width={22} height={22}/> : <img src={moonIcon} alt="moonicon" width={20} height={20}/>}
                    </button>
                </div>
            </div>
        </header>
    );
};

export default AdminTopBar;
