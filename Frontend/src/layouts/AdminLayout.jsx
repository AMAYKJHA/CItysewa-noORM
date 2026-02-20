import Footer from "../components/common/Footer/Footer";
import { Outlet } from "react-router-dom";
import Sidebar from "../components/admin/sidebar";
import AdminTopBar from "../components/admin/AdminTopBar";
import { useState } from "react";
import "./../Style/Layouts.css";

const AdminLayout = () => {
    const [activeSection, setActiveSection] = useState("Customers");
    const [sidebarOpen, setSidebarOpen] = useState(false);

    const pageTitles = {
        Customers: "Customers",
        Providers: "Providers",
        Bookings: "Bookings",
        Services: "Services",
        Verification: "Verification",
    };

    return (
        <main className="admin-layout">
            <div className="admin-dashboard-layout">
                <Sidebar
                    activeSection={activeSection}
                    setActiveSection={setActiveSection}
                    isOpen={sidebarOpen}
                    onClose={() => setSidebarOpen(false)}
                />
                <div className="admin-main">
                    <AdminTopBar
                        pageTitle={pageTitles[activeSection]}
                        onMenuClick={() => setSidebarOpen((v) => !v)}
                    />
                    <div className="admin-main-content">
                        <Outlet context={{ activeSection }} />
                    </div>
                    <Footer type="admin" />
                </div>
            </div>
        </main>
    );
};

export default AdminLayout;
