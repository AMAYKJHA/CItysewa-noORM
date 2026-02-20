import { useEffect } from "react";
import { Link } from "react-router-dom";
import "../../Style/Root.css";
import "../../Style/Sidebar.css";
import citySewaLogo from "../../assets/cs.png";
import customerLogo from "../../assets/persons.png";
import providerLogo from "../../assets/provider0.png";
import bookingLogo from "../../assets/booking.png";
import serviceLogo from "../../assets/setting.png";
import verificationLogo from "../../assets/verify.png";

const icons = {
    Customers: (
        <img src={customerLogo} alt="Customers" width={20} height={20} />
    ),
    Providers: (
        <img src={providerLogo} alt="Providers" width={20} height={20} />
    ),
    Bookings: (
        <img src={bookingLogo} alt="Bookings" width={20} height={20} />
    ),
    Services: (
        <img src={serviceLogo} alt="Services" width={20} height={20} />
    ),
    Verification: (
        <img src={verificationLogo} alt="Verification" width={20} height={20} />
    ),
};

const Sidebar = ({ activeSection, setActiveSection, isOpen, onClose }) => {
    const sections = [
        { id: "Customers", label: "Customers" },
        { id: "Providers", label: "Providers" },
        { id: "Bookings", label: "Bookings" },
        { id: "Services", label: "Services" },
        { id: "Verification", label: "Verification" },
    ];

    useEffect(() => {
        const handleEscape = (e) => {
            if (e.key === "Escape") onClose?.();
        };
        if (isOpen) {
            document.addEventListener("keydown", handleEscape);
            document.body.style.overflow = "hidden";
        }
        return () => {
            document.removeEventListener("keydown", handleEscape);
            document.body.style.overflow = "";
        };
    }, [isOpen, onClose]);

    const handleNavClick = (id) => {
        setActiveSection(id);
        onClose?.();
    };

    return (
        <>
            <div
                className={`admin-sidebar-overlay ${isOpen ? "open" : ""}`}
                onClick={onClose}
                aria-hidden="true"
            />
            <aside className={`admin-sidebar ${isOpen ? "open" : ""}`}>
                <div className="admin-sidebar-header">
                    <Link to="/" className="admin-sidebar-brand">
                        <img src={citySewaLogo} alt="CitySewa" className="admin-sidebar-logo" />
                        <span className="admin-sidebar-brand-text">CitySewa</span>
                    </Link>
                    <span className="admin-sidebar-subtitle">Admin</span>
                </div>
                <nav className="admin-sidebar-nav" aria-label="Admin navigation">
                    {sections.map(({ id, label }) => (
                        <button
                            key={id}
                            type="button"
                            className={`admin-sidebar-item ${activeSection === id ? "active" : ""}`}
                            onClick={() => handleNavClick(id)}
                        >
                            <span className="admin-sidebar-icon">{icons[id] || null}</span>
                            <span className="admin-sidebar-label">{label}</span>
                        </button>
                    ))}
                </nav>
            </aside>
        </>
    );
};

export default Sidebar;
