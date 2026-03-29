import { useEffect, useState } from "react";
import "../../Style/Profiles.css";
import "../../Style/SectionPages.css";
import { useAuth } from "../../hooks/useAuth";
import { fetchProviderById } from "../../api/client";
import VerificationForm from "./components/VerificationForm";
import VerificationDetails from "./components/VerificationDetails";

const ProviderProfile = () => {
    const { user } = useAuth();
    const [loading, setLoading] = useState(true);
    const [userInfo, setUserInfo] = useState(null);

    if (!user) return <div className="profile-page"><div className="dashboard-loading">Loading…</div></div>;

    useEffect(() => {
    const loadUserData = async () => {
        if (!user) return;
        try {
            const res = await fetchProviderById(user.id);
            setUserInfo(res.data);
        } catch (err) {
            console.log(err);
        } finally {
            setLoading(false);
        }
    };

    loadUserData();
}, [user]);

    if (loading) {
        return <div className="profile-page"><div className="dashboard-loading">Loading profile…</div></div>;
    }
    return (
        <div className="profile-page">
            <div className="dashboard-header">
                <h1>My Profile</h1>
                <p className="dashboard-subtitle">Verification and account details</p>
            </div>
            <section className="provider-profile profile-card">
                {!userInfo.verified || false ? <VerificationForm /> : <VerificationDetails/>}
            </section>
        </div>
    );
};

export default ProviderProfile;