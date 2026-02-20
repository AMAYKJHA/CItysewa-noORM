import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../../hooks/useAuth";
import { fetchServices } from "../../api/client";
import "../../Style/Dashboard.css";
import "../../Style/ProviderDashboard.css";
import "../../Style/SectionPages.css";

const ProviderMyServices = () => {
    const { user } = useAuth();
    const [services, setServices] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const load = async () => {
            if (!user) return;
            try {
                const res = await fetchServices();
                const all = res.data || [];
                const mine = all.filter(
                    (s) => String(s.provider_id) === String(user.id) || String(s.provider?.id) === String(user.id)
                );
                setServices(mine);
            } catch (err) {
                console.error("Failed to load services:", err);
                setServices([]);
            } finally {
                setLoading(false);
            }
        };
        load();
    }, [user]);

    if (!user) return <div className="dashboard-loading">Loading...</div>;
    if (loading) return <div className="dashboard-loading">Loading your services...</div>;

    return (
        <div className="section-page provider-my-services">
            <div className="dashboard-header">
                <h1>My Services</h1>
                <p className="dashboard-subtitle">Manage and view your listed services</p>
            </div>
            <div className="section-actions">
                <Link to="/provider/services/new" className="section-btn section-btn--primary">
                    Add service
                </Link>
            </div>
            <div className="dashboard-section-card">
                {services.length === 0 ? (
                    <p className="empty-state">
                        You haven&apos;t added any services yet.{" "}
                        <Link to="/provider/services/new">Add your first service</Link>.
                    </p>
                ) : (
                    <div className="services-grid">
                        {services.map((service) => (
                            <Link
                                key={service.id}
                                to={`/provider/services/${service.id}`}
                                className="service-card-link"
                            >
                                <div className="service-card-mini">
                                    <h3>{service.title}</h3>
                                    <p className="service-description">
                                        {service.description
                                            ? `${service.description.substring(0, 80)}${service.description.length > 80 ? "…" : ""}`
                                            : "No description"}
                                    </p>
                                    <p className="service-price">
                                        Rs. {service.price} / {service.price_unit || "service"}
                                    </p>
                                </div>
                            </Link>
                        ))}
                    </div>
                )}
            </div>
        </div>
    );
};

export default ProviderMyServices;
