import { useEffect, useState, useMemo } from "react";
import { fetchProviders } from "../../../api/client";

const PAGE_SIZE = 10;

const Providers = () => {
    const [providers, setProviders] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [searchBy, setSearchBy] = useState("Id");
    const [searchQuery, setSearchQuery] = useState("");
    const [page, setPage] = useState(0);

    const filtered = useMemo(() => {
        if (!searchQuery.trim()) return providers;
        const q = searchQuery.trim().toLowerCase();
        return providers.filter((p) => {
            if (searchBy === "Id") return String(p.id).toLowerCase().includes(q);
            if (searchBy === "First Name") return (p.first_name || "").toLowerCase().includes(q);
            if (searchBy === "Last Name") return (p.last_name || "").toLowerCase().includes(q);
            return true;
        });
    }, [providers, searchBy, searchQuery]);

    const totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
    const start = page * PAGE_SIZE;
    const providersOnDisplay = filtered.slice(start, start + PAGE_SIZE);

    const showPrev = () => setPage((p) => Math.max(0, p - 1));
    const showNext = () => setPage((p) => Math.min(totalPages - 1, p + 1));

    useEffect(() => {
        const load = async () => {
            try {
                const res = await fetchProviders();
                const sorted = (res.data || []).slice().sort((a, b) => a.id - b.id);
                setProviders(sorted);
            } catch (e) {
                setError("Failed to fetch providers");
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
                <h2>Providers</h2>
                <div className="dashboard-table-loading">Loading providers…</div>
            </div>
        );
    }

    if (error) {
        return (
            <div className="dashboard-table-header">
                <h2>Providers</h2>
                <div className="dashboard-table-error">{error}</div>
            </div>
        );
    }

    return (
        <section className="dashboard-table-section providers">
            <div className="dashboard-table-header">
                <h2>Providers</h2>
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
                            <th>Verified</th>
                        </tr>
                    </thead>
                    <tbody>
                        {providersOnDisplay.map((provider) => (
                            <tr key={provider.id}>
                                <td>{provider.id}</td>
                                <td>{[provider.first_name, provider.last_name].filter(Boolean).join(" ") || "—"}</td>
                                <td>{provider.gender || "—"}</td>
                                <td>{provider.email || "—"}</td>
                                <td>{provider.verified ? "Yes" : "No"}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
            {filtered.length === 0 ? (
                <p className="dashboard-table-empty">No providers match your filters.</p>
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

export default Providers;
