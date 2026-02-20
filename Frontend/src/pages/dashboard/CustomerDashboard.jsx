import { useEffect, useState } from "react";
import { useAuth } from "../../hooks/useAuth";
import { fetchCustomerBookings, fetchServices } from "../../api/client";
import { Link } from "react-router-dom";
import "../../Style/Dashboard.css";
import "../../Style/CustomerDashboard.css";

const CustomerDashboard = () => {
    const { user } = useAuth();
    const [bookings, setBookings] = useState([]);
    const [featuredServices, setFeaturedServices] = useState([]);
    const [loading, setLoading] = useState(true);
    const [stats, setStats] = useState({ totalBookings: 0, totalSpent: 0 });

    useEffect(() => {
        const loadData = async () => {
            if (!user) return;
            try {
                const [bookingsRes, servicesRes] = await Promise.all([
                    fetchCustomerBookings(user.id),
                    fetchServices(),
                ]);
                const allBookings = bookingsRes.data || [];
                setBookings(allBookings.slice().sort((a, b) => new Date(b.created_at) - new Date(a.created_at)));
                const totalSpent = allBookings
                    .filter((b) => b.status?.toLowerCase() === "completed")
                    .reduce((sum, b) => sum + (parseFloat(b.service?.price) || 0), 0);
                setStats({ totalBookings: allBookings.length, totalSpent });
                const services = servicesRes.data || [];
                setFeaturedServices(services.slice(0, 6));
            } catch (err) {
                console.error("Failed to load dashboard data:", err);
            } finally {
                setLoading(false);
            }
        };
        loadData();
    }, [user]);

    if (!user) return <div className="dashboard-loading">Loading...</div>;
    if (loading) return <div className="dashboard-loading">Loading dashboard...</div>;

    return (
        <div className="customer-dashboard">
            <div className="verification-warning" role="alert">
                <div className="verification-warning-content">
                    <p>Please download the CitySewa Customer App in your mobile device to start booking services. <a target="_blank" href="https://citysewa.vercel.app/">Click here</a></p>
                </div>
            </div>
            <div className="dashboard-header">
                <h1>Welcome back, {user.first_name || "Customer"}</h1>
                <p className="dashboard-subtitle">View your bookings and discover new services</p>
            </div>
            <div className="dashboard-stats-grid">
                <div className="dashboard-stat-card">
                    <span className="stat-label">Total Bookings</span>
                    <span className="stat-value">{stats.totalBookings}</span>
                </div>
                <div className="dashboard-stat-card dashboard-stat-card--accent">
                    <span className="stat-label">Total Spent</span>
                    <span className="stat-value">Rs. {stats.totalSpent.toFixed(2)}</span>
                </div>
            </div>
            <div className="dashboard-content-grid">
                <div className="dashboard-section-card">
                    <div className="dashboard-section-header">
                        <h2>Booking History</h2>
                    </div>
                    <div className="bookings-list">
                        {bookings.length === 0 ? (
                            <p className="empty-state">No bookings yet. <Link to="/services">Browse services</Link> to get started.</p>
                        ) : (
                            bookings.map((booking) => (
                                <div key={booking.id} className="booking-item">
                                    <div className="booking-item-header">
                                        <h3>{booking.service?.title || "Service"}</h3>
                                        <span className={`status-badge status-badge--${booking.status?.toLowerCase()}`}>
                                            {booking.status || "Pending"}
                                        </span>
                                    </div>
                                    <p className="booking-date">
                                        {new Date(booking.booking_date).toLocaleDateString()} at {booking.booking_time}
                                    </p>
                                    <p className="booking-address">{booking.customer_address || "Address not provided"}</p>
                                    <div className="booking-footer">
                                        <span className="booking-price">Rs. {booking.service?.price || "0"} / {booking.service?.price_unit || "service"}</span>
                                        <Link to={`/customer/bookings/${booking.id}`} className="booking-link">View Details</Link>
                                    </div>
                                </div>
                            ))
                        )}
                    </div>
                </div>
                <div className="dashboard-section-card">
                    <div className="dashboard-section-header">
                        <h2>Featured Services</h2>
                        <Link to="/services" className="section-link">View All</Link>
                    </div>
                    <div className="services-grid">
                        {featuredServices.length === 0 ? (
                            <p className="empty-state">No services available at the moment.</p>
                        ) : (
                            featuredServices.map((service) => (
                                <Link key={service.id} to={`/services/${service.id}`} className="service-card-link">
                                    <div className="service-card-mini">
                                        <h3>{service.title}</h3>
                                        <p className="service-description">{service.description?.substring(0, 80)}...</p>
                                        <p className="service-price">Rs. {service.price} / {service.price_unit}</p>
                                    </div>
                                </Link>
                            ))
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default CustomerDashboard;
