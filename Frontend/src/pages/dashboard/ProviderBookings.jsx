import { useEffect, useState } from "react";
import { useAuth } from "../../hooks/useAuth";
import { fetchBookings } from "../../api/client";
import "../../Style/Dashboard.css";
import "../../Style/ProviderDashboard.css";
import "../../Style/SectionPages.css";

const ProviderBookings = () => {
    const { user } = useAuth();
    const [bookings, setBookings] = useState([]);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState("pending");

    useEffect(() => {
        const load = async () => {
            if (!user) return;
            try {
                const res = await fetchBookings({ provider_id: user.id });
                setBookings(res.data || []);
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
    if (loading) return <div className="dashboard-loading">Loading bookings...</div>;

    const filtered = bookings.filter((b) => {
        const s = (b.status || "").toLowerCase();
        return activeTab === "pending" ? s === "pending" : s === "completed";
    });
    const pendingCount = bookings.filter((b) => (b.status || "").toLowerCase() === "pending").length;
    const completedCount = bookings.filter((b) => (b.status || "").toLowerCase() === "completed").length;

    return (
        <div className="section-page provider-bookings-page">
            <div className="dashboard-header">
                <h1>Bookings</h1>
                <p className="dashboard-subtitle">View and manage your booking requests</p>
            </div>
            <div className="dashboard-section-card">
                <div className="dashboard-section-header">
                    <h2>All bookings</h2>
                    <div className="dashboard-tabs">
                        <button
                            type="button"
                            className={`dashboard-tab ${activeTab === "pending" ? "active" : ""}`}
                            onClick={() => setActiveTab("pending")}
                        >
                            Pending ({pendingCount})
                        </button>
                        <button
                            type="button"
                            className={`dashboard-tab ${activeTab === "completed" ? "active" : ""}`}
                            onClick={() => setActiveTab("completed")}
                        >
                            Completed ({completedCount})
                        </button>
                    </div>
                </div>
                <div className="bookings-list">
                    {filtered.length === 0 ? (
                        <p className="empty-state">No {activeTab} bookings.</p>
                    ) : (
                        filtered.map((booking) => (
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
                                <p className="booking-price">
                                    Rs. {booking.service?.price ?? "0"} / {booking.service?.price_unit || "service"}
                                </p>
                            </div>
                        ))
                    )}
                </div>
            </div>
        </div>
    );
};

export default ProviderBookings;
