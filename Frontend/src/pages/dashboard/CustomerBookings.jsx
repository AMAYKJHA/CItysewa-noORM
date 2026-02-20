import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../../hooks/useAuth";
import { fetchBookings } from "../../api/client";
import "../../Style/Dashboard.css";
import "../../Style/CustomerDashboard.css";
import "../../Style/SectionPages.css";

const CustomerBookings = () => {
    const { user } = useAuth();
    const [bookings, setBookings] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const load = async () => {
            if (!user) return;
            try {
                const res = await fetchBookings({ customer_id: user.id });
                const list = res.data || [];
                setBookings(list.slice().sort((a, b) => new Date(b.created_at || 0) - new Date(a.created_at || 0)));
            } catch (err) {
                console.error("Failed to load bookings:", err);
                setBookings([]);
            } finally {
                setLoading(false);
            }
        };
        load();
    }, [user]);

    if (!user) return <div className="dashboard-loading">Loading...</div>;
    if (loading) return <div className="dashboard-loading">Loading your bookings...</div>;

    return (
        <div className="section-page customer-bookings-page">
            <div className="dashboard-header">
                <h1>My Bookings</h1>
                <p className="dashboard-subtitle">View and manage your booking history</p>
            </div>
            <div className="dashboard-section-card">
                <div className="dashboard-section-header">
                    <h2>All bookings</h2>
                    <Link to="/customer" className="booking-link">Back to Dashboard</Link>
                </div>
                <div className="bookings-list">
                    {bookings.length === 0 ? (
                        <p className="empty-state">
                            No bookings yet. <Link to="/customer/services">Browse services</Link> to book.
                        </p>
                    ) : (
                        bookings.map((booking) => (
                            <div key={booking.id} className="booking-item">
                                <div className="booking-item-header">
                                    <h3>{booking.service?.title || "Service"}</h3>
                                    <span className={`status-badge status-badge--${(booking.status || "pending").toLowerCase()}`}>
                                        {booking.status || "Pending"}
                                    </span>
                                </div>
                                <p className="booking-date">
                                    {booking.booking_date && new Date(booking.booking_date).toLocaleDateString()}
                                    {booking.booking_time ? ` at ${booking.booking_time}` : ""}
                                </p>
                                <p className="booking-address">{booking.customer_address || "Address not provided"}</p>
                                <div className="booking-footer">
                                    <span className="booking-price">
                                        Rs. {booking.service?.price ?? "0"} / {booking.service?.price_unit || "service"}
                                    </span>
                                    <Link to={`/customer/bookings/${booking.id}`} className="booking-link">
                                        View Details
                                    </Link>
                                </div>
                            </div>
                        ))
                    )}
                </div>
            </div>
        </div>
    );
};

export default CustomerBookings;
