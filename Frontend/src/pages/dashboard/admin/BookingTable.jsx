import { useEffect, useMemo, useState } from "react";
import { fetchBookings } from "../../../api/client";

const PAGE_SIZE = 10;

const BookingTable = () => {
    const [bookings, setBookings] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [searchBy, setSearchBy] = useState("Id");
    const [searchQuery, setSearchQuery] = useState("");
    const [page, setPage] = useState(0);

    const filtered = useMemo(() => {
        if (!searchQuery.trim()) return bookings;
        const q = searchQuery.trim().toLowerCase();
        return bookings.filter((b) => {
            if (searchBy === "Id") return String(b.id).toLowerCase().includes(q);
            if (searchBy === "Customer") {
                const name = [b.customer?.first_name, b.customer?.last_name].filter(Boolean).join(" ");
                return name.toLowerCase().includes(q);
            }
            if (searchBy === "Provider") {
                const name = [b.provider?.first_name, b.provider?.last_name].filter(Boolean).join(" ");
                return name.toLowerCase().includes(q);
            }
            if (searchBy === "Service") return (b.service?.title || "").toLowerCase().includes(q);
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
                        <option value="Customer">Search by Customer</option>
                        <option value="Provider">Search by Provider</option>
                        <option value="Service">Search by Service</option>
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
                            <th>Service</th>
                            <th>Customer</th>
                            <th>Provider</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        {bookingsOnDisplay.map((booking) => (
                            <tr key={booking.id}>
                                <td>{booking.id}</td>
                                <td>{booking.service?.title || "—"}</td>
                                <td>
                                    {[booking.customer?.first_name, booking.customer?.last_name]
                                        .filter(Boolean)
                                        .join(" ") || "—"}
                                </td>
                                <td>
                                    {[booking.provider?.first_name, booking.provider?.last_name]
                                        .filter(Boolean)
                                        .join(" ") || "—"}
                                </td>
                                <td>
                                    {booking.booking_date
                                        ? new Date(booking.booking_date).toLocaleDateString()
                                        : "—"}
                                </td>
                                <td>{booking.status || "—"}</td>
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
    );
};

export default BookingTable;

