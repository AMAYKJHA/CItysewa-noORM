import { useEffect, useMemo, useState } from "react";
import { fetchBookings, fetchBookingById } from "../../../api/client";

const PAGE_SIZE = 10;

const BookingTable = () => {
    const [bookings, setBookings] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [searchBy, setSearchBy] = useState("Id");
    const [searchQuery, setSearchQuery] = useState("");
    const [page, setPage] = useState(0);
    const [selectedBooking, setSelectedBooking] = useState(null);
    const [detailLoading, setDetailLoading] = useState(false);
    const [detailError, setDetailError] = useState(null);

    const handleDetailClick = async (id) => {
        setDetailError(null);
        setDetailLoading(true);
        setSelectedBooking(null);
        try {
            const res = await fetchBookingById(id);
            setSelectedBooking(res.data);
        } catch {
            setDetailError("Failed to load booking details");
        } finally {
            setDetailLoading(false);
        }
    };
    
    const handleClose = () => {
        setSelectedBooking(null);
        setDetailError(null);
    };

    const filtered = useMemo(() => {
        if (!searchQuery.trim()) return bookings;
        const q = searchQuery.trim().toLowerCase();
        return bookings.filter((b) => {
            if (searchBy === "Id") return String(b.id).toLowerCase().includes(q);
            // if (searchBy === "Customer") {
            //     const name = [b.customer?.first_name, b.customer?.last_name].filter(Boolean).join(" ");
            //     return name.toLowerCase().includes(q);
            // }
            // if (searchBy === "Provider") {
            //     const name = [b.provider?.first_name, b.provider?.last_name].filter(Boolean).join(" ");
            //     return name.toLowerCase().includes(q);
            // }
            if (searchBy === "Service") return String(b.service_id || "").toLowerCase().includes(q);
            return true;
        });
    }, [bookings, searchBy, searchQuery]);

    const totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
    const start = page * PAGE_SIZE;
    const bookingsOnDisplay = filtered.slice(start, start + PAGE_SIZE);

    const showPrev = () => setPage((p) => Math.max(0, p - 1));
    const showNext = () => setPage((p) => Math.min(totalPages - 1, p + 1));

    useEffect(() => {
        const load = async () => {
            try {
                const res = await fetchBookings({});
                
                if (!res || !res.data) {
                    throw new Error("Invalid response");
                }
    
                const list = Array.isArray(res.data)
                    ? res.data.slice().sort((a, b) => a.id - b.id)
                    : [];
    
                setBookings(list);
            } catch (err) {
                console.error(err);
                setError("Failed to fetch bookings");
            } finally {
                setLoading(false);
            }
        };
    
        load();
    }, []);

    if (loading) {
        return (
            <div className="dashboard-table-header">
                <h2>Bookings</h2>
                <div className="dashboard-table-loading">Loading bookings…</div>
            </div>
        );
    }

    if (error) {
        return (
            <div className="dashboard-table-header">
                <h2>Bookings</h2>
                <div className="dashboard-table-error">{error}</div>
            </div>
        );
    }

    return (
        <>
            {selectedBooking != null && (
                <div className="admin-modal-overlay" onClick={handleClose}>
                    <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
                        <div className="admin-modal-header">
                            <h3>Booking details</h3>
                            <button type="button" className="admin-modal-close" onClick={handleClose} aria-label="Close">
                                ×
                            </button>
                        </div>
                        {detailLoading ? (
                            <p className="dashboard-table-loading">Loading…</p>
                        ) : detailError ? (
                            <p className="dashboard-table-error">{detailError}</p>
                        ) : (
                            <div className="verify-request-data">
                                <p><strong>Id:</strong> {selectedBooking.id}</p>
                                <p><strong>Service Id:</strong> {selectedBooking.service_id || "—"}</p>
                                <p><strong>Customer Id:</strong> {selectedBooking.customer_id || "—"}</p>
                                <p><strong>Booking Date:</strong> {selectedBooking.booking_date || "—"}</p>
                                <p><strong>Booking Time:</strong> {selectedBooking.booking_time || "—"}</p>
                                <p><strong>Status:</strong>{" "}
                                    <span className={`status-badge status-badge--${selectedBooking.verified ? "success" : "warning"}`}>
                                        {selectedBooking.status || "—"}
                                    </span>
                                </p>
                                <div className="admin-modal-actions">
                                    <button type="button" className="admin-modal-btn admin-modal-btn--secondary" onClick={handleClose}>
                                        Close
                                    </button>
                                </div>
                            </div>
                        )}
                    </div>
                </div>
            )}
            <section className="dashboard-table-section bookings">
                <div className="dashboard-table-header">
                    <h2>Bookings</h2>
                    <div className="dashboard-table-toolbar">
                        <select
                            value={searchBy}
                            name="searchBy"
                            onChange={(e) => {
                                setSearchBy(e.target.value);
                                setPage(0);
                            }}
                            className="dashboard-table-select"
                        >
                            <option value="Id">Search by Id</option>
                            {/* <option value="Customer">Search by Customer</option> */}
                            {/* <option value="Provider">Search by Provider</option> */}
                            <option value="Service">Search by Service Id</option>
                        </select>
                        <input
                            type="text"
                            placeholder={`Filter by ${searchBy}…`}
                            value={searchQuery}
                            onChange={(e) => {
                                setSearchQuery(e.target.value);
                                setPage(0);
                            }}
                            className="dashboard-table-search"
                        />
                    </div>
                </div>
                <div className="tablewrapper">
                    <table className="dashboard-table">
                        <thead>
                            <tr>
                                <th>Id</th>
                                <th>Service Id</th>
                                <th>Customer Id</th>
                                <th>Date</th>
                                <th>Booking Time</th>
                                <th>Status</th>
                                <th>Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            {bookingsOnDisplay.map((booking) => (
                                <tr key={booking.id}>
                                    <td>{booking.id}</td>
                                    <td>{booking.service_id || "—"}</td>
                                    <td>
                                        {booking.customer_id || "—"}
                                    </td>
                                    {/* <td>
                                        {[booking.provider?.first_name, booking.provider?.last_name]
                                            .filter(Boolean)
                                            .join(" ") || "—"}
                                    </td> */}
                                    <td>
                                        {booking.booking_date
                                            ? new Date(booking.booking_date).toLocaleDateString()
                                            : "—"}
                                    </td>
                                    <td>
                                        {booking.booking_time
                                            ? new Date(`1970-01-01T${booking.booking_time}`).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })
                                            : "—"}
                                    </td>
                                    <td>{booking.status || "—"}</td>
                                    <td onClick={()=>handleDetailClick(booking.id)}>
                                        <span className="table-action-link">View details</span>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
                {filtered.length === 0 ? (
                    <p className="dashboard-table-empty">No bookings match your filters.</p>
                ) : (
                    <div className="dashboard-pagination">
                        <span className="dashboard-pagination-info">
                            Showing {start + 1}–{Math.min(start + PAGE_SIZE, filtered.length)} of {filtered.length}
                        </span>
                        <div className="dashboard-pagination-buttons">
                            <button type="button" onClick={showPrev} disabled={page === 0}>
                                Previous
                            </button>
                            <button type="button" onClick={showNext} disabled={page >= totalPages - 1}>
                                Next
                            </button>
                        </div>
                    </div>
                )}
            </section>
        </>
    );
};

export default BookingTable;

