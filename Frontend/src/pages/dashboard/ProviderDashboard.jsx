import { useEffect, useState } from "react";
import { useAuth } from "../../hooks/useAuth";
import { fetchBookings, getBookingStats } from "../../api/client";
import "../../Style/Dashboard.css";
import "../../Style/ProviderDashboard.css";

const ProviderDashboard = () => {
    const { user } = useAuth();
    const [bookings, setBookings] = useState([]);
    const [stats, setStats] = useState({ pending: 0, completed: 0, earnings: 0, ratings: 0 });
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState("pending");
    const [reviews, setReviews] = useState([]);

    useEffect(() => {
        const loadData = async () => {
            if (!user) return;
            try {
                const [bookingsRes, statsRes] = await Promise.all([
                    fetchBookings({ provider_id: user.id }),
                    getBookingStats(),
                ]);
                const allBookings = bookingsRes.data || [];
                setBookings(allBookings);
                const pending = allBookings.filter((b) => b.status?.toLowerCase() === "pending").length;
                const completed = allBookings.filter((b) => b.status?.toLowerCase() === "completed").length;
                const earnings = allBookings
                    .filter((b) => b.status?.toLowerCase() === "completed")
                    .reduce((sum, b) => sum + (parseFloat(b.service?.price) || 0), 0);
                setStats({ pending, completed, earnings, ratings: 4.5 });
                setReviews([]);
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

    const isVerified = user.verified === true || user.verified === "true";
    const filteredBookings = bookings.filter((b) => {
        const status = b.status?.toLowerCase();
        return activeTab === "pending" ? status === "pending" : status === "completed";
    });

    return (
        <div className="provider-dashboard">
            {!isVerified && (
                <div className="verification-warning" role="alert">
                    <div className="verification-warning-content">
                        <strong>Account Verification Required</strong>
                        <p>Your provider account is not verified. Please verify your account through the CitySewa Provider App to start receiving bookings.</p>
                    </div>
                </div>
            )}
            <div className="dashboard-header">
                <h1>Welcome back, {user.first_name || "Provider"}</h1>
                <p className="dashboard-subtitle">Manage your bookings, earnings, and reviews</p>
            </div>
            <div className="dashboard-stats-grid">
                <div className="dashboard-stat-card">
                    <span className="stat-label">Pending Bookings</span>
                    <span className="stat-value">{stats.pending}</span>
                </div>
                <div className="dashboard-stat-card">
                    <span className="stat-label">Completed</span>
                    <span className="stat-value">{stats.completed}</span>
                </div>
                <div className="dashboard-stat-card dashboard-stat-card--accent">
                    <span className="stat-label">Total Earnings</span>
                    <span className="stat-value">Rs. {stats.earnings.toFixed(2)}</span>
                </div>
                <div className="dashboard-stat-card">
                    <span className="stat-label">Average Rating</span>
                    <span className="stat-value">{stats.ratings.toFixed(1)} ⭐</span>
                </div>
            </div>
            <div className="dashboard-content-grid">
                <div className="dashboard-section-card">
                    <div className="dashboard-section-header">
                        <h2>Bookings</h2>
                        <div className="dashboard-tabs">
                            <button
                                type="button"
                                className={`dashboard-tab ${activeTab === "pending" ? "active" : ""}`}
                                onClick={() => setActiveTab("pending")}
                            >
                                Pending ({stats.pending})
                            </button>
                            <button
                                type="button"
                                className={`dashboard-tab ${activeTab === "completed" ? "active" : ""}`}
                                onClick={() => setActiveTab("completed")}
                            >
                                Completed ({stats.completed})
                            </button>
                        </div>
                    </div>
                    <div className="bookings-list">
                        {filteredBookings.length === 0 ? (
                            <p className="empty-state">No {activeTab} bookings found.</p>
                        ) : (
                            filteredBookings.map((booking) => (
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
                                    <p className="booking-price">Rs. {booking.service?.price || "0"} / {booking.service?.price_unit || "service"}</p>
                                </div>
                            ))
                        )}
                    </div>
                </div>
                <div className="dashboard-section-card">
                    <div className="dashboard-section-header">
                        <h2>Reviews & Ratings</h2>
                    </div>
                    <div className="reviews-section">
                        {reviews.length === 0 ? (
                            <p className="empty-state">No reviews yet. Complete bookings to receive customer feedback.</p>
                        ) : (
                            reviews.map((review) => (
                                <div key={review.id} className="review-item">
                                    <div className="review-header">
                                        <span className="review-rating">{"⭐".repeat(review.rating)}</span>
                                        <span className="review-date">{new Date(review.created_at).toLocaleDateString()}</span>
                                    </div>
                                    <p className="review-comment">{review.comment}</p>
                                    <p className="review-customer">— {review.customer_name}</p>
                                </div>
                            ))
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ProviderDashboard;
