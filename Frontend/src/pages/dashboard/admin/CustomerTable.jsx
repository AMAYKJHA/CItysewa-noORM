import { useEffect, useState, useMemo } from "react";
import { fetchCustomers } from "../../../api/client";

const PAGE_SIZE = 10;

const Customers = () => {
    const [customers, setCustomers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [searchBy, setSearchBy] = useState("Id");
    const [searchQuery, setSearchQuery] = useState("");
    const [page, setPage] = useState(0);

    const filtered = useMemo(() => {
        if (!searchQuery.trim()) return customers;
        const q = searchQuery.trim().toLowerCase();
        return customers.filter((c) => {
            if (searchBy === "Id") return String(c.id).toLowerCase().includes(q);
            if (searchBy === "First Name") return (c.first_name || "").toLowerCase().includes(q);
            if (searchBy === "Last Name") return (c.last_name || "").toLowerCase().includes(q);
            return true;
        });
    }, [customers, searchBy, searchQuery]);

    const totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
    const start = page * PAGE_SIZE;
    const customersOnDisplay = filtered.slice(start, start + PAGE_SIZE);

    const showPrev = () => setPage((p) => Math.max(0, p - 1));
    const showNext = () => setPage((p) => Math.min(totalPages - 1, p + 1));

    useEffect(() => {
        const load = async () => {
            try {
                const res = await fetchCustomers();
                const sorted = (res.data || []).slice().sort((a, b) => a.id - b.id);
                setCustomers(sorted);
            } catch (e) {
                setError("Failed to fetch customers");
                console.error(e);
            } finally {
                setLoading(false);
            }
        };
        load();
    }, []);

    if (loading) {
        return (
            <div className="dashboard-table-header">
                <h2>Customers</h2>
                <div className="dashboard-table-loading">Loading customers…</div>
            </div>
        );
    }

    if (error) {
        return (
            <div className="dashboard-table-header">
                <h2>Customers</h2>
                <div className="dashboard-table-error">{error}</div>
            </div>
        );
    }

    return (
        <section className="dashboard-table-section customers">
            <div className="dashboard-table-header">
                <h2>Customers</h2>
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
                        <option value="First Name">Search by First Name</option>
                        <option value="Last Name">Search by Last Name</option>
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
                            <th>Name</th>
                            <th>Gender</th>
                            <th>Email</th>
                        </tr>
                    </thead>
                    <tbody>
                        {customersOnDisplay.map((customer) => (
                            <tr key={customer.id}>
                                <td>{customer.id}</td>
                                <td>{[customer.first_name, customer.last_name].filter(Boolean).join(" ") || "—"}</td>
                                <td>{customer.gender || "—"}</td>
                                <td>{customer.email || "—"}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
            {filtered.length === 0 ? (
                <p className="dashboard-table-empty">No customers match your filters.</p>
            ) : (
                <div className="dashboard-pagination">
                    <span className="dashboard-pagination-info">
                        Showing {start + 1}–{Math.min(start + PAGE_SIZE, filtered.length)} of {filtered.length}
                    </span>
                    <div className="dashboard-pagination-buttons">
                        <button type="button" onClick={showPrev} disabled={page === 0}>Previous</button>
                        <button type="button" onClick={showNext} disabled={page >= totalPages - 1}>Next</button>
                    </div>
                </div>
            )}
        </section>
    );
};

export default Customers;
