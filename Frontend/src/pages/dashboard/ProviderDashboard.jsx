import "../../Style/Dashboard.css";
import { useAuth } from "../../hooks/useAuth";

const ProviderDashboard = () => {
    const {user} = useAuth();
    if(!user) return <p>Loading...</p>;
    return(
        <section className="provider-dashboard" style={{color:'white'}}>
            <h2>Provider Dashboard</h2>
            <h3>Welcome, {user.first_name} {user.last_name}</h3>
            <p>You are {user.is_verified? "a verified" : "an unverified"} provider</p>
        </section>
    );
};

export default ProviderDashboard;