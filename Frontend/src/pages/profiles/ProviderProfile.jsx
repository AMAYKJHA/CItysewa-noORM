import { useEffect, useState } from "react";
import "../../Style/Profiles.css";
import "../../Style/SectionPages.css";
import { fetchVerificationData } from "../../api/client";
import VerificationForm from "./components/VerificationForm";
import VerificationDetails from "./components/VerificationDetails";

const ProviderProfile = () => {
    const [loading, setLoading] = useState(true);
    const [verification, setVerification] = useState(null);

    useEffect(() => {
        const loadVerificationData = async () => {
            try {
                const res = await fetchVerificationData();
                setVerification(res.data);
            } catch (err) {
                console.log(err);
            } finally {
                setLoading(false);
            }
        };
        loadVerificationData();
    }, []);

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
                <h2>Verification</h2>
                {!verification?.is_verified ? <VerificationForm /> : <VerificationDetails data={verification} />}
            </section>
        </div>
    );
};

export default ProviderProfile;