import { Link } from 'react-router-dom';
import '../../Style/Home.css';
import providerIcon from "../../assets/provider.png";
import customerIcon from "../../assets/customer.png";
import teamIcon from "../../assets/team.png";

const JoinUs = () => {
    return (
        <section className="join-us-section">
            <h2>Join Our Growing Community</h2>
            <p className="subtitle">Be part of the hyperlocal service revolution</p>
            
            <div className="join-options">
                <div className="join-card provider">
                    <img src={providerIcon} alt='providericon' width={80} height={80} className="icon"/>
                    <h3>Become a Provider</h3>
                    <p>Grow your service business and reach more customers in your locality.</p>
                    <ul className="benefits">
                        <li>Find customers easily</li>
                        <li>Manage bookings online</li>
                        <li>Build your reputation</li>
                    </ul>
                    <Link to="/register" className="cta-btn provider-btn">Join as Provider</Link>
                </div>

                <div className="join-card customer">
                    <img src={customerIcon} alt='customericon' width={80} height={80} className="icon"/>
                    <h3>Become a Customer</h3>
                    <p>Find trusted local experts for any service you need, all in one place.</p>
                    <ul className="benefits">
                        <li>Browse vetted providers</li>
                        <li>Easy booking process</li>
                        <li>Secure payments</li>
                    </ul>
                    <Link to="/register" className="cta-btn customer-btn">Join as Customer</Link>
                </div>

                <div className="join-card developer">
                    <img src={teamIcon} alt='teamicon' width={80} height={80} className="icon"/>
                    <h3>Join Our Team</h3>
                    <p>Help us build the next-generation hyperlocal marketplace platform.</p>
                    <ul className="benefits">
                        <li>Innovative technology</li>
                        <li>Impactful work</li>
                        <li>Great team</li>
                    </ul>
                    <Link to="/join-our-team" className="cta-btn dev-btn">Join Our Team</Link>
                </div>
            </div>
        </section>
    );
};

export default JoinUs;
