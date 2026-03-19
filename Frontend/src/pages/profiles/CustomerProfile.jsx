import { useEffect, useState } from "react";
import { useAuth } from "../../hooks/useAuth";
import "../../Style/SectionPages.css";
import { fetchCustomerById } from "../../api/client";

const CustomerProfile = () => {
    const { user } = useAuth();
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [userInfo, setUserInfo] = useState(null);

    if (!user) return <div className="profile-page"><div className="dashboard-loading">Loading…</div></div>;

    useEffect(() => {
        const loadUser = async () => {
            if (!user) return;
            try {
                const response = await fetchCustomerById(user.id);
                const info = response.data;
                setUserInfo(info);
            } catch (err) {
                setError("Failed to fetch info")
                console.error(err);
            } finally {
                setLoading(false);
            }
        };
        loadUser();
    },[]);

    if(loading) {
        return (
            <p style={{textAlign:'center', height:'200px', placeContent:'center'}}>Loading Info...</p>
        )
    }

    if(error) {
        return(
            <p style={{textAlign:'center', height:'200px', placeContent:'center'}}>{error}</p>
        );
    }

    return (
        <div className="profile-page">
            <div className="dashboard-header">
                <h1>My Profile</h1>
                <p className="dashboard-subtitle">Your account details</p>
            </div>
            <div className="profile-card">
                <h2>Account</h2>
                <div className="profile-row">
                    <span className="label">Customer Id</span>
                    <span className="value">{userInfo.id || "—"}</span>
                </div>
                <div className="profile-row">
                    <span className="label">Name</span>
                    <span className="value">{userInfo.first_name} {userInfo.last_name}</span>
                </div>
                <div className="profile-row">
                    <span className="label">Gender</span>
                    <span className="value">{userInfo.gender}</span>
                </div>
                <div className="profile-row">
                    <span className="label">Email</span>
                    <span className="value">{userInfo.email || "—"}</span>
                </div>
                <div className="profile-row">
                    <span className="label">Phone</span>
                    <span className="value">{userInfo.phone || "—"}</span>
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
