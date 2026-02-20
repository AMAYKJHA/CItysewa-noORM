import { useEffect, useState, useMemo } from "react";
import {
    fetchVerificationData,
    fetchVerificationDataById,
    updateVerificationData,
} from "../../../api/client";

const PAGE_SIZE = 10;

const VerificationRequests = () => {
    const [requests, setRequests] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [searchBy, setSearchBy] = useState("Id");
    const [searchQuery, setSearchQuery] = useState("");
    const [page, setPage] = useState(0);
    const [selectedRequest, setSelectedRequest] = useState(null);
    const [detailLoading, setDetailLoading] = useState(false);
    const [detailError, setDetailError] = useState(null);

    const filtered = useMemo(() => {
        if (!searchQuery.trim()) return requests;
        const q = searchQuery.trim().toLowerCase();
        return requests.filter((r) => {
            if (searchBy === "Id") return String(r.id).toLowerCase().includes(q);
            if (searchBy === "First Name") return (r.first_name || "").toLowerCase().includes(q);
            if (searchBy === "Last Name") return (r.last_name || "").toLowerCase().includes(q);
            return true;
        });
    }, [requests, searchBy, searchQuery]);

    const totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
    const start = page * PAGE_SIZE;
    const requestsOnDisplay = filtered.slice(start, start + PAGE_SIZE);

    const showPrev = () => setPage((p) => Math.max(0, p - 1));
    const showNext = () => setPage((p) => Math.min(totalPages - 1, p + 1));

    const loadRequests = async () => {
        try {
            const res = await fetchVerificationData();
            const sorted = (res.data || []).slice().sort((a, b) => a.id - b.id);
            setRequests(sorted);
        } catch (e) {
            setError("Failed to fetch requests");
            console.error(e);
        }
    };

    useEffect(() => {
        const load = async () => {
            setLoading(true);
            await loadRequests();
            setLoading(false);
        };
        load();
    }, []);

    const handleRowClick = async (id) => {
        setDetailError(null);
        setDetailLoading(true);
        setSelectedRequest(null);
        try {
            const res = await fetchVerificationDataById(id);
            setSelectedRequest(res.data);
        } catch {
            setDetailError("Failed to load request details");
        } finally {
            setDetailLoading(false);
        }
    };

    const handleClose = () => {
        setSelectedRequest(null);
        setDetailError(null);
    };

    const updateVerificationStatus = async (verStatus) => {
        if (!selectedRequest) return;
        try {
            await updateVerificationData(selectedRequest.id, {
                document_number: selectedRequest.document_number,
                status: verStatus,
                verified: verStatus === "Verified",
            });
            await loadRequests();
            handleClose();
        } catch (err) {
            console.error(err?.response?.data || err.message);
        }
    };

    if (loading) {
        return (
            <div className="dashboard-table-header">
                <h2>Verification Requests</h2>
                <div className="dashboard-table-loading">Loading verification requests…</div>
            </div>
        );
    }

    if (error) {
        return (
            <div className="dashboard-table-header">
                <h2>Verification Requests</h2>
                <div className="dashboard-table-error">{error}</div>
            </div>
        );
    }

    return (
        <>
            {selectedRequest != null && (
                <div className="admin-modal-overlay" onClick={handleClose}>
                    <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
                        <div className="admin-modal-header">
                            <h3>Provider verification details</h3>
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
                                <div className="verify-request-data-row verify-request-data-photo">
                                    <a href={selectedRequest.photo} target="_blank" rel="noreferrer">
                                        <img src={selectedRequest.photo} alt="Provider" />
                                    </a>
                                </div>
                                <p><strong>Id:</strong> {selectedRequest.id}</p>
                                <p><strong>Name:</strong> {[selectedRequest.first_name, selectedRequest.last_name].filter(Boolean).join(" ") || "—"}</p>
                                <p><strong>Gender:</strong> {selectedRequest.gender || "—"}</p>
                                <p><strong>Phone:</strong> {selectedRequest.phone_number || "—"}</p>
                                <p><strong>Document type:</strong> {selectedRequest.document_type || "—"}</p>
                                <p><strong>Document number:</strong> {selectedRequest.document_number || "—"}</p>
                                <p><strong>Document:</strong>{" "}
                                    <a href={selectedRequest.file_name} target="_blank" rel="noreferrer">View document</a>
                                </p>
                                <p><strong>Status:</strong>{" "}
                                    <span className={`status-badge status-badge--${selectedRequest.verified ? "success" : "warning"}`}>
                                        {selectedRequest.status || (selectedRequest.verified ? "Verified" : "Pending")}
                                    </span>
                                </p>
                                <div className="admin-modal-actions">
                                    <button type="button" className="admin-modal-btn admin-modal-btn--success" onClick={() => updateVerificationStatus("Verified")}>
                                        Approve
                                    </button>
                                    <button type="button" className="admin-modal-btn admin-modal-btn--danger" onClick={() => updateVerificationStatus("Not verified")}>
                                        Reject
                                    </button>
                                    <button type="button" className="admin-modal-btn admin-modal-btn--secondary" onClick={handleClose}>
                                        Close
                                    </button>
                                </div>
                            </div>
                        )}
                    </div>
                </div>
            )}

            <section className="dashboard-table-section verification-requests">
                <div className="dashboard-table-header">
                    <h2>Verification Requests</h2>
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
                                <th>Phone</th>
                                <th>Document type</th>
                                <th>Document no.</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {requestsOnDisplay.map((req) => (
                                <tr key={req.id} onClick={() => handleRowClick(req.id)}>
                                    <td>{req.id}</td>
                                    <td>{[req.first_name, req.last_name].filter(Boolean).join(" ") || "—"}</td>
                                    <td>{req.phone_number ? "View" : "—"}</td>
                                    <td>{req.document_type || "—"}</td>
                                    <td>{req.document_number ? "View" : "—"}</td>
                                    <td>
                                        <span className="table-action-link">View details</span>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
                {filtered.length === 0 ? (
                    <p className="dashboard-table-empty">No verification requests at the moment.</p>
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
        </>
    );
};

export default VerificationRequests;
