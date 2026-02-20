import { useEffect, useMemo, useState } from "react";
import { fetchServices } from "../../../api/client";

const PAGE_SIZE = 10;

const ServiceTable = () => {
    const [services, setServices] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [searchBy, setSearchBy] = useState("Title");
    const [searchQuery, setSearchQuery] = useState("");
    const [page, setPage] = useState(0);

    const filtered = useMemo(() => {
        if (!searchQuery.trim()) return services;
        const q = searchQuery.trim().toLowerCase();
        return services.filter((s) => {
            if (searchBy === "Id") return String(s.id).toLowerCase().includes(q);
            if (searchBy === "Title") return (s.title || "").toLowerCase().includes(q);
            if (searchBy === "Provider") {
                const name = [s.provider?.first_name, s.provider?.last_name].filter(Boolean).join(" ");
                return name.toLowerCase().includes(q);
            }
            return true;
        });
    }, [services, searchBy, searchQuery]);

    const totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
    const start = page * PAGE_SIZE;
    const servicesOnDisplay = filtered.slice(start, start + PAGE_SIZE);

    const showPrev = () => setPage((p) => Math.max(0, p - 1));
    const showNext = () => setPage((p) => Math.min(totalPages - 1, p + 1));

    useEffect(() => {
        const load = async () => {
            try {
                const res = await fetchServices();
                if(!res || !res.data) {
                    throw new Error("Invalid response");
                }
                const list = Array.isArray(res.data)
                    ? res.data.slice().sort((a, b) => a.id - b.id)
                    : [];
                setServices(list);
            } catch (err) {
                console.error(err);
                setError("Failed to fetch services");
            } finally {
                setLoading(false);
            }
        };
        load();
    }, []);

    if (loading) {
        return (
            <div className="dashboard-table-header">
                <h2>Services</h2>
                <div className="dashboard-table-loading">Loading services…</div>
            </div>
        );
    }

    if (error) {
        return (
            <div className="dashboard-table-header">
                <h2>Services</h2>
                <div className="dashboard-table-error">{error}</div>
            </div>
        );
    }

    return (
        <section className="dashboard-table-section services">
            <div className="dashboard-table-header">
                <h2>Services</h2>
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
                        <option value="Title">Search by Title</option>
                        <option value="Provider">Search by Provider</option>
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
                            <th>Title</th>
                            <th>Provider</th>
                            <th>Category</th>
                            <th>Price</th>
                        </tr>
                    </thead>
                    <tbody>
                        {servicesOnDisplay.map((service) => (
                            <tr key={service.id}>
                                <td>{service.id}</td>
                                <td>{service.title || "—"}</td>
                                <td>
                                    {service.provider_name || "—"}
                                </td>
                                <td>{service.category || service.service_type || "—"}</td>
                                <td>
                                    {service.price != null
                                        ? `Rs. ${service.price} ${service.price_unit || "service"}`
                                        : "—"}
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
            {filtered.length === 0 ? (
                <p className="dashboard-table-empty">No services match your filters.</p>
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

export default ServiceTable;

