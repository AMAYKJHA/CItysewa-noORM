import { Link } from 'react-router-dom';
import '../../Style/Home.css';

const JoinUs = () => {
    return (
        <section className="join-us-section">
            <h2>Join Our Growing Community</h2>
            <p className="subtitle">Be part of the hyperlocal service revolution</p>
            
            <div className="join-options">
                <div className="join-card provider">
                    <div className="icon">🔧</div>
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
                    <div className="icon">👤</div>
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
                    <div className="icon">💻</div>
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
