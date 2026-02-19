import publicMenu from './publicMenu';
import customerMenu from './customerMenu';
import providerMenu from './providerMenu';
import { useAuth } from '../../../hooks/useAuth.jsx';
import { useTheme } from '../../../context/ThemeContext.jsx';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import "./../../../Style/Navbar.css";
import { useState, useEffect } from 'react';
import sunIcon from "../../../assets/light.png";
import moonIcon from "../../../assets/dark.png";

const Navbar = (props) => {
    const {user} = useAuth();
    const location = useLocation();
    const { isDark, toggleTheme } = useTheme();
    const [menuOpen, setMenuOpen] = useState(false);
    const isAuthenticated = !!user;

    let menu = publicMenu; //Default menu to be displayed

    // if(isAuthenticated) 
    {
        // if(user.role === 'admin') menu = adminMenu;
        // if(user.role === 'provider') menu = providerMenu;
        // if(user.role === 'customer') menu = customerMenu;
        if(props.type === 'admin') menu = adminMenu;
        if(props.type === 'provider') menu = providerMenu;
        if(props.type === 'customer') menu = customerMenu;
    }

    useEffect(()=>{
        const handleScroll = () => {
            if(menuOpen) setMenuOpen(false);
        };
        window.addEventListener("scroll", handleScroll);
        return () => window.removeEventListener("scroll", handleScroll);
    },[menuOpen]);

    return(
        <nav className={`navbar ${menuOpen ? 'menu-open' : ''}`}>
            <NavLogoSection/>
            {/* Hamburger for smaller devices */}
            <button type="button" className="hamburger" onClick={()=>setMenuOpen(prev => !prev)} aria-label="Menu">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
            </button>
            {/* Nav menu for desktop devices */}
            <div className='desktop-menu'>
                <NavMenu menu={menu} role={props.type} currentPath={location.pathname}/>
                <ThemeToggle isDark={isDark} toggleTheme={toggleTheme} />
            </div>
            {/* Nav menu for handheld devices */}
            {  menuOpen && (
                <div className={`handheld-menu ${menuOpen ? 'open' : ''}`}>
                    <NavMenu menu={menu} role={props.type} currentPath={location.pathname}/>
                    <ThemeToggle isDark={isDark} toggleTheme={toggleTheme} />
                </div>
            )}
        </nav>
    );
};

const NavMenu = ({ menu, currentPath, role }) => {
    const {logout} = useAuth();
    const navigate = useNavigate();
    const handleLogout = async () => {
        await logout();
        navigate("/");
    }
    return(
        <section className='nav-menu'>
            {menu.map((navItem) => {
                const isExactMatch = currentPath === navItem.path;
                const isPrefixMatch =
                    navItem.path !== '/' &&
                    currentPath.startsWith(navItem.path);
                const isActive = isExactMatch || isPrefixMatch;

                return (
                    <Link
                        key={navItem.label}
                        to={navItem.path}
                        className={`navItem ${isActive ? 'navItem--active' : ''}`}
                        onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
                    >
                        <span>{navItem.label}</span>
                    </Link>
                );
            })}
            {
                (role === 'customer' || role === 'provider') ? <button className={`navItem navItem--logout`} onClick={handleLogout} >Logout</button> : null
            }
        </section>
    );
}

const NavLogoSection = () => {
    return(
        <section className='nav-logo-section'>
            <div className='siteLogo'></div>
            <h1>CitySewa</h1>
        </section>
    );
}

const ThemeToggle = ({ isDark, toggleTheme }) => {
    return (
        <button 
            className='theme-toggle' 
            onClick={toggleTheme}
            aria-label="Toggle dark mode"
            title={isDark ? 'Switch to light mode' : 'Switch to dark mode'}
        >
            {isDark ? <img src={sunIcon} width={22} height={22} alt='sunicon'/> : <img src={moonIcon} width={20} height={20} alt='moonicon'/>}
        </button>
    );
}

export default Navbar;