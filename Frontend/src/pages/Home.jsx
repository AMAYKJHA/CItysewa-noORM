import FeaturedServices from '../components/home/FeaturedServices';
import Reviews from '../components/home/Reviews';
import JoinUs from '../components/home/JoinUs';
import Stats from '../components/home/Stats';
import '../Style/Home.css';
import { Link } from 'react-router-dom';

const Hero = () => {
    return (
        <section className="hero">
            <div className="hero-content">
                <h1 className="hero-title">Connect with Local Experts</h1>
                <p className="hero-subtitle">Find trusted service providers in your neighborhood for any need</p>
                <div className="hero-cta">
                    <Link to="/services" className="cta-primary">Browse Services</Link>
                    <Link to="/about" className="cta-secondary">Learn More</Link>
                </div>
            </div>
        </section>
    );
};

const Home = () => {
    return (
        <main className="home">
            <Hero />
            <FeaturedServices />
            <Reviews />
            <Stats />
            <JoinUs />
        </main>
    );
};

export default Home;