import { useEffect, useState } from "react";
import { useOutletContext } from "react-router-dom";
import { fetchCustomers, fetchProviders, fetchVerificationData } from "../../../api/client";
import "../../../Style/Dashboard.css";
import Customers from "./CustomerTable";
import Providers from "./ProviderTable";
import VerificationRequests from "./VerificationRequestsTable";
import ServiceTable from "./ServiceTable";
import BookingTable from "./BookingTable";

const AdminDashboard = () => {
    const { activeSection } = useOutletContext();
    const [stats, setStats] = useState({
        customers: null,
        providers: null,
        pendingVerifications: null,
    });
    const [statsLoading, setStatsLoading] = useState(true);

    useEffect(() => {
        let cancelled = false;
        const load = async () => {
            try {
                const [custRes, provRes, verRes] = await Promise.all([
                    fetchCustomers(),
                    fetchProviders(),
                    fetchVerificationData(),
                ]);
                if (cancelled) return;
                const verificationList = verRes.data || [];
                const pending = verificationList.filter((v) => !v.verified || v.status === "Pending");
                setStats({
                    customers: (custRes.data || []).length,
                    providers: (provRes.data || []).length,
                    pendingVerifications: pending.length,
                });
            } catch {
                if (!cancelled) {
                    setStats({ customers: 0, providers: 0, pendingVerifications: 0 });
                }
            } finally {
                if (!cancelled) setStatsLoading(false);
            }
        };
        load();
        return () => { cancelled = true; };
    }, []);

    const renderContent = () => {
        switch (activeSection) {
            case "Customers":
                return <Customers />;
            case "Providers":
                return <Providers />;
            case "Verification":
                return <VerificationRequests />;
            case "Services":
                return <ServiceTable />;
            case "Bookings":
                return <BookingTable />;
            default:
                return (
                    <div className="dashboard-placeholder">
                        <p>Select a section from the sidebar to view details.</p>
                    </div>
                );
        }
    };

    return (
        <section className="admin-dashboard">
            <div className="dashboard-kpi-grid">
                <div className="dashboard-kpi-card">
                    <span className="dashboard-kpi-label">Total Customers</span>
                    <span className="dashboard-kpi-value">
                        {statsLoading ? "—" : stats.customers ?? "—"}
                    </span>
                </div>
                <div className="dashboard-kpi-card">
                    <span className="dashboard-kpi-label">Total Providers</span>
                    <span className="dashboard-kpi-value">
                        {statsLoading ? "—" : stats.providers ?? "—"}
                    </span>
                </div>
                <div className="dashboard-kpi-card dashboard-kpi-card--accent">
                    <span className="dashboard-kpi-label">Pending Verifications</span>
                    <span className="dashboard-kpi-value">
                        {statsLoading ? "—" : stats.pendingVerifications ?? "—"}
                    </span>
                </div>
            </div>
            <div className="dashboard-content-card">
                {renderContent()}
            </div>
        </section>
    );
};

export default AdminDashboard;
