import { useState, useEffect } from 'react';
import { fetchServices } from '../../api/client';
import '../../Style/Home.css';

const FeaturedServices = () => {
    const [services, setServices] = useState([]);
    const [currentIndex, setCurrentIndex] = useState(0);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const getServices = async () => {
            try {
                const response = await fetchServices();
                // Filter only featured services or just take first 6
                const featured = response.data?.results?.slice(0, 6) || [];
                setServices(featured);
            } catch (error) {
                console.error('Failed to fetch services:', error);
                setServices([]);
            } finally {
                setLoading(false);
            }
        };
        getServices();
    }, []);

    const nextSlide = () => {
        setCurrentIndex((prev) => (prev + 1) % Math.max(1, services.length));
    };

    const prevSlide = () => {
        setCurrentIndex((prev) => (prev - 1 + services.length) % Math.max(1, services.length));
    };

    if (loading) return <div className="featured-services"><p>Loading services...</p></div>;

    return (
        <section className="featured-services">
            <h2>Featured Services</h2>
            <p className="subtitle">Explore our most popular services</p>
            
            {services.length === 0 ? (
                <p className="no-services">No services available yet.</p>
            ) : (
                <div className="carousel-container">
                    <div className="carousel">
                        {services.map((service, idx) => (
                            <div
                                key={service.id || idx}
                                className={`service-card ${idx === currentIndex ? 'active' : ''}`}
                                style={{
                                    transform: `translateX(${(idx - currentIndex) * 100}%)`,
                                }}
                            >
                                <div className="service-header">
                                    <h3>{service.name || 'Service'}</h3>
                                </div>
                                <p className="service-desc">{service.description || 'Quality service'}</p>
                                <div className="service-footer">
                                    <span className="service-category">{service.category || 'General'}</span>
                                </div>
                            </div>
                        ))}
                    </div>

                    <div className="carousel-controls">
                        <button className="carousel-btn prev" onClick={prevSlide}>❮</button>
                        <div className="carousel-dots">
                            {services.map((_, idx) => (
                                <button
                                    key={idx}
                                    className={`dot ${idx === currentIndex ? 'active' : ''}`}
                                    onClick={() => setCurrentIndex(idx)}
                                />
                            ))}
                        </div>
                        <button className="carousel-btn next" onClick={nextSlide}>❯</button>
                    </div>
                </div>
            )}
        </section>
    );
};

export default FeaturedServices;
