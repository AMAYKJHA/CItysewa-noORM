import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { fetchServices } from "../../api/client";
import "../../Style/Dashboard.css";
import "../../Style/CustomerDashboard.css";
import "../../Style/SectionPages.css";

const CustomerServices = () => {
    const [services, setServices] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const load = async () => {
            try {
                const res = await fetchServices();
                setServices(res.data || []);
            } catch (err) {
                console.error("Failed to load services:", err);
                setServices([]);
            } finally {
                setLoading(false);
            }
        };
        load();
    }, []);

    if (loading) return <div className="dashboard-loading">Loading services…</div>;

    return (
        <div className="section-page customer-services-page">
            <div className="dashboard-header">
                <h1>Services</h1>
                <p className="dashboard-subtitle">Browse and book services</p>
            </div>
            <div className="dashboard-section-card">
                {services.length === 0 ? (
                    <p className="empty-state">No services available at the moment.</p>
                ) : (
                    <div className="services-grid">
                        {services.map((service) => (
                            <Link
                                key={service.id}
                                to={`/services/${service.id}`}
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

export default CustomerServices;