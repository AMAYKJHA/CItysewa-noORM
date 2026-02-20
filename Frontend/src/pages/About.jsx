import "../Style/About.css";
import trustIcon from "../assets/trust.png";
import communityIcon from "../assets/community.png";
import convenienceIcon from "../assets/convenience.png";
import opportunityIcon from "../assets/opportunity.png";

const About = () => {
    return (
        <div className="about-page">
            <div className="about-hero">
                <h1>About CitySewa</h1>
                <p className="about-subtitle">Connecting Local Services with Local Communities</p>
            </div>

            <div className="about-content">
                <section className="about-section">
                    <h2>Our Mission</h2>
                    <p>
                        <strong>CitySewa</strong> is a hyperlocal service marketplace that connects trusted local service providers with customers in their community. Whether you need an electrician, plumber, cook, or tutor—or you&apos;re a skilled professional looking for work—CitySewa makes the connection simple and reliable.
                    </p>
                </section>

                <section className="about-section">
                    <h2>What We Do</h2>
                    <p>
                        We help local service providers get discovered by the right customers while making it easy for users to find quality services, right when they need them. By bridging local skills with local demand, CitySewa supports livelihoods, strengthens communities, and simplifies everyday life.
                    </p>
                </section>

                <section className="about-section">
                    <h2>Our Values</h2>
                    <div className="values-grid">
                        <div className="value-card">
                            <img src={trustIcon} alt="Trust" width={100} height={100} className="value-icon"/>
                            <h3>Trust</h3>
                            <p>We verify providers to ensure quality and reliability</p>
                        </div>
                        <div className="value-card">
                            <img src={communityIcon} alt="Community" width={100} height={100} className="value-icon"/>
                            <h3>Community</h3>
                            <p>Supporting local businesses and strengthening neighborhoods</p>
                        </div>
                        <div className="value-card">
                            <img src={convenienceIcon} alt="Convenience" width={100} height={100} className="value-icon"/>
                            <h3>Convenience</h3>
                            <p>Easy booking and seamless service delivery</p>
                        </div>
                        <div className="value-card">
                            <img src={opportunityIcon} alt="Opportunity" width={100} height={100} className="value-icon"/>
                            <h3>Opportunity</h3>
                            <p>Creating earning opportunities for local professionals</p>
                        </div>
                    </div>
                </section>

                <section className="about-section about-cta">
                    <h2>Join The Community</h2>
                    <p>Be part of the hyperlocal service revolution</p>
                    <div className="cta-buttons">
                        <a href="/register" className="cta-btn cta-btn--primary">Become a Provider</a>
                        <a href="/register" className="cta-btn cta-btn--secondary">Sign Up as Customer</a>
                    </div>
                </section>
            </div>
        </div>
    );
};

export default About;
