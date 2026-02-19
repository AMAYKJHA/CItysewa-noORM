import { useAuth } from "../../hooks/useAuth";
import "../../Style/SectionPages.css";

const CustomerProfile = () => {
    const { user } = useAuth();

    if (!user) return <div className="profile-page"><div className="dashboard-loading">Loading…</div></div>;

    return (
        <div className="profile-page">
            <div className="dashboard-header">
                <h1>My Profile</h1>
                <p className="dashboard-subtitle">Your account details</p>
            </div>
            <div className="profile-card">
                <h2>Account</h2>
                <div className="profile-row">
                    <span className="label">Name</span>
                    <span className="value">{user.first_name} {user.last_name}</span>
                </div>
                <div className="profile-row">
                    <span className="label">Email</span>
                    <span className="value">{user.email}</span>
                </div>
                <div className="profile-row">
                    <span className="label">Phone</span>
                    <span className="value">{user.phone || "—"}</span>
                </div>
                <div className="profile-row">
                    <span className="label">Role</span>
                    <span className="value">Customer</span>
                </div>
            </div>
        </div>
    );
};

export default CustomerProfile;
